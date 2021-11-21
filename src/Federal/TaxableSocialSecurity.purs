module Federal.TaxableSocialSecurity
  ( amountTaxableInflationAdjusted
  , amountTaxable
  ) where

import Prelude
import Data.Enum (fromEnum)
import Data.Tuple (Tuple(..))
import Data.Int (toNumber)
import Data.Date (Year)
import CommonTypes (CombinedIncome, FilingStatus(..), SSRelevantOtherIncome, SocSec)

amountTaxableInflationAdjusted :: Year -> FilingStatus -> SocSec -> SSRelevantOtherIncome -> Number
amountTaxableInflationAdjusted year filingStatus ssBenefits relevantIncome =
  let
    unadjusted = amountTaxable filingStatus ssBenefits relevantIncome

    adjustmentFactor = 1.0 + (0.03 * toNumber (fromEnum year - 2021))

    adjusted = unadjusted * adjustmentFactor
  in
    min adjusted ssBenefits * 0.85

amountTaxable :: FilingStatus -> SocSec -> SSRelevantOtherIncome -> Number
amountTaxable filingStatus ssBenefits relevantIncome =
  let
    lowBase = case filingStatus of
      Single -> 25000.0
      HeadOfHousehold -> 25000.0

    highBase = case filingStatus of
      Single -> 34000.0
      HeadOfHousehold -> 34000.0

    combinedIncome = relevantIncome + (ssBenefits / 2.0)
  in
    f combinedIncome (Tuple lowBase highBase)
  where
  f :: CombinedIncome -> Tuple CombinedIncome CombinedIncome -> Number
  f combinedIncome (Tuple lowBase highBase)
    | combinedIncome < lowBase = 0.0
    | combinedIncome < highBase =
      let
        fractionTaxable = 0.5

        maxSocSecTaxable = ssBenefits * fractionTaxable
      in
        min ((combinedIncome - lowBase) * fractionTaxable) maxSocSecTaxable
    | true =
      let
        fractionTaxable = 0.85

        maxSocSecTaxable = ssBenefits * fractionTaxable
      in
        min (4500.0 + ((combinedIncome - highBase) * fractionTaxable)) maxSocSecTaxable
