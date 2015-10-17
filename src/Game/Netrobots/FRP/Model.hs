{-# LANGUAGE ScopedTypeVariables #-}

-- | A netwire FRP executable model for the Netrobots game.
module Game.Netrobots.FRP.Model(
  HRobotWire
  , hr_x
  , hr_y
  , hr_speed
  , executeDrive
  , executeScan
  , executeFire
  , robotStatus  
  , IsWinner
  , runHRobot  
  ) where

-- TODO vedere cosa serve
import System.ZMQ4.Monadic
import Control.Monad (forever)
import Data.ByteString.Char8 (pack, unpack)
import Control.Concurrent (threadDelay)
import qualified Text.ProtocolBuffers.Basic as PB
import qualified Text.ProtocolBuffers.WireMessage as PB
import qualified Text.ProtocolBuffers.Reflections as PB
import qualified Data.Text as Text
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

import Game.Netrobots.Connection
import qualified Control.Monad.State.Lazy as MS
import Control.Wire.Core
import Prelude hiding ((.), id)

--
-- Robot Model Access
--

-- TODO complete with easy accessible functions

hr_x :: Status.RobotStatus -> Int
hr_x s = fromIntegral $ Status.x s

hr_y :: Status.RobotStatus -> Int
hr_y s = fromIntegral $ Status.y s

hr_speed :: Status.RobotStatus -> Int
hr_speed s = fromIntegral $ Status.speed s

--
-- HRobot Wire Defs
--

type HRobotCommand
       = MS.State (Status.RobotStatus, Maybe Drive.Drive, Maybe Scan.Scan, Maybe Cannon.Cannon)

-- | The wire of robots:
--   * use Float as time
--   * use () as error 
--   * use Status.RobotStatus as input value
--   * run inside HRobotCommand state monad, that stores the selected commands
type HRobotWire a b = Wire Float () HRobotCommand a b

type IsWinner = Bool

-- | Execute a HRobot until completition.
runHRobot
  :: ConnectionConfiguration
  -> CreateRobot.CreateRobot
  -> HRobotWire a b
  -> IO IsWinner

runHRobot connConf robotParams wire0 = runZMQ $ do

  -- Init Robot

  s <- socket Req
  connect s (gameServerAddress connConf)
  let cmd = MainCommand {
             createRobot = Just robotParams
           , robotCommand = Nothing
           , deleteRobot = Nothing
           }

  state0 <- sendMainCmd s cmd
  let tok = Status.token state0
  case Status.isWellSpecifiedRobot state0 of
    False
      -> return False
    True
      -> runHRobot' s tok 0 state0 wire0

 where

  runHRobot' sock tok time1 robotState1 wire1 = 
    case Status.isDead robotState1 of
      True
        -> return False
      False
        -> case Status.isWinner robotState1 of
             True
               -> return True
             False
               -> let time2 = Status.globalTime robotState1
                      deltaTime =  time2 - time1
                      ((maybeErr, wire2), cmd)
                        = MS.runState
                            (stepWire wire1 deltaTime (Right robotState1))
                            (robotState1, Nothing, Nothing, Nothing)

                      (driveCmd, scanCmd, fireCmd)
                        = case maybeErr of
                             Left _ -> (Nothing, Nothing, Nothing)
                                       -- in case of error do not execute any command
                             Right _ -> cmd
                             
                      robotCommand
                        = RobotCommand.RobotCommand {
                              RobotCommand.token = tok
                            , RobotCommand.drive = driveCmd   
                            , RobotCommand.scan = scanCmd
                            , RobotCommand.cannon = fireCmd
                            }
                          
                  in do robotState2 <- sendCmd sock tok robotCommand 
                        runHRobot' sock tok time2 robotState2 wire2 

  -- TODO remove putStrLn commands later 
  sendMainCmd s cmd
    = do liftIO $ putStrLn $ "Send command: " ++ show cmd
         let protoCmd = LBS.toStrict $ PB.messagePut cmd
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

  fromProtoBuffer :: (PB.ReflectDescriptor msg, PB.Wire msg) => LBS.ByteString -> msg
  fromProtoBuffer bs
    = case PB.messageGet bs of
        Left err -> error $ "Error reading proto buffer message: " ++ err
        Right (r, _) -> r

--
-- Basic Wires
--

-- | Change the state of the host Monad.
executeDrive :: Maybe Drive.Drive -> HRobotWire a ()
executeDrive v = mkGen_ $ \_ -> do
  (s, _, sc, cn) <- MS.get
  MS.put (s, v, sc, cn)
  return $ Right ()
  
-- | Change the state of the host Monad.
executeScan :: Maybe Scan.Scan -> HRobotWire a ()
executeScan v = mkGen_ $ \_ -> do
  (s, dr, _, cn) <- MS.get
  MS.put (s, dr, v, cn)
  return $ Right ()

-- | Change the state of the host Monad.
executeFire :: Maybe Cannon.Cannon -> HRobotWire a ()
executeFire v = mkGen_ $ \_ -> do
  (s, dr, sc, _) <- MS.get
  MS.put (s, dr, sc, v)
  return $ Right ()

robotStatus :: HRobotWire a Status.RobotStatus
robotStatus = mkGen_ $ \_ -> do
  (s, _, _, _) <- MS.get
  return $ Right s
