module Federal.OrdinaryIncomeBracketSpec
  ( runAllTests
  ) where

import Prelude

import CommonTypes (FilingStatus(..), OrdinaryIncome, SSRelevantOtherIncome, SocSec)
import Data.Array as Array
import Data.Array.NonEmpty.Internal (NonEmptyArray(..))
import Data.Int (toNumber)
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..), curry)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class(liftEffect)
import Effect.Console (log)
import Federal.OrdinaryIncome (applyOrdinaryIncomeBrackets, incomeToEndOfOrdinaryBracket, ordinaryRateAsFraction, ordinaryRatesExceptTop, taxToEndOfOrdinaryIncomeBracket, topRateOnOrdinaryIncome)
import Federal.Types (StandardDeduction(..), standardDeductionFor)
import TaxMath (nonNeg, roundHalfUp)
import Taxes (ordinaryIncomeBrackets)
import Test.QuickCheck (class Arbitrary, quickCheck)
import Test.QuickCheck.Gen (choose, elements)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')

-- TODO
--foo :: Aff Unit
--foo = liftEffect $ quickCheck prop_monotonic

runAllTests :: Effect Unit
runAllTests = do
  log "Running prop tests"
  -- TODO: try using quickCheckGen here and do away with the
  -- TestXXX newtypes
  log "  prop_monotonic"
  quickCheck prop_monotonic
  log "  prop_singlePaysMoreTax"
  quickCheck prop_singlePaysMoreTax
  log "  prop_topRateIsNotExceeded"
  quickCheck prop_topRateIsNotExceeded
  log "  prop_zeroTaxOnlyOnZeroIncome"
  quickCheck prop_zeroTaxOnlyOnZeroIncome
  log "Running Spec tests"

  -- TODO: I think because this runs async we don't fail the
  -- runAllTests if it fails. Fix this somehow.
  launchAff_
    $ runSpec' config [ consoleReporter ] do
        correctAtBracketBoundaries
      -- Don't exit the program after the test.
      where config = defaultConfig { exit = false}

--logInAff :: String -> Aff Unit
--logInAff msg = liftEffect $ log msg

--Avoid orphan type class instances by wrapping the types in newtypes.
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
    == ( applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets fs) i1
          <= applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets fs) i2
      )

prop_singlePaysMoreTax :: TestOrdinaryIncome -> Boolean
prop_singlePaysMoreTax = \(TestOrdinaryIncome income) ->
  applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets Single) income
    >= applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets HeadOfHousehold) income

prop_topRateIsNotExceeded :: TestFilingStatus -> TestOrdinaryIncome -> Boolean
prop_topRateIsNotExceeded = \(TestFilingStatus fs) (TestOrdinaryIncome income) ->
  let
    brackets = ordinaryIncomeBrackets fs

    effectiveRate = applyOrdinaryIncomeBrackets brackets income / income
  in
    effectiveRate <= (ordinaryRateAsFraction $ topRateOnOrdinaryIncome brackets)

prop_zeroTaxOnlyOnZeroIncome :: TestFilingStatus -> TestOrdinaryIncome -> Boolean
prop_zeroTaxOnlyOnZeroIncome = \(TestFilingStatus fs) (TestOrdinaryIncome income) ->
  applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets fs) income /= 0.0 || income == 0.0

correctAtBracketBoundaries :: Spec Unit
correctAtBracketBoundaries =
  describe "Correct at bracket boundaries" do
    it "Correct at bracket bundaries for Single" do
      assertCorrectTaxDueAtBracketBoundaries Single
    it "Correct at bracket boundaries for HeadOfHousehold" do
      assertCorrectTaxDueAtBracketBoundaries HeadOfHousehold

type Expectation
  = Aff Unit

assertCorrectTaxDueAtBracketBoundaries :: FilingStatus -> Expectation
assertCorrectTaxDueAtBracketBoundaries filingStatus =
  let
    stdDed = standardDeductionFor filingStatus

    brackets = ordinaryIncomeBrackets filingStatus

    rates = ordinaryRatesExceptTop brackets

    incomes = map (incomeToEndOfOrdinaryBracket brackets stdDed) rates

    expectedTaxes = map (taxToEndOfOrdinaryIncomeBracket brackets) rates

    StandardDeduction deduction = standardDeductionFor filingStatus

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
