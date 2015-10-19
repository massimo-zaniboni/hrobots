{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | A Robot with imperative-like code.
module Game.Netrobots.Classic.Robot where

import System.ZMQ4.Monadic
import Control.Monad (forever)
import Data.ByteString.Char8 (pack, unpack)
import Control.Concurrent (threadDelay)
import Text.ProtocolBuffers.Basic
import Text.ProtocolBuffers.WireMessage
import Text.ProtocolBuffers.Reflections
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Angle as Angle

import Game.Netrobots.Game
import Game.Netrobots.Proto.CreateRobot as CreateRobot
import Game.Netrobots.Proto.RobotCommand as RobotCommand
import Game.Netrobots.Proto.DeleteRobot
import Game.Netrobots.Proto.Drive as Drive
import Game.Netrobots.Proto.Scan as Scan
import Game.Netrobots.Proto.Cannon as Cannon
import Game.Netrobots.Proto.MainCommand
import Game.Netrobots.Proto.RobotStatus as Status
import Game.Netrobots.Proto.ScanStatus as ScanStatus

-- --------------------------------------------
-- Basic Commands API

-- | Connect to the server. 
initRobot :: ConnectionConfiguration -> RobotSocket z -> ZMQ z RobotToken
initRobot connConf s = do
  connect s (gameServerAddress connConf)
  let cmd = MainCommand {
             createRobot = Just $ defaultRobotParams $ robotName connConf
           , robotCommand = Nothing
           , deleteRobot = Nothing
           }
  st <- sendMainCmd s cmd
  let tok = Status.token st
  return tok

createCmd_fire :: Direction -> Distance -> Cannon
createCmd_fire dir dst
  = Cannon { Cannon.direction = fromIntegral $ dir, Cannon.distance = fromIntegral $ dst }


createCmd_drive :: Direction -> Speed -> Drive
createCmd_drive dir sp
  = Drive { Drive.direction = fromIntegral dir, Drive.speed = fromIntegral sp }

createCmd_scan :: Direction -> SemiAperture -> Scan
createCmd_scan dir ap
  = Scan { Scan.direction = fromIntegral dir, Scan.semiaperture = fromIntegral ap }

-- | Send a command to the server and wait for the answer with the new robot status.
--   A robot can move, scan and fire (if it is not reloading) at each move.
sendCmd :: RobotSocket z -> RobotToken -> Maybe Drive -> Maybe Scan -> Maybe Cannon -> ZMQ z RobotStatus
sendCmd s tok md ms mc
  = do let mainCmd = MainCommand {
                         createRobot = Nothing
                         , robotCommand
                             = Just $ RobotCommand {
                                 RobotCommand.token = tok
                               , RobotCommand.drive = md
                               , RobotCommand.cannon = mc
                               , RobotCommand.scan = ms
                               }
                         , deleteRobot = Nothing
                         }
       sendMainCmd s mainCmd

-- | Do nothing, and wait for the status.
waitStatus :: RobotSocket z -> RobotToken -> ZMQ z RobotStatus 
waitStatus s tok = sendCmd s tok Nothing Nothing Nothing

-- | Internal/private function.
sendMainCmd :: RobotSocket z -> MainCommand -> ZMQ z RobotStatus
sendMainCmd s cmd
    = do liftIO $ putStrLn $ "Send command: " ++ show cmd
         let protoCmd = LBS.toStrict $ messagePut cmd
         send s [] protoCmd
         bs <- receive s
         let status :: RobotStatus = fromProtoBuffer $ LBS.fromStrict bs
         liftIO $ putStrLn $ "Robot status: " ++ show status ++ "\n"
         return status

-- ---------------------------------------------------------------
-- Complex Tasks

task_gotoPosition :: RobotSocket z -> RobotToken -> Point -> ZMQ z ()
task_gotoPosition s tok (x1, y1)
    = do s1 <- waitStatus s tok
         let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)
         let (Angle.Degrees dg) = Angle.degrees $ Angle.Radians $ atan2 (fromIntegral $ y1 - y0) (fromIntegral $ x1 - x0)
         let heading = fromInteger $ toInteger $ round dg 
         let driveCmd = createCmd_drive heading 100
         s2 <- sendCmd s tok (Just driveCmd) Nothing Nothing
         task_waitNearPosition s tok (x1, y1)
         _ <- sendCmd s tok (Just $ createCmd_drive heading 0) Nothing Nothing
         task_waitStopMovement s tok
         return ()

task_waitNearPosition s tok (x1, y1)
    = do s1 <- waitStatus s tok
         let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)
         let d1 = point_distance (x0, y0) (x1, y1)
         case d1 > 80.0 of
           True -> task_waitNearPosition s tok (x1, y1)
           False -> return ()

task_waitStopMovement s tok 
   = do s1 <- waitStatus s tok 
        case (Status.speed s1) > 0 of
          True -> task_waitStopMovement s tok
          False -> return ()

--- --------------------------------------------
-- Example Robots

-- | An example of Robot.
robotClassic :: ConnectionConfiguration -> IO ()
robotClassic connConf = runZMQ $ do
  s <- socket Req
  tok <- initRobot connConf s
  task_gotoPosition s tok (100,200) 
  return ()

-- -------------------------------------------------------------
-- Low Level Functions

fromProtoBuffer :: (ReflectDescriptor msg, Wire msg) => ByteString -> msg
fromProtoBuffer bs
  = case messageGet bs of
      Left err -> error $ "Error reading proto buffer message: " ++ err
      Right (r, _) -> r



