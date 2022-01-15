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

import Data.Maybe
import Prelude
import Data.Map (Map, keys)
import Data.Map as Map
import Data.Tuple (Tuple(..))
import Moneys (IncomeThreshold, TaxPayable, TaxableIncome, makeFromInt)
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
inflateThresholds = undefined

rateSuccessor :: forall r. TaxRate r => r -> Brackets r -> Maybe r
rateSuccessor = undefined

ratesExceptTop :: forall r. TaxRate r => Brackets r -> Array r
ratesExceptTop = undefined

taxableIncomeToEndOfBracket :: forall r. TaxRate r => Brackets r -> r -> TaxableIncome
taxableIncomeToEndOfBracket = undefined

bracketWidth :: forall r. TaxRate r => Brackets r -> r -> TaxableIncome
bracketWidth = undefined

taxToEndOfBracket :: forall r. TaxRate r => Brackets r -> r -> TaxPayable
taxToEndOfBracket = undefined
