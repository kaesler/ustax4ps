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
import Data.Foldable as Foldable
import Data.List (List, find, tail, zip)
import Data.Map (Map, keys)
import Data.Map as Map
import Data.Maybe
import Data.Set as Set
import Data.Tuple (Tuple(..), fst, snd)
import Moneys (IncomeThreshold, TaxPayable, TaxableIncome, applyTaxRate, inflateThreshold, makeFromInt, thresholdAsTaxableIncome, thresholdDifference)
import Partial.Unsafe (unsafePartial)
import Prelude
import TaxRate (class TaxRate)
import Undefined (undefined)

type Brackets r
  = Map r IncomeThreshold

fromPairs :: forall r. (TaxRate r) => Array (Tuple Number Int) -> (Number -> r) -> Brackets r
fromPairs tuples mkRate =
  let
    f :: Tuple Number Int -> Tuple r IncomeThreshold
    f (Tuple rateAsPercentage threshold) = Tuple (mkRate (rateAsPercentage / 100.00)) (makeFromInt threshold)
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
taxableIncomeToEndOfBracket brackets bracketRate =
  let
    successorRate = unsafePartial $ fromJust (rateSuccessor bracketRate brackets)

    startOfSuccessor = unsafePartial $ fromJust (Map.lookup successorRate brackets)
  in
    thresholdAsTaxableIncome startOfSuccessor

safeBracketWidth :: forall r. TaxRate r => Brackets r -> r -> Maybe TaxableIncome
safeBracketWidth brackets rate = do
  let
    rates = (Set.toUnfoldable (Map.keys brackets)) :: List r
  ratesTail <- (tail rates)
  let
    pairs = zip rates ratesTail
  pair <- find (\p -> fst p == rate) pairs
  let
    successor = snd pair
  rateStart <- Map.lookup rate brackets
  successorStart <- Map.lookup successor brackets
  Just (thresholdDifference successorStart rateStart)

bracketWidth :: forall r. TaxRate r => Brackets r -> r -> TaxableIncome
bracketWidth brackets rate = unsafePartial $ fromJust $ safeBracketWidth brackets rate

taxToEndOfBracket :: forall r. TaxRate r => Brackets r -> r -> TaxPayable
taxToEndOfBracket brackets bracketRate =
  let
    relevantRates = Array.takeWhile (_ <= bracketRate) (ratesExceptTop brackets)

    bracketWidths = map (bracketWidth brackets) relevantRates

    pairs = relevantRates `Array.zip` bracketWidths

    taxesDue = map taxForBracket pairs
      where
      taxForBracket (Tuple rate width) = applyTaxRate rate width
  in
    Foldable.fold taxesDue
