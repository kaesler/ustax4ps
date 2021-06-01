module Test.Main where

import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude
import Taxes (federalTaxDue, roundHalfUp)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import TestDataFromScala (TestCase, cases)

type Expectation
  = Aff Unit

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] testsAgainstScala

logInAff :: String -> Aff Unit
logInAff msg = liftEffect $ log msg

testsAgainstScala :: Spec Unit
testsAgainstScala =
  let
    year :: Int
    year = 2021

    makeExpectation :: TestCase -> Expectation
    makeExpectation tc =
      let
        calculated = roundHalfUp $ federalTaxDue year tc.filingStatus tc.socSec tc.ordinaryIncome tc.qualifiedIncome
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