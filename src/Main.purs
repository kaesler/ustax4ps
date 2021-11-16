module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import CommonTypes(Age(..), FilingStatus(..), unsafeReadFilingStatus)
import Taxes ( OrdinaryRate(..), applyOrdinaryIncomeBrackets, federalTaxDue, maStateTaxDue, maStateTaxRate, ordinaryIncomeBracketStart, ordinaryIncomeBracketWidth, ordinaryRateSuccessor, rmdFractionForAge, standardDeduction, startOfNonZeroQualifiedRateBracket, unsafeOrdinaryRateFromNumber, unsafeOrdinaryRateSuccessor, unsafeRmdFractionForAge)
import Federal.TaxableSocialSecurity(taxableSocialSecurity, taxableSocialSecurityAdjusted)
print :: forall x. Show x => x -> Effect Unit
print x = log $ show x

main :: Effect Unit
main = do
  print $ applyOrdinaryIncomeBrackets HeadOfHousehold 50000.0
  print $ federalTaxDue 2030 Single 40000.0 40000.0 5000.0
  print $ maStateTaxDue 65 1 Single 50000.0
  print $ ordinaryIncomeBracketStart Single (OrdinaryRate 22)
  print $ ordinaryIncomeBracketWidth Single (OrdinaryRate 22)
  print $ ordinaryRateSuccessor HeadOfHousehold (OrdinaryRate 22)
  print $ rmdFractionForAge (Age 76)
  print $ startOfNonZeroQualifiedRateBracket Single
  print $ standardDeduction Single
  print $ taxableSocialSecurity HeadOfHousehold 40000.0 40000.0
  print $ taxableSocialSecurityAdjusted 2040 Single 50000.0 40000.0
  print $ unsafeOrdinaryRateFromNumber 22.0
  print $ unsafeOrdinaryRateSuccessor Single (OrdinaryRate 22)
  print $ unsafeReadFilingStatus "Single"
  print $ unsafeRmdFractionForAge 76
  print $ maStateTaxRate
