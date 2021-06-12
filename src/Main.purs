module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Taxes (
  FilingStatus(..)
  , applyOrdinaryIncomeBrackets
  , federalTaxDue
  , maStateTaxDue
  --, ordinaryIncomeBracketStart
  --, ordinaryIncomeBracketWidth
  --, rateSuccessor
  , rmdFractionForAge
  , startOfNonZeroQualifiedRateBracket
  --, stdDeduction
  --, taxableSocialSecurity
  , taxableSocialSecurityAdjusted
  )

-- return Taxes.federalTaxDue(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome);
-- return Taxes.maStateTaxDue(age, filingStatus, dependents, massacchusettsGrossIncome);
-- return Taxes.ordinaryIncomeBracketStart(filingStatus, rate);
-- return Taxes.ordinaryIncomeBracketWidth(filingStatus, rate);
-- return Taxes.rateSuccessor(rate);
-- return Taxes.rmdFractionForAge(age);
-- return Taxes.startOfNonZeroQualifiedRateBracket(filingStatus);
-- return Taxes.stdDeduction(filingStatus);
-- return Taxes.taxableSocialSecurity(filingStatus, socSec, ssRelevantOtherIncome);
-- return Taxes.taxableSocialSecurityAdjusted(year, filingStatus, socSec, ssRelevantOtherIncome);

main :: Effect Unit
main = 
  -- Call these:
  let answer = applyOrdinaryIncomeBrackets HeadOfHousehold 5000000.0
  in
    do
      log $ show answer
      log "Hello sailor!"
