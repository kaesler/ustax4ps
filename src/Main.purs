module Main where

import Prelude
import CommonTypes (Age(..), FilingStatus(..), unsafeReadFilingStatus)
import Data.Date (Year)
import Data.Enum (toEnum)
import Data.Maybe (fromJust)
import Effect (Effect)
import Effect.Console (log)
import Federal.OrdinaryIncome (OrdinaryRate(..), applyOrdinaryIncomeBrackets, ordinaryIncomeBracketStart, ordinaryIncomeBracketWidth, ordinaryRateSuccessor, unsafeOrdinaryRateSuccessor)
import Federal.QualifiedIncome (startOfNonZeroQualifiedRateBracket)
import Federal.RMDs (rmdFractionForAge, unsafeRmdFractionForAge)
import Federal.TaxableSocialSecurity (taxableSocialSecurity, taxableSocialSecurityAdjusted)
import Federal.Types (standardDeduction)
import Partial.Unsafe (unsafePartial)
import Taxes (federalTaxDue, maStateTaxDue, maStateTaxRate, ordinaryIncomeBrackets)

print :: forall x. Show x => x -> Effect Unit
print x = log $ show x

theYear2030 :: Year
theYear2030 = unsafePartial $ fromJust $ toEnum 2030

theYear2040 :: Year
theYear2040 = unsafePartial $ fromJust $ toEnum 2040

main :: Effect Unit
main = do
  print $ applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets HeadOfHousehold) 50000.0
  print $ federalTaxDue theYear2030 Single 40000.0 40000.0 5000.0
  print $ maStateTaxDue theYear2030 1 Single 50000.0
  print $ ordinaryIncomeBracketStart (ordinaryIncomeBrackets Single) (OrdinaryRate 22.0)
  print $ ordinaryIncomeBracketWidth (ordinaryIncomeBrackets Single) (OrdinaryRate 22.0)
  print $ ordinaryRateSuccessor (ordinaryIncomeBrackets HeadOfHousehold) (OrdinaryRate 22.0)
  print $ rmdFractionForAge (Age 76)
  print $ startOfNonZeroQualifiedRateBracket Single
  print $ standardDeduction Single
  print $ taxableSocialSecurity HeadOfHousehold 40000.0 40000.0
  print $ taxableSocialSecurityAdjusted theYear2040 Single 50000.0 40000.0
  print $ OrdinaryRate 22.0
  print $ unsafeOrdinaryRateSuccessor (ordinaryIncomeBrackets Single) (OrdinaryRate 22.0)
  print $ unsafeReadFilingStatus "Single"
  print $ unsafeRmdFractionForAge 76
  print $ maStateTaxRate
