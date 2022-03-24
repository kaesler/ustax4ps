module Federal.TaxableSocialSecurity
  ( amountTaxableInflationAdjusted
  , amountTaxable
  ) where

import Prelude hiding (mul)
import CommonTypes (FilingStatus(..))
import Data.Date (Year)
import Data.Enum (fromEnum)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..))
import Federal.Types (CombinedIncome, SSRelevantOtherIncome, SocSec)
import Moneys (Income, IncomeThreshold, amountOverThreshold, divInt, isBelow, makeFromInt, mul, taxableAsIncome, thresholdDifference)

amountTaxableInflationAdjusted :: Year -> FilingStatus -> SocSec -> SSRelevantOtherIncome -> Income
amountTaxableInflationAdjusted year filingStatus ssBenefits relevantIncome =
  let
    unadjusted = amountTaxable filingStatus ssBenefits relevantIncome

    adjustmentFactor = 1.0 + (0.03 * toNumber (fromEnum year - 2021))

    adjusted = unadjusted `mul` adjustmentFactor
  in
    min adjusted (ssBenefits `mul` 0.85)

amountTaxable :: FilingStatus -> SocSec -> SSRelevantOtherIncome -> Income
amountTaxable filingStatus ssBenefits relevantIncome =
  let
    lowThreshold =
      ( case filingStatus of
          Married -> 32000
          HeadOfHousehold -> 25000
          Single -> 25000
      )
        # makeFromInt

    highThreshold =
      ( case filingStatus of
          Married -> 44000
          HeadOfHousehold -> 34000
          Single -> 34000
      )
        # makeFromInt

    combinedIncome = relevantIncome <> (ssBenefits `mul` 0.5)
  in
    f combinedIncome (Tuple lowThreshold highThreshold)
  where
  f :: CombinedIncome -> Tuple IncomeThreshold IncomeThreshold -> Income
  f combinedIncome (Tuple lowThreshold highThreshold)
    | combinedIncome `isBelow` lowThreshold = makeFromInt 0
    | combinedIncome `isBelow` highThreshold =
      let
        fractionTaxable = 0.5

        maxSocSecTaxable = ssBenefits `mul` fractionTaxable
      in
        min ((combinedIncome `amountOverThreshold` lowThreshold) `mul` fractionTaxable) maxSocSecTaxable
    | true =
      let
        fractionTaxable = 0.85

        maxSocSecTaxable = ssBenefits `mul` fractionTaxable

        halfMiddleBracketWidth = (highThreshold `thresholdDifference` lowThreshold) `divInt` 2
      in
        min
          (taxableAsIncome halfMiddleBracketWidth <> ((combinedIncome `amountOverThreshold` highThreshold) `mul` fractionTaxable))
          maxSocSecTaxable
