module StateMA.Calculator
  ( taxDue
  , taxRate
  ) where

import Age (isAge65OrOlder)
import CommonTypes (FilingStatus(..), BirthDate)
import Data.Array (fold)
import Data.Date (Year)
import Data.Enum (fromEnum)
import Moneys (Deduction, Income, TaxPayable, applyDeductions, makeFromInt)
import Prelude
import StateMA.StateMATaxRate (StateMATaxRate, mkStateMATaxRate)
import TaxFunction (TaxFunction, flatTaxFunction)

taxRate :: Year -> StateMATaxRate
taxRate year = mkStateMATaxRate $ selectRate $ fromEnum year
  where
  selectRate i
    | i == 2020 = 0.05
    | i == 2019 = 0.0505
    | i == 2018 = 0.051
    | i < 2018 = 0.051
    | otherwise = 0.05

taxFunction :: Year -> TaxFunction
taxFunction = flatTaxFunction <<< taxRate

personalExemptionFor :: Year -> FilingStatus -> Deduction
personalExemptionFor _ HeadOfHousehold = makeFromInt 6800

personalExemptionFor _ Single = makeFromInt 4400

taxDue :: Year -> BirthDate -> Int -> FilingStatus -> Income -> TaxPayable
taxDue year bd dependents filingStatus maGrossIncome =
  let
    personalExemption = personalExemptionFor year filingStatus

    ageExemption = makeFromInt (if isAge65OrOlder bd year then 700 else 0)

    dependentsExemption = makeFromInt $ 1000 * dependents

    deductions = fold [ personalExemption, ageExemption, dependentsExemption ]

    taxableIncome = maGrossIncome `applyDeductions` deductions
  in
    taxFunction year taxableIncome
