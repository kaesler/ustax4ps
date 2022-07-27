module FutureYearsGoldenTestCasesFromScala
  ( TestCase(..)
  , cases
  ) where

import CommonTypes (FilingStatus(..))
import Data.Date (Date, Year)
import Federal.Regime (Regime (..))
import Moneys (Deduction, Income, TaxPayable, makeFromInt)
import Prelude (class Show, show)
import UnsafeDates (unsafeMakeDate, unsafeMakeYear)

newtype TestCase
  = TestCase
  { regime :: Regime
  , year :: Year
  , estimatedAnnualInflationFactor :: Number   
  , birthDate :: Date
  , personalExemptions :: Int
  , filingStatus :: FilingStatus
  , socSec :: Income
  , ordinaryIncomeNonSS :: Income
  , qualifiedIncome :: Income
  , itemizedDeductions :: Deduction 
  , federalTaxDue :: TaxPayable
  , stateTaxDue :: TaxPayable
  }

instance showTestCase :: Show TestCase where
  show (TestCase tc) = show tc

cases :: Array TestCase
cases =
  [ 
  ]