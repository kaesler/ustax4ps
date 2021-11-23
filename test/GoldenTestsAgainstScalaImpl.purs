module GoldenTestsAgainstScalaImpl
  ( runAllTests
  ) where

import Prelude
import CommonTypes (Money)
import Data.Date (Date, Day, Month, Year, canonicalDate)
import Data.Enum (toEnum)
import Data.Int (toNumber)
import Data.Maybe (fromJust)
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Federal.Regime (Regime(..))
import Federal.Calculator (FederalTaxResults(..))
import Federal.Calculator as FC
import Partial.Unsafe (unsafePartial)
import StateMA.Calculator as MA
import GoldenTestCasesFromScala as GTC
import TaxMath (roundHalfUp)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        testsAgainstScala

type Expectation
  = Aff Unit

year2021 :: Year
year2021 = unsafePartial fromJust $ toEnum 2021

october :: Month
october = unsafePartial fromJust $ toEnum 10

second :: Day
second = unsafePartial fromJust $ toEnum 2

birthDate :: Date
birthDate = canonicalDate year2021 october second

itemized :: Money
itemized = 0.0

logInAff :: String -> Aff Unit
logInAff msg = liftEffect $ log msg

testsAgainstScala :: Spec Unit
testsAgainstScala =
  let
    makeFederalExpectation :: GTC.TestCase -> Expectation
    makeFederalExpectation (GTC.TestCase tc) =
      let
        FederalTaxResults results =
          FC.taxResults
            Trump
            year2021
            tc.filingStatus
            birthDate
            (tc.dependents + 1)
            (toNumber tc.socSec)
            (toNumber tc.ordinaryIncomeNonSS)
            (toNumber tc.qualifiedIncome)
            itemized

        calculated = roundHalfUp $ results.taxOnOrdinaryIncome + results.taxOnQualifiedIncome
      in
        do
          logInAff "here we are doing something"
          calculated `shouldEqual` (toNumber tc.federalTaxDue)

    federalExpectations :: Array Expectation
    federalExpectations = map makeFederalExpectation GTC.cases

    combinedFederalExpectations :: Expectation
    combinedFederalExpectations = (sequence federalExpectations) *> (pure unit)

    makeStateExpectation :: GTC.TestCase -> Expectation
    makeStateExpectation (GTC.TestCase tc) =
      let
        calculated = roundHalfUp $ MA.taxDue year2021 tc.dependents tc.filingStatus (toNumber (tc.ordinaryIncomeNonSS + tc.qualifiedIncome))
      in
        do
          calculated `shouldEqual` (toNumber tc.stateTaxDue)

    stateExpectations :: Array Expectation
    stateExpectations = map makeStateExpectation GTC.cases

    combinedStateExpectations :: Expectation
    combinedStateExpectations = (sequence stateExpectations) *> (pure unit)
  in
    describe "Taxes" do
      it ".federalTaxDue matches outputs sampled from Scala implementation" do
        combinedFederalExpectations
      it ".stateTaxDue matches outputs sampled from Scala implementation" do
        combinedStateExpectations
