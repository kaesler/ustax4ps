module Main where

import Prelude
import Data.Date (Date, Year)
import Data.Enum (fromEnum)
import Effect (Effect)
import Effect.Console (log)
import CommonTypes (Age(..), FilingStatus(..), unsafeReadFilingStatus)
import Federal.BoundRegime (BoundRegime(..), bindRegime, standardDeduction)
import Federal.Calculator as FedCalc
import Federal.OrdinaryIncome (OrdinaryRate(..), OrdinaryIncomeBrackets, applyOrdinaryIncomeBrackets, ordinaryIncomeBracketStart, ordinaryIncomeBracketWidth, ordinaryRateSuccessor, unsafeOrdinaryRateSuccessor)
import Federal.QualifiedIncome (startOfNonZeroQualifiedRateBracket)
import Federal.Regime (Regime(..))
import Federal.RMDs (rmdFractionForAge, unsafeRmdFractionForAge)
import Federal.TaxableSocialSecurity as TSS
import StateMA.Calculator as StateCalc
import UnsafeDates (unsafeMakeDate, unsafeMakeYear)

print :: forall x. Show x => x -> Effect Unit
print x = log $ show x

theYear2030 :: Year
theYear2030 = unsafeMakeYear 2030

theYear2040 :: Year
theYear2040 = unsafeMakeYear 2040

theYear :: Year
theYear = unsafeMakeYear 2021

theRegime :: Regime
theRegime = Trump

theBirthDate :: Date
theBirthDate = unsafeMakeDate 2021 10 2

bracketsFor :: FilingStatus -> OrdinaryIncomeBrackets
bracketsFor fs =
  let
    BoundRegime br = bindRegime theRegime (fromEnum theYear) fs theBirthDate (if fs == Single then 1 else 2)
  in
    br.ordinaryIncomeBrackets

singleBrackets :: OrdinaryIncomeBrackets
singleBrackets = bracketsFor Single

headOfHouseholdBrackets :: OrdinaryIncomeBrackets
headOfHouseholdBrackets = bracketsFor HeadOfHousehold

main :: Effect Unit
main = do
  print $ applyOrdinaryIncomeBrackets headOfHouseholdBrackets 50000.0
  print $ FedCalc.taxDue theRegime theYear2030 Single theBirthDate 1 40000.0 40000.0 5000.0 0.0
  print $ StateCalc.taxDue theYear2030 1 Single 50000.0
  print $ ordinaryIncomeBracketStart singleBrackets (OrdinaryRate 22.0)
  print $ ordinaryIncomeBracketWidth singleBrackets (OrdinaryRate 22.0)
  print $ ordinaryRateSuccessor headOfHouseholdBrackets (OrdinaryRate 22.0)
  print $ rmdFractionForAge (Age 76)
  ( let
      BoundRegime br = bindRegime theRegime (fromEnum theYear) Single theBirthDate 1
    in
      print $ startOfNonZeroQualifiedRateBracket br.qualifiedIncomeBrackets
  )
  ( let
      br = bindRegime theRegime (fromEnum theYear) Single theBirthDate 1
    in
      print $ standardDeduction br
  )
  print $ TSS.amountTaxable HeadOfHousehold 40000.0 40000.0
  print $ TSS.amountTaxableInflationAdjusted theYear2040 Single 50000.0 40000.0
  print $ OrdinaryRate 22.0
  print $ unsafeOrdinaryRateSuccessor singleBrackets (OrdinaryRate 22.0)
  print $ unsafeReadFilingStatus "Single"
  print $ unsafeRmdFractionForAge 76
  print $ StateCalc.taxRate
