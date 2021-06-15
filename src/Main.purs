module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Taxes (
  Age(..)
  ,FilingStatus(..)
  , OrdinaryRate(..)
  , applyOrdinaryIncomeBrackets
  , federalTaxDue
  , maStateTaxDue
  , ordinaryIncomeBracketStart
  , ordinaryIncomeBracketWidth
  , ordinaryRateSuccessor
  , rmdFractionForAge
  , standardDeduction
  , startOfNonZeroQualifiedRateBracket
  , taxableSocialSecurity
  , taxableSocialSecurityAdjusted
  , unsafeReadFilingStatus
  )


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
  print $ unsafeReadFilingStatus "Single"
