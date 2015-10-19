{-# LANGUAGE ScopedTypeVariables, Arrows #-}

-- | A Netwire FRP executable model for the Netrobots game.
module Game.Netrobots.FRP.Robot where

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

import Control.Applicative
import Control.Arrow
import Data.Angle

import Game.Netrobots.Proto.CreateRobot as CreateRobot
import Game.Netrobots.Proto.RobotCommand as RobotCommand
import Game.Netrobots.Proto.DeleteRobot
import Game.Netrobots.Proto.Drive as Drive
import Game.Netrobots.Proto.Scan as Scan
import Game.Netrobots.Proto.Cannon as Cannon
import Game.Netrobots.Proto.MainCommand
import Game.Netrobots.Proto.RobotStatus as Status
import Game.Netrobots.Proto.ScanStatus as ScanStatus

import Game.Netrobots.Game
import qualified Control.Monad.State.Lazy as MS
import Control.Wire.Core
import Control.Wire.Switch
import Control.Wire.Event
import Prelude hiding ((.), id, until)

-- ----------------------------------------------------------
-- HRobot Netwire related definitions

-- | The state of a Robot. The state is shared with all the Wires of the FRP Network. In this case is it a Satete Monad, so each node can read and modify some part of the shared state.
type HRobotCommand
       = MS.State (Status.RobotStatus, Maybe Drive.Drive, Maybe Scan.Scan, Maybe Cannon.Cannon)

-- | The wire of robots:
--   * use Float as time
--   * use () as error 
--   * run inside HRobotCommand state monad, that stores the selected commands, and the robot status
type HRobotWire a b = Wire Float () HRobotCommand a b

-- | True if the robot has win (the last robot on the Board)
--   False if the robot was destroyed.
--   TODO extend the server for supporting WIN/LOOSE situations
type IsWinner = Bool

-- | Execute a HRobot until completition.
runHRobot
  :: ConnectionConfiguration
  -> CreateRobot.CreateRobot
  -> a
  -> HRobotWire a b
  -> IO IsWinner

runHRobot connConf robotParams input0 wire0 = runZMQ $ do

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
      -> runHRobot' s tok 0 state0 (Right input0) wire0

 where

  runHRobot' sock tok time1 robotState1 input1 wire1 = 
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
                            (stepWire wire1 deltaTime input1)
                            (robotState1, Nothing, Nothing, Nothing)

                      (_, driveCmd, scanCmd, fireCmd)
                        = case maybeErr of
                             Left _ -> (robotState1, Nothing, Nothing, Nothing)
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
                        runHRobot' sock tok time2 robotState2 input1 wire2 

  sendMainCmd s cmd
    = do 
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

-- | Execute a default Robot initialization, and run it.
runHRobotWithDefaultParams :: ConnectionConfiguration -> String -> HRobotWire () b -> IO ()
runHRobotWithDefaultParams conf robotName w = do
  runHRobot conf (defaultRobotParams robotName) () w
  return ()


-- -----------------------------------------------------------
-- Basic Robot Wires
-- NOTE: use preferibaly more high level functions instead.

executeDrive :: HRobotWire (Maybe Drive.Drive) ()
executeDrive = mkGen_ $ \v -> do
  (s, _, sc, cn) <- MS.get
  MS.put (s, v, sc, cn)
  return $ Right ()
  
executeScan :: HRobotWire (Maybe Scan.Scan) ()
executeScan = mkGen_ $ \v -> do
  (s, dr, _, cn) <- MS.get
  MS.put (s, dr, v, cn)
  return $ Right ()

executeFire :: HRobotWire (Maybe Cannon.Cannon) ()
executeFire = mkGen_ $ \v -> do
  (s, dr, sc, _) <- MS.get
  MS.put (s, dr, sc, v)
  return $ Right ()

robotStatus :: HRobotWire a Status.RobotStatus
robotStatus = mkGen_ $ \_ -> do
  (s, _, _, _) <- MS.get
  return $ Right s

robot_scanStatus :: HRobotWire a (Maybe ScanStatus)
robot_scanStatus = fmap (Status.scan) robotStatus

-- ------------------------------------------------------------
-- Wires for sending Robot Commands

robotCmd_fire :: HRobotWire (Direction, Distance) ()
robotCmd_fire = proc (a, b) -> do
  executeFire -< Just $ Cannon {
                          Cannon.direction = fromIntegral a
                        , Cannon.distance = fromIntegral b }

robotCmd_drive :: HRobotWire (Direction, Speed) ()
robotCmd_drive = proc (a, b) -> do
  executeDrive -< Just $ Drive {
                          Drive.direction = fromIntegral a
                        , Drive.speed = fromIntegral b }

robotCmd_scan :: HRobotWire (Direction, SemiAperture) ()
robotCmd_scan = proc (a, b) -> do
  executeScan -< Just $ Scan {
                          Scan.direction = fromIntegral a
                        , Scan.semiaperture = fromIntegral b }

robotCmd_disableScan :: HRobotWire a ()
robotCmd_disableScan = proc _ -> do
  executeScan -< Nothing 

-- ------------------------------------------------------------
-- Wires for reading Robot status

-- | The current simulation time expressed in seconds.
robot_globalTime :: HRobotWire a Float
robot_globalTime = proc _ -> do
  s <- robotStatus -< ()
  returnA -< Status.globalTime s

-- | The next command will be executed after this time tick, expressed in seconds.
robot_timeTick :: HRobotWire a Float
robot_timeTick = proc _ -> do
  s <- robotStatus -< ()
  returnA -< Status.timeTick s

-- | The server accept the next command after this time, expressed in seconds.
--   This is the real time the client has for calculating next move, sending the move,
--   and hoping it reach the server in time.
robot_realTimeTick :: HRobotWire a Float
robot_realTimeTick = proc _ -> do
  s <- robotStatus -< ()
  returnA -< Status.realTimeTick s

-- | Robot left power. When 0 the robot is dead.
robot_hp :: HRobotWire a Int
robot_hp = proc _ -> do
  s <- robotStatus -< ()
  returnA -< fromIntegral $ Status.hp s

-- | Robot current direction.
robot_direction :: HRobotWire a Direction
robot_direction = proc _ -> do
  s <- robotStatus -< ()
  returnA -< fromIntegral $ Status.direction s

-- | Robot current speed.
robot_speed :: HRobotWire a Speed
robot_speed = fmap (\s -> fromIntegral $ Status.speed s) robotStatus

robot_x :: HRobotWire a Int
robot_x = fmap (\s -> fromIntegral $ Status.x s) robotStatus

robot_y :: HRobotWire a Int
robot_y = fmap (\s -> fromIntegral $ Status.y s) robotStatus

robot_position :: HRobotWire a Position
robot_position
  = fmap (\s -> (fromIntegral $ Status.x s, fromIntegral $ Status.y s)) robotStatus

robot_isDead :: HRobotWire a Bool
robot_isDead = fmap (Status.isDead) robotStatus

robot_isWinner :: HRobotWire a Bool
robot_isWinner = fmap (Status.isWinner) robotStatus

robot_isWellSpecifiedRobot :: HRobotWire a Bool
robot_isWellSpecifiedRobot = fmap (Status.isWellSpecifiedRobot) robotStatus

robot_maxSpeed :: HRobotWire a Speed
robot_maxSpeed = fmap (\s -> fromIntegral $ Status.maxSpeed s) robotStatus

robot_isReloading :: HRobotWire a Bool
robot_isReloading = fmap (Status.isReloading) robotStatus

robot_firedNewMissile :: HRobotWire a Bool
robot_firedNewMissile = fmap (Status.firedNewMissile) robotStatus

-- | Nothing if no object was found.
robot_scanDistance :: HRobotWire a (Maybe Distance)
robot_scanDistance
  = fmap (\s -> case Status.scan s of
                  Nothing -> Nothing
                  Just s' -> Just $ fromIntegral $ ScanStatus.distance s'
         ) robotStatus

robot_scanDirection :: HRobotWire a (Maybe Direction)
robot_scanDirection
   = fmap (\s -> case Status.scan s of
                  Nothing -> Nothing
                  Just s' -> Just $ fromIntegral $ ScanStatus.direction s'
         ) robotStatus

robot_scanSemiAperture :: HRobotWire a (Maybe SemiAperture)
robot_scanSemiAperture
   = fmap (\s -> case Status.scan s of
                  Nothing -> Nothing
                  Just s' -> Just $ fromIntegral $ ScanStatus.semiaperture s'
         ) robotStatus

-- -----------------------------------------------------------
-- High Level Tasks

robotCmd_gotoForwardPosition :: HRobotWire (Position, Speed) ()
robotCmd_gotoForwardPosition = proc ((x1, y1), speed) -> do
  (x0, y0) <- robot_position -< ()
  let (Angle.Degrees dg) = Angle.degrees $ Angle.Radians $ atan2 (fromIntegral $ y1 - y0) (fromIntegral $ x1 - x0)
  let heading = fromInteger $ toInteger $ round dg
  robotCmd_drive -< (heading, speed)

-- | Goto near position, and the Wire fail when it is near position
robotCmd_gotoNearPosition :: HRobotWire (Position, Speed, Distance) ()
robotCmd_gotoNearPosition = proc (position, speed, distance) -> do
  robotCmd_gotoForwardPosition -< (position, speed)
  whileWire robot_isFarFromPosition -< (position, distance)

robotCmd_changeSpeed :: HRobotWire Speed ()
robotCmd_changeSpeed = proc speed -> do
  direction <- robot_direction -< ()
  robotCmd_drive -< (direction, speed)

-- | Execute until the direction is not reached.
robot_isNearPosition :: HRobotWire (Position, Distance) Bool
robot_isNearPosition = proc ((x1, y1), maxDistance) -> do
  (x0, y0) <- robot_position -< ()
  let d = point_distance (x0, y0) (x1, y1)
  returnA -< (d < (fromIntegral $ maxDistance))

robot_isFarFromPosition :: HRobotWire (Position, Distance) Bool
robot_isFarFromPosition = proc (p, d) -> do
  r <- robot_isNearPosition -< (p, d)
  returnA -< not r

robot_isMoving :: HRobotWire a Bool
robot_isMoving = fmap ((>) 0) robot_speed

-- | Fail when the Wire on the argument fail.
whileWire :: HRobotWire a Bool -> HRobotWire a ()
whileWire w = proc a -> do
  b <- w -< a
  case b of
    True -> returnA -< ()
    False -> zeroArrow -< ()

-- TODO it should calculate stop deceleration, and stop in the correct position
-- and then perform slow adjustement
robotCmd_gotoPositionAndStop :: HRobotWire (Position, Speed) ()
robotCmd_gotoPositionAndStop = proc (position, speed) -> do
  (robotCmd_gotoNearPosition -< (position, speed, 80))
    --> (do robotCmd_changeSpeed -< 0
            whileWire robot_isMoving -< ()
        )

--- --------------------------------------------
-- Example Robots

-- | An example of Robot.
demo1 :: HRobotWire a ()
demo1 = proc _ -> do
          robotCmd_gotoPositionAndStop -< ((100, 200), 100)

demo2 :: HRobotWire a ()
demo2 = proc _ -> do
  robotCmd_gotoNearPosition -< ((100, 200), 100, 80)

-- TODO copy tutorial example
