module Federal.Yearly.Type(
  YearlyValues,
  mkYearlyValues
) where

import Data.Date (Year)
import CommonTypes (FilingStatus)
import Federal.Regime (Regime)
import Moneys (Deduction)
import Federal.OrdinaryBrackets (OrdinaryBrackets)
import Federal.QualifiedBrackets (QualifiedBrackets)

type YearlyValues = {
    regime :: Regime,
    year :: Year,
    perPersonExemption :: Deduction,
    unadjustedStandardDeduction :: FilingStatus -> Deduction,
    adjustmentWhenOver65 :: Deduction,
    adjustmentWhenOver65AndSingle :: Deduction,
    ordinaryBrackets :: FilingStatus -> OrdinaryBrackets,
    qualifiedBrackets :: FilingStatus -> QualifiedBrackets
  }

mkYearlyValues :: 
    Regime -> 
    Year -> 
    Deduction -> 
    (FilingStatus -> Deduction) ->
    Deduction ->
    Deduction -> 
    (FilingStatus -> OrdinaryBrackets) ->
    (FilingStatus -> QualifiedBrackets) -> YearlyValues
mkYearlyValues regime year perPersonExemption unadjustedStandardDeduction adjustmentWhenOver65 adjustmentWhenOver65AndSingle ordinaryBrackets qualifiedBrackets = 
  {
    regime: regime,
    year: year,
    perPersonExemption: perPersonExemption,
    unadjustedStandardDeduction: unadjustedStandardDeduction,
    adjustmentWhenOver65: adjustmentWhenOver65,
    adjustmentWhenOver65AndSingle: adjustmentWhenOver65AndSingle,
    ordinaryBrackets: ordinaryBrackets,
    qualifiedBrackets: qualifiedBrackets
  }