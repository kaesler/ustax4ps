module GoldenTestsAgainstScalaImpl
  ( runAllTests
  ) where

import Prelude
import Data.Date (Year)
import Data.Enum (toEnum)
import Data.Int (toNumber)
import Data.Maybe (fromJust)
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Partial.Unsafe (unsafePartial)
import TaxMath (roundHalfUp)
-- TODO: redirect to new code
import Taxes (federalTaxDue, maStateTaxDue)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import TestDataFromScala (TestCase(..), cases)

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        testsAgainstScala

type Expectation
  = Aff Unit

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
