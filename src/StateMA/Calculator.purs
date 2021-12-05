module StateMA.Calculator
  ( taxDue
  , taxRate
  ) where

import Prelude
import Age (isAge65OrOlder)
import CommonTypes (FilingStatus(..), MassachusettsGrossIncome, BirthDate, Money)
import Data.Date (Year)
import Data.Enum (fromEnum)
import Data.Int (toNumber)
import TaxMath (nonNegSub)

taxRate :: Year -> Number
taxRate year
  | fromEnum year == 2020 = 0.05
  | fromEnum year == 2019 = 0.0505
  | fromEnum year == 2018 = 0.051
  | fromEnum year < 2018 = 0.051
  | otherwise = 0.05

personalExemptionFor :: Year -> FilingStatus -> Money
personalExemptionFor _ HeadOfHousehold = 6800.0

personalExemptionFor _ Single = 4400.0

taxDue :: Year -> BirthDate -> Int -> FilingStatus -> MassachusettsGrossIncome -> Number
taxDue year bd dependents filingStatus maGrossIncome =
  let
    personalExemption = personalExemptionFor year filingStatus

    ageExemption = if isAge65OrOlder bd year then 700.0 else 0.0

    dependentsExemption = 1000.0 * toNumber dependents
  in
    taxRate year
      * ( maGrossIncome
            `nonNegSub`
              ( personalExemption + ageExemption + dependentsExemption
              )
        )
