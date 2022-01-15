module Brackets
  ( Brackets
  , bracketWidth
  , fromPairs
  , inflateThresholds
  , rateSuccessor
  , ratesExceptTop
  , taxToEndOfBracket
  , taxableIncomeToEndOfBracket
  )
  where

import Data.Maybe
import Prelude

import Data.Map (Map)
import Data.Tuple (Tuple)
import Moneys (IncomeThreshold, TaxPayable, TaxableIncome)
import TaxRate (class TaxRate)
import Undefined (undefined)

type Brackets :: forall k. k -> Type
type Brackets r = forall r. Map r IncomeThreshold

fromPairs :: forall r. TaxRate r => Array (Tuple Number Int) -> (Number -> r) -> (Brackets r)
fromPairs = undefined

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