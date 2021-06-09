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
import Taxes (FilingStatus(..), OrdinaryRate, StandardDeduction(..), applyOrdinaryIncomeBrackets, federalTaxDue, incomeToEndOfOrdinaryBracket, nonNeg, ordinaryRatesExceptTop, roundHalfUp, standardDeduction, taxToEndOfOrdinaryBracket)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import TestDataFromScala (TestCase, cases)

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

    expectedTax = roundHalfUp $ taxToEndOfOrdinaryBracket filingStatus bracketRate

    computedTax = roundHalfUp $ applyOrdinaryIncomeBrackets filingStatus taxableIncome
  in
    do
      computedTax `shouldEqual` expectedTax

assertCorrectTaxDueAtBracketBoundaries :: FilingStatus -> Expectation
assertCorrectTaxDueAtBracketBoundaries filingStatus =
  let
    brackets = ordinaryRatesExceptTop filingStatus

    incomes = map (incomeToEndOfOrdinaryBracket filingStatus) brackets

    expectedTaxes = map (taxToEndOfOrdinaryBracket filingStatus) brackets

    StandardDeduction deduction = standardDeduction filingStatus

    expectations = Array.zipWith (curry taxDueIsAsExpected) incomes expectedTaxes
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
    (sequence expectations) *> (pure unit)

testsAgainstScala :: Spec Unit
testsAgainstScala =
  let
    year :: Int
    year = 2021

    makeExpectation :: TestCase -> Expectation
    makeExpectation tc =
      let
        calculated = roundHalfUp $ federalTaxDue year tc.filingStatus (toNumber tc.socSec) (toNumber tc.ordinaryIncome) (toNumber tc.qualifiedIncome)
      in
        do
          calculated `shouldEqual` calculated

    expectations :: Array Expectation
    expectations = map makeExpectation cases

    combinedExpectations :: Expectation
    combinedExpectations = (sequence expectations) *> (pure unit)
  in
    describe "Taxes.federalTaxDue" do
      it "matches outputs sampled from Scala implementation" do
        combinedExpectations
