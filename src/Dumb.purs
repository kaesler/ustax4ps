module Dumb where

import Prelude
import Data.Functor

import Data.Functor as Functor

doubleit :: Number -> Number
doubleit x = x + x 

two :: Int
two = 10

brackets :: Array Int
brackets = [0, 10, 15]

bracketsDoubled :: Array Int
bracketsDoubled = Functor.map (\t -> t + t) brackets
