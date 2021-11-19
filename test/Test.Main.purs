module Test.Main where

import Prelude
import CommonTypes (FilingStatus(..))
import Data.Array as Array
import Data.Date (Year)
import Data.Enum (toEnum)
import Data.Int (toNumber)
import Data.Maybe (fromJust)
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..), curry)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Federal.OrdinaryIncome (OrdinaryRate, applyOrdinaryIncomeBrackets, incomeToEndOfOrdinaryBracket, ordinaryRatesExceptTop, taxToEndOfOrdinaryIncomeBracket)
import Federal.Types (StandardDeduction(..), standardDeduction)
import Partial.Unsafe (unsafePartial)
import PropertyTests (runPropertyTests)
import TaxMath (nonNeg, roundHalfUp)
import Taxes (federalTaxDue, maStateTaxDue, ordinaryIncomeBrackets)
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
    stdDed = standardDeduction filingStatus

    StandardDeduction deduction = stdDed

    brackets = ordinaryIncomeBrackets filingStatus

    income = incomeToEndOfOrdinaryBracket brackets stdDed bracketRate

    taxableIncome = nonNeg $ income - toNumber deduction

    expectedTax = roundHalfUp $ taxToEndOfOrdinaryIncomeBracket brackets bracketRate

    computedTax = roundHalfUp $ applyOrdinaryIncomeBrackets brackets taxableIncome
  in
    do
      computedTax `shouldEqual` expectedTax

assertCorrectTaxDueAtBracketBoundaries :: FilingStatus -> Expectation
assertCorrectTaxDueAtBracketBoundaries filingStatus =
  let
    stdDed = standardDeduction filingStatus

    brackets = ordinaryIncomeBrackets filingStatus

    rates = ordinaryRatesExceptTop brackets

    incomes = map (incomeToEndOfOrdinaryBracket brackets stdDed) rates

    expectedTaxes = map (taxToEndOfOrdinaryIncomeBracket brackets) rates

    StandardDeduction deduction = standardDeduction filingStatus

    federalExpectations = Array.zipWith (curry taxDueIsAsExpected) incomes expectedTaxes
      where
      taxDueIsAsExpected :: (Tuple Number Number) -> Expectation
      taxDueIsAsExpected (Tuple income expectedTax) =
        let
          taxableIncome = nonNeg $ income - toNumber deduction

          computedTax = roundHalfUp $ applyOrdinaryIncomeBrackets brackets taxableIncome
        in
          do
            computedTax `shouldEqual` roundHalfUp expectedTax
  in
    (sequence federalExpectations) *> (pure unit)

testsAgainstScala :: Spec Unit
testsAgainstScala =
  let
    year :: Year
    year = unsafePartial fromJust $ toEnum 2021

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
