module TaxFunction
  ( TaxFunction
  , bracketsTaxFunction
  , flatTaxFunction
  , rateDeltasForBrackets
  , thresholdTaxFunction
  ) where

import Data.List
import Data.Map
import Data.Tuple
import Prelude
import Brackets (Brackets)
import Data.Map as Map
import Moneys (IncomeThreshold, TaxPayable, TaxableIncome, amountOverThreshold, applyTaxRate)
import TaxRate (class TaxRate, absoluteDifference, zeroRate)

type TaxFunction
  = TaxableIncome -> TaxPayable

thresholdTaxFunction :: forall r. TaxRate r => IncomeThreshold -> r -> TaxFunction
thresholdTaxFunction threshold rate ti = applyTaxRate rate (ti `amountOverThreshold` threshold)

flatTaxFunction :: forall r. TaxRate r => r -> TaxFunction
flatTaxFunction = thresholdTaxFunction mempty

bracketsTaxFunction :: forall r. TaxRate r => Brackets r -> TaxFunction
bracketsTaxFunction brackets =
  let
    pairs = rateDeltasForBrackets brackets

    taxFuncs = map (uncurry thresholdTaxFunction) pairs
  in
    fold taxFuncs

rateDeltasForBrackets :: forall r. TaxRate r => Brackets r -> List (Tuple IncomeThreshold r)
rateDeltasForBrackets brackets =
  let
    pairs = (Map.toUnfoldable brackets) :: List (Tuple r IncomeThreshold)

    rates = map fst pairs

    thresholds = map snd pairs

    deltas = zipWith absoluteDifference (zeroRate : rates) rates
  in
    zip thresholds deltas
