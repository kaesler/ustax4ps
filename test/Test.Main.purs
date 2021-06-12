module Test.Main where

import Prelude
import Data.Array as Array
import Data.Int (toNumber)
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..), curry)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import PropertyTests (runPropertyTests)
import Taxes (FilingStatus(..), OrdinaryRate, StandardDeduction(..), applyOrdinaryIncomeBrackets, federalTaxDue, incomeToEndOfOrdinaryBracket, maStateTaxDue, nonNeg, ordinaryRatesExceptTop, roundHalfUp, standardDeduction, taxToEndOfOrdinaryIncomeBracket)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import TestDataFromScala (TestCase(..), cases)

type Expectation
  = Aff Unit

main :: Effect Unit
main = do
  runPropertyTests
  log "Running Spec tests"
  launchAff_
    $ runSpec [ consoleReporter ] do
        correctAtBracketBoundaries
        testsAgainstScala

logInAff :: String -> Aff Unit
logInAff msg = liftEffect $ log msg

correctAtBracketBoundaries :: Spec Unit
correctAtBracketBoundaries =
  describe "Correct at bracket boundaries" do
    it "Correct at bracket bundaries for Single" do
      assertCorrectTaxDueAtBracketBoundaries Single
    it "Correct at bracket boundaries for HeadOfHousehold" do
      assertCorrectTaxDueAtBracketBoundaries HeadOfHousehold

assertCorrectTaxDueAtBracketBoundary :: FilingStatus -> OrdinaryRate -> Expectation
assertCorrectTaxDueAtBracketBoundary filingStatus bracketRate =
  let
    StandardDeduction deduction = standardDeduction filingStatus

    income = incomeToEndOfOrdinaryBracket filingStatus bracketRate

    taxableIncome = nonNeg $ income - toNumber deduction

    expectedTax = roundHalfUp $ taxToEndOfOrdinaryIncomeBracket filingStatus bracketRate

    computedTax = roundHalfUp $ applyOrdinaryIncomeBrackets filingStatus taxableIncome
  in
    do
      computedTax `shouldEqual` expectedTax

assertCorrectTaxDueAtBracketBoundaries :: FilingStatus -> Expectation
assertCorrectTaxDueAtBracketBoundaries filingStatus =
  let
    brackets = ordinaryRatesExceptTop filingStatus

    incomes = map (incomeToEndOfOrdinaryBracket filingStatus) brackets

    expectedTaxes = map (taxToEndOfOrdinaryIncomeBracket filingStatus) brackets

    StandardDeduction deduction = standardDeduction filingStatus

    federalExpectations = Array.zipWith (curry taxDueIsAsExpected) incomes expectedTaxes
      where
      taxDueIsAsExpected :: (Tuple Number Number) -> Expectation
      taxDueIsAsExpected (Tuple income expectedTax) =
        let
          taxableIncome = nonNeg $ income - toNumber deduction

          computedTax = roundHalfUp $ applyOrdinaryIncomeBrackets filingStatus taxableIncome
        in
          do
            computedTax `shouldEqual` roundHalfUp expectedTax
  in
    (sequence federalExpectations) *> (pure unit)

testsAgainstScala :: Spec Unit
testsAgainstScala =
  let
    year :: Int
    year = 2021

    makeFederalExpectation :: TestCase -> Expectation
    makeFederalExpectation (TestCase tc) =
      let
        calculated = roundHalfUp $ federalTaxDue year tc.filingStatus (toNumber tc.socSec) (toNumber tc.ordinaryIncomeNonSS) (toNumber tc.qualifiedIncome)
      in
        do
          calculated `shouldEqual` (toNumber tc.federalTaxDue)

    federalExpectations :: Array Expectation
    federalExpectations = map makeFederalExpectation cases

    combinedFederalExpectations :: Expectation
    combinedFederalExpectations = (sequence federalExpectations) *> (pure unit)

    makeStateExpectation :: TestCase -> Expectation
    makeStateExpectation (TestCase tc) =
      let
        calculated = roundHalfUp $ maStateTaxDue year tc.dependents tc.filingStatus (toNumber (tc.ordinaryIncomeNonSS + tc.qualifiedIncome))
      in
        do
          calculated `shouldEqual` (toNumber tc.stateTaxDue)

    stateExpectations :: Array Expectation
    stateExpectations = map makeStateExpectation cases

    combinedStateExpectations :: Expectation
    combinedStateExpectations = (sequence stateExpectations) *> (pure unit)
  in
    describe "Taxes" do
      it ".federalTaxDue matches outputs sampled from Scala implementation" do
        combinedFederalExpectations
      it ".stateTaxDue matches outputs sampled from Scala implementation" do
        combinedStateExpectations
