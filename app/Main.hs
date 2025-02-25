module Main (main) where

import Lib (printRule)

import System.Environment (getArgs)
import System.Exit (ExitCode (ExitFailure), exitWith)

data Conf = Conf
  { rule :: Maybe Int
  , start :: Int
  , nLines :: Maybe Int
  , window :: Int
  , move :: Int
  }

defaultConf :: Conf
defaultConf =
  Conf
    { rule = Nothing
    , start = 0
    , nLines = Nothing
    , window = 80
    , move = 0
    }

getOpts :: Conf -> [String] -> Maybe Conf
getOpts conf [] = Just conf
getOpts conf ("--rule" : v : args) = getOpts (conf{rule = Just (read v)}) args
getOpts conf ("--start" : v : args) = getOpts (conf{start = read v}) args
getOpts conf ("--lines" : v : args) = getOpts (conf{nLines = Just (read v)}) args
getOpts conf ("--window" : v : args) = getOpts (conf{window = read v}) args
getOpts conf ("--move" : v : args) = getOpts (conf{move = read v}) args
getOpts _ _ = Nothing

main :: IO ()
main = do
  args <- getArgs
  case getOpts defaultConf args of
    Just conf -> case rule conf of
      Just r -> printRule r (start conf) (nLines conf) (window conf) (move conf)
      Nothing -> exitWith (ExitFailure 84)
    Nothing -> exitWith (ExitFailure 84)
