module Lib (
  printRule,
) where

import Data.Char (isDigit)
import Data.Maybe (fromJust)
import Text.Printf (printf)

readInt :: [Char] -> Maybe Int
readInt (x : xs) = case (all isDigit (x : xs)) of
  True -> Just (read (x : xs))
  False -> case x == '-' of
    False -> Nothing
    True -> case (all isDigit (xs)) of
      True -> Just (read (x : xs))
      False -> Nothing

applyRule :: Int -> (Int, Int, Int) -> Int
applyRule rule (l, c, r) =
  fromJust (readInt [printf "%08b" rule !! (7 - (l * 4 + c * 2 + r))])

display :: Int -> Char
display 1 = '*'
display 0 = ' '
display _ = ' '

printRule :: Int -> Int -> IO ()
printRule r = printf "Rule %d\n" r
