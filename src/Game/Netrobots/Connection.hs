
module Game.Netrobots.Connection(
  ConnectionConfiguration(..)
  , defaultRobotParams
  ) where

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

data ConnectionConfiguration
       = ConnectionConfiguration {
           gameServerAddress :: String
         , robotName :: String
         } deriving (Eq, Show, Ord)

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


