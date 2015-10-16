{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Game.Netrobots.Examples.TestRobotClassic

import System.Environment
import System.Exit (exitFailure)

runRobot :: String -> Int -> String -> String -> IO ()
runRobot serverAddr zmqPort robotCode robotName' = do
  let conn = ConnectionConfiguration {
               gameServerAddress = "tcp://" ++ serverAddr ++ ":" ++ show zmqPort
               , robotName = robotName'
               }
  case robotCode of
    "classic"
      -> robotClassic conn
    _ -> error $ "Unknown robot code " ++ robotCode     

  return ()

-- | Execute the robot specified on the command line. 
main :: IO ()
main = do
  args <- getArgs
  case args of
    [serverAddr, zmqPortS, robotCode, robotName'] -> do
      let zmqPort :: Int = read zmqPortS 
      runRobot serverAddr zmqPort robotCode robotName' 
    _ -> do
      putStrLn "Usage: hrobots ip port robot_code robot_name"
      exitFailure

test1 = runRobot "127.0.0.1" 1234 "classic" "test" 

