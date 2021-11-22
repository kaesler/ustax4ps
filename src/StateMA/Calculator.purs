module StateMA.Calculator
  ( taxDue
  ) where

import Prelude
import CommonTypes (FilingStatus(HeadOfHousehold), MassachusettsGrossIncome)
import Data.Date (Year)
import Data.Int (toNumber)
import TaxMath (nonNegSub)

taxRate :: Number
taxRate = 0.05

taxDue :: Year -> Int -> FilingStatus -> MassachusettsGrossIncome -> Number
taxDue year dependents filingStatus maGrossIncome =
  let
    personalExemption = if filingStatus == HeadOfHousehold then 6800.0 else 4400.0

    ageExemption = 700.0

    dependentsExemption = 1000.0 * toNumber dependents
  in
    taxRate * (maGrossIncome `nonNegSub` (personalExemption + ageExemption + dependentsExemption))
