
module Game.Netrobots.Game where

import System.ZMQ4.Monadic

import Game.Netrobots.Proto.CreateRobot as CreateRobot
import Game.Netrobots.Proto.RobotCommand as RobotCommand
import Game.Netrobots.Proto.DeleteRobot
import Game.Netrobots.Proto.Drive as Drive
import Game.Netrobots.Proto.Scan as Scan
import Game.Netrobots.Proto.Cannon as Cannon
import Game.Netrobots.Proto.MainCommand
import Game.Netrobots.Proto.RobotStatus as Status
import Game.Netrobots.Proto.ScanStatus as ScanStatus

import Text.ProtocolBuffers.Basic

--
-- Basic Types
--

-- | X,Y point. Board is 1000x1000,
--   with (0,0) at lower left angle of the board,
--   and (999, 999) at upper right angle.
type Point = (Int, Int)

type Position = Point

-- | The dimension on the board of the robot.
robotRadius :: Int
robotRadius = 1

-- | Direction from 0 to 359.
--   0 is EAST, 90 is NORTH, 270 is SOUTH, 189 is WEST.
--
--   >               135    90   45
--   >                   \  |  /
--   >                    \ | /
--   >              180 --- x --- 0
--   >                    / | \
--   >                   /  |  \
--   >               225   270   315
type Direction = Int

-- | Distance from 0 to 999
type Distance = Int

-- | Speed of the robot.
type Speed = Int

-- | From 0 to 180
type SemiAperture = Int

-- | Robot token identifying it in the system.
type RobotToken = Utf8

type RobotSocket z = Socket z Req

--
-- Utility Functions
--

-- | The distance between two points.
point_distance :: Point -> Point -> Double
point_distance (x0, y0) (x1, y1)
 = let d :: Int -> Int -> Double
       d a b = (fromIntegral a - fromIntegral b) ** 2 
   in  sqrt $ d x1 x0 + d y1 y0

--
-- Connection and Initializations
--

data ConnectionConfiguration
       = ConnectionConfiguration {
           gameServerAddress :: String
         , robotName :: String
         } deriving (Eq, Show, Ord)

-- | The initial parameters of a robot.
--   -1 for default values.
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
      , reloadingTime = -1 }
