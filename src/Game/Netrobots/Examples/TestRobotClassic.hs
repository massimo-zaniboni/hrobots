{-# LANGUAGE ScopedTypeVariables #-}

-- | A Robot with imperative-like code, for testing the ZMQ and Protobuffer part,
--   before encapsulating the control logic in more advanced libraries.
module Game.Netrobots.Examples.TestRobotClassic(
  ConnectionConfiguration(..)
  , robotClassic
  ) where

import System.ZMQ4.Monadic
import Control.Monad (forever)
import Data.ByteString.Char8 (pack, unpack)
import Control.Concurrent (threadDelay)
import Text.ProtocolBuffers.Basic
import Text.ProtocolBuffers.WireMessage
import Text.ProtocolBuffers.Reflections
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Angle as Angle

import Game.Netrobots.Proto.CreateRobot as CreateRobot
import Game.Netrobots.Proto.RobotCommand as RobotCommand
import Game.Netrobots.Proto.DeleteRobot
import Game.Netrobots.Proto.Drive as Drive
import Game.Netrobots.Proto.Scan as Scan
import Game.Netrobots.Proto.Cannon as Cannon
import Game.Netrobots.Proto.MainCommand
import Game.Netrobots.Proto.RobotStatus as Status
import Game.Netrobots.Proto.ScanStatus as ScanStatus

-- NOTE the context can not be captured and exported outside the runZMQ monad, so all other data exchange must be made using normal function parameters. So a runZMQ act like a single/unique/distinct thread, and only it can use the socket. Multiple thread can use some configuration of sockets for sending multiple messages, and queue them.
-- TODO verificare che se non mando comandi il server tiene buona l'ultima speed e direction ma non fa SCAN e non lancia CANNON, oppure fa nache SCAN tanto e` gratis ma non lancia CANNON
data ConnectionConfiguration
       = ConnectionConfiguration {
           gameServerAddress :: String
         , robotName :: String
         } deriving (Eq, Show, Ord)

-- | X,Y pont.
type Point = (Int, Int)

robotClassic :: ConnectionConfiguration -> IO ()
robotClassic connConf = runZMQ $ do
  s <- socket Req
  connect s (gameServerAddress connConf)
  let cmd = MainCommand {
             createRobot = Just $ defaultRobotParams $ robotName connConf
           , robotCommand = Nothing
           , deleteRobot = Nothing
           }
         
  st <- sendMainCmd s cmd
  let tok = Status.token st

  gotoPosition s tok (100,200) 

  return ()
 where
   
  waitStatus s tok
    = let cmd = defaultValue { RobotCommand.token = tok }
      in sendMainCmd s (defaultValue { robotCommand = Just cmd})

  sendMainCmd s cmd
    = do liftIO $ putStrLn $ "Send command: " ++ show cmd
         let protoCmd = LBS.toStrict $ messagePut cmd
         send s [] protoCmd
         bs <- receive s
         let status :: RobotStatus = fromProtoBuffer $ LBS.fromStrict bs
         liftIO $ putStrLn $ "Robot status: " ++ show status ++ "\n"
         return status
         
  sendCmd s tok cmd
    = do let mainCmd = MainCommand {
                         createRobot = Nothing
                         , robotCommand = Just $ cmd { RobotCommand.token = tok } 
                         , deleteRobot = Nothing
                         }
         sendMainCmd s mainCmd
   
  distance :: Point -> Point -> Double
  distance (x0, y0) (x1, y1)
   = let d :: Int -> Int -> Double
         d a b = (fromIntegral a - fromIntegral b) ** 2 
     in  sqrt $ d x1 x0 + d y1 y0

  gotoPosition s tok (x1, y1)
    = do s1 <- waitStatus s tok
         let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)
         let (Angle.Degrees dg) = Angle.degrees $ Angle.Radians $ atan2 (fromIntegral $ y1 - y0) (fromIntegral $ x1 - x0)
         let heading = fromInteger $ toInteger $ round dg 
         let driveCmd = Drive { Drive.speed = 100, Drive.direction = heading }
         s2 <- sendCmd s tok (defaultValue { RobotCommand.drive = Just driveCmd })
         waitNearPosition s tok (x1, y1)
         _ <- sendCmd s tok (defaultValue { RobotCommand.drive = Just $ Drive { Drive.speed = 0, Drive.direction = heading }})
         waitStopMovement s tok
         return ()

  waitNearPosition s tok (x1, y1)
    = do s1 <- waitStatus s tok
         let (x0, y0) = (fromIntegral $ x s1, fromIntegral $ y s1)
         let d1 = distance (x0, y0) (x1, y1)
         case d1 > 80.0 of
           True -> waitNearPosition s tok (x1, y1)
           False -> return ()
           
  waitStopMovement s tok 
   = do s1 <- waitStatus s tok 
        case (Status.speed s1) > 0 of
          True -> waitStopMovement s tok
          False -> return ()
          
fromProtoBuffer :: (ReflectDescriptor msg, Wire msg) => ByteString -> msg
fromProtoBuffer bs
  = case messageGet bs of
      Left err -> error $ "Error reading proto buffer message: " ++ err
      Right (r, _) -> r

defaultRobotParams :: String -> CreateRobot
defaultRobotParams robotName
  = CreateRobot {
      CreateRobot.name = uFromString robotName
      , maxHitPoints = -1
      , CreateRobot.maxSpeed = -1
      , acceleration = -1
      , decelleration = -1
      , maxSterlingSpeed = -1
      , maxScanDistance = -1
      , maxFireDistance = -1
      , bulletSpeed = -1
      , bulletDamage = -1
      , reloadingTime = -1
      }
