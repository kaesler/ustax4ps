module Test.Main where

import Prelude
import Data.Array.NonEmpty.Internal (NonEmptyArray(..))
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Taxes (FilingStatus(..), OrdinaryIncome, SSRelevantOtherIncome, SocSec, applyOrdinaryIncomeBrackets, federalTaxDue, roundHalfUp)
import Test.QuickCheck (class Arbitrary, quickCheck)
import Test.QuickCheck.Gen (choose, elements)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)
import TestDataFromScala (TestCase, cases)

type Expectation
  = Aff Unit

main :: Effect Unit
main = do
  log "Running prop tests"
  quickCheck prop_monotonic
  log "Running Spec tests"
  launchAff_
    $ runSpec [ consoleReporter ] do
        testsAgainstScala

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

----------------------------------
-- Avoid orphan type class instances by wrapping the types in newtypes.
data TestFilingStatus
  = TestFilingStatus FilingStatus

instance arbFilingStatus :: Arbitrary TestFilingStatus where
  arbitrary = elements $ map TestFilingStatus (NonEmptyArray [ Single, HeadOfHousehold ])

data TestSocSec
  = TestSocSec SocSec

instance arbSocSec :: Arbitrary TestSocSec where
  arbitrary = map TestSocSec $ choose 0.0 50000.0

data TestOrdinaryIncome
  = TestOrdinaryIncome OrdinaryIncome

instance arbOrdinaryIncome :: Arbitrary TestOrdinaryIncome where
  arbitrary = map TestOrdinaryIncome $ choose 0.0 100000.0

data TestSsRelevantOtherIncome
  = TestSsRelevantOtherIncome SSRelevantOtherIncome

instance arbTestSsRelevantOtherIncome :: Arbitrary TestSsRelevantOtherIncome where
  arbitrary = map TestSsRelevantOtherIncome $ choose 0.0 100000.0

prop_monotonic :: TestFilingStatus -> TestOrdinaryIncome -> TestOrdinaryIncome -> Boolean
prop_monotonic = \(TestFilingStatus fs) (TestOrdinaryIncome i1) (TestOrdinaryIncome i2) ->
  (i1 <= i2)
    == (applyOrdinaryIncomeBrackets fs i1 <= applyOrdinaryIncomeBrackets fs i2)
