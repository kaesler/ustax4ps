module GoldenTestsAgainstScalaImpl
  ( runAllTests
  , logInAff
  ) where

import Prelude
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Federal.Calculator (FederalTaxResults(..))
import Federal.Calculator as FC
import GoldenTestCasesFromScala as GTC
import StateMA.Calculator as MA
import TaxMath (roundHalfUp)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $ let
        config = defaultConfig { exit = false }
      in
        runSpec' config [ consoleReporter ]
          testsAgainstScala

type Expectation
  = Aff Unit

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
            tc.regime
            tc.year
            tc.filingStatus
            tc.birthDate
            tc.personalExemptions
            tc.socSec
            tc.ordinaryIncomeNonSS
            tc.qualifiedIncome
            tc.itemizedDeductions

        calculated = roundHalfUp $ results.taxOnOrdinaryIncome + results.taxOnQualifiedIncome
      in
        do
          --logInAff $ show results 
          calculated `shouldEqual` tc.federalTaxDue

    federalExpectations :: Array Expectation
    federalExpectations = map makeFederalExpectation GTC.cases

    combinedFederalExpectations :: Expectation
    combinedFederalExpectations = (sequence federalExpectations) *> (pure unit)

    makeStateExpectation :: GTC.TestCase -> Expectation
    makeStateExpectation (GTC.TestCase tc) =
      let
        dependents = if tc.personalExemptions <= 0 then 0 else tc.personalExemptions - 1

        calculated = roundHalfUp $ MA.taxDue tc.year tc.birthDate dependents tc.filingStatus (tc.ordinaryIncomeNonSS + tc.qualifiedIncome)
      in
        do
          calculated `shouldEqual` tc.stateTaxDue

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
