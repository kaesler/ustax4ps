module GoldenTestsAgainstScalaImpl
  ( runAllTests
  , logInAff
  ) where

import Prelude
import CommonTypes (Money)
import Data.Date (Date, Year, canonicalDate)
import Data.Enum (toEnum)
import Data.Int (toNumber)
import Data.Maybe (fromJust)
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Federal.Calculator (FederalTaxResults(..))
import Federal.Calculator as FC
import Federal.Regime (Regime(..))
import GoldenTestCasesFromScala as GTC
import Partial.Unsafe (unsafePartial)
import StateMA.Calculator as MA
import TaxMath (roundHalfUp)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

runAllTests :: Effect Unit
runAllTests = do
  -- TODO: by default this exits the program at the end.
  -- Best solution might be to pull the prop tests into Aff using liftEffect
  launchAff_
    $ runSpec [ consoleReporter ] do
        testsAgainstScala

type Expectation
  = Aff Unit

year2021 :: Year
year2021 = unsafePartial fromJust $ toEnum 2021

year1955 :: Year
year1955 = unsafePartial fromJust $ toEnum 1955

birthDate :: Date
birthDate =
  let
    october = unsafePartial fromJust $ toEnum 10

    second = unsafePartial fromJust $ toEnum 2
  in
    canonicalDate year1955 october second

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
          --logInAff $ show results 
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
