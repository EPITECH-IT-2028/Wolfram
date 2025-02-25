module Lib (
  printRule,
  readInt,
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

nextGeneration :: Int -> [Int] -> [Int]
nextGeneration rule cells = nextGen (head cells : cells ++ [last cells])
 where
  nextGen (x : y : z : rest) = applyRule rule (x, y, z) : nextGen (y : z : rest)
  nextGen _ = []

createCell :: Int -> [Int] -> [[Int]]
createCell rule cells = iterate (nextGeneration rule) cells

createGen0 :: Int -> [Int]
createGen0 size = replicate (size * 2) 0 ++ [1] ++ replicate (size * 2) 0

display :: Int -> Char
display 1 = '*'
display 0 = ' '
display _ = ' '

loop :: [[Int]] -> IO ()
loop [] = putStrLn ""
loop (x : xs) = putStrLn (map display x) >> loop xs

cutPart :: Int -> Int -> [Int] -> [Int]
cutPart window move line =
  take window (drop (window * 2 - div window 2 - move) line)

getGenerations :: Int -> Int -> Int -> [[Int]]
getGenerations rule window move =
  map (cutPart window move) (createCell rule (createGen0 window))

printRule :: Int -> Int -> Maybe Int -> Int -> Int -> IO ()
printRule rule start nlines window move =
  case nlines of
    Nothing -> loop (drop start (getGenerations rule window move))
    Just n -> loop (take n (drop start (getGenerations rule window move)))
