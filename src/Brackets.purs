module Brackets
  ( Brackets
  , bracketWidth
  , fromPairs
  , inflateThresholds
  , rateSuccessor
  , ratesExceptTop
  , taxToEndOfBracket
  , taxableIncomeToEndOfBracket
  ) where

import Data.Array as Array
import Data.Maybe
import Prelude
import Data.Map (Map, keys)
import Data.Map as Map
import Data.Tuple (Tuple(..), fst, snd)
import Moneys (IncomeThreshold, TaxPayable, TaxableIncome, inflateThreshold, makeFromInt)
import TaxRate (class TaxRate)
import Undefined (undefined)

type Brackets r
  = Map r IncomeThreshold

fromPairs :: forall r. (TaxRate r) => Array (Tuple Number Int) -> (Number -> r) -> Brackets r
fromPairs tuples mkRate =
  let
    f :: Tuple Number Int -> Tuple r IncomeThreshold
    f (Tuple rate threshold) = Tuple (mkRate rate) (makeFromInt threshold)
  in
    Map.fromFoldable $ map f tuples

inflateThresholds :: forall r. TaxRate r => Number -> Brackets r -> Brackets r
inflateThresholds factor = map (inflateThreshold factor)

rateSuccessor :: forall r. TaxRate r => r -> Brackets r -> Maybe r
rateSuccessor rate brackets =
  let
    rates = Array.fromFoldable $ keys brackets

    ratesTail = Array.drop 1 rates

    pairs = Array.zip rates ratesTail

    pair = Array.find (\p -> fst p == rate) pairs
  in
    map snd pair

ratesExceptTop :: forall r. TaxRate r => Brackets r -> Array r
ratesExceptTop brackets =
  let
    rates = Array.fromFoldable $ keys brackets
  in
    Array.dropEnd 1 rates

taxableIncomeToEndOfBracket :: forall r. TaxRate r => Brackets r -> r -> TaxableIncome
taxableIncomeToEndOfBracket = undefined

bracketWidth :: forall r. TaxRate r => Brackets r -> r -> TaxableIncome
bracketWidth = undefined

taxToEndOfBracket :: forall r. TaxRate r => Brackets r -> r -> TaxPayable
taxToEndOfBracket = undefined
