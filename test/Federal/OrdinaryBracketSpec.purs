module Federal.OrdinaryBracketSpec
  ( runAllTests
  ) where

import CommonTypes (FilingStatus(..))
import Data.Array as Array
import Data.Array.NonEmpty.Internal (NonEmptyArray(..))
import Data.Date (Date, Year)
import Data.Enum (fromEnum)
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..), curry)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Console (log)
import Federal.BoundRegime (BoundRegime(..), bindRegime)
import Federal.OrdinaryBrackets (OrdinaryBrackets, taxableIncomeToEndOfOrdinaryBracket, ordinaryRatesExceptTop, taxToEndOfOrdinaryBracket)
import Federal.Regime (Regime(..))
import Federal.TaxFunctions as TFS
import Federal.Types (SSRelevantOtherIncome, SocSec)
import Moneys (TaxPayable, TaxableIncome, makeFromInt, noMoney, roundTaxPayable)
import Prelude (Unit, discard, map, pure, unit, ($), (*>), (/=), (<<<), (<=), (==), (>=), (||))
import Test.QuickCheck (class Arbitrary, quickCheck)
import Test.QuickCheck.Gen (chooseInt, elements)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')
import UnsafeDates (unsafeMakeDate, unsafeMakeYear)

runAllTests :: Effect Unit
runAllTests = do
  log "Running prop tests"
  -- TODO: try using quickCheckGen here and do away with the
  -- TestXXX newtypes
  log "  prop_monotonic"
  quickCheck prop_monotonic
  log "  prop_singlePaysMoreTax"
  quickCheck prop_singlePaysMoreTax
  --log "  prop_topRateIsNotExceeded"
  --quickCheck prop_topRateIsNotExceeded
  log "  prop_zeroTaxOnlyOnZeroIncome"
  quickCheck prop_zeroTaxOnlyOnZeroIncome
  log "Running Spec tests"
  launchAff_
    $ runSpec' config [ consoleReporter ] do
        correctAtBracketBoundaries
  -- Don't exit the program after the test.
  where
    config = defaultConfig { exit = false }


boundRegimeFor :: FilingStatus -> BoundRegime
boundRegimeFor fs = bindRegime theRegime (fromEnum theYear) theBirthDate fs (if fs == Single then 1 else 2)

ordinaryBracketsFor :: FilingStatus -> OrdinaryBrackets
ordinaryBracketsFor fs =
  let
    BoundRegime rec = boundRegimeFor fs
  in
    rec.ordinaryBrackets

prop_monotonic :: TestFilingStatus -> TestTaxableIncome -> TestTaxableIncome -> Boolean
prop_monotonic = \(TestFilingStatus fs) (TestTaxableIncome i1) (TestTaxableIncome i2) ->
  (i1 <= i2)
    == ( TFS.taxDueOnOrdinaryIncome (ordinaryBracketsFor fs) i1
          <= TFS.taxDueOnOrdinaryIncome (ordinaryBracketsFor fs) i2
      )

prop_singlePaysMoreTax :: TestTaxableIncome -> Boolean
prop_singlePaysMoreTax = \(TestTaxableIncome income) ->
  TFS.taxDueOnOrdinaryIncome (ordinaryBracketsFor Single) income
    >= TFS.taxDueOnOrdinaryIncome (ordinaryBracketsFor HeadOfHousehold) income

{- prop_topRateIsNotExceeded :: TestFilingStatus -> TestTaxableIncome -> Boolean
prop_topRateIsNotExceeded = \(TestFilingStatus fs) (TestTaxableIncome income) ->
  let
    brackets = ordinaryBracketsFor fs
    effectiveRate = TFS.taxDueOnOrdinaryIncome brackets income / income
  in
    effectiveRate <= (ratetoNumber $ topRateOnOrdinaryIncome brackets)
 -}

prop_zeroTaxOnlyOnZeroIncome :: TestFilingStatus -> TestTaxableIncome -> Boolean
prop_zeroTaxOnlyOnZeroIncome = \(TestFilingStatus fs) (TestTaxableIncome income) ->
  TFS.taxDueOnOrdinaryIncome (ordinaryBracketsFor fs) income /= noMoney || income == noMoney

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
    brackets = ordinaryBracketsFor filingStatus
    rates = ordinaryRatesExceptTop brackets
    incomes = map (taxableIncomeToEndOfOrdinaryBracket brackets) rates
    expectedTaxes = map (taxToEndOfOrdinaryBracket brackets) rates

    federalExpectations = Array.zipWith (curry taxDueIsAsExpected) incomes expectedTaxes
      where
      taxDueIsAsExpected :: (Tuple TaxableIncome TaxPayable) -> Expectation
      taxDueIsAsExpected (Tuple taxableIncome expectedTax) =
        let
          computedTax = roundTaxPayable $ TFS.taxDueOnOrdinaryIncome brackets taxableIncome
        in
          do
            computedTax `shouldEqual` roundTaxPayable expectedTax
  in
    (sequence federalExpectations) *> (pure unit)

theRegime :: Regime
theRegime = Trump

theYear :: Year
theYear = unsafeMakeYear 2021

theBirthDate :: Date
theBirthDate = unsafeMakeDate 2021 10 2

--logInAff :: String -> Aff Unit
--logInAff msg = liftEffect $ log msg

--Avoid illegal-in-puresecript orphan type class instances by wrapping the types in newtypes.
data TestFilingStatus = TestFilingStatus FilingStatus

instance arbFilingStatus :: Arbitrary TestFilingStatus where
  arbitrary = elements $ map TestFilingStatus (NonEmptyArray [ Single, HeadOfHousehold ])

data TestSocSec = TestSocSec SocSec

instance arbSocSec :: Arbitrary TestSocSec where
  arbitrary = map (TestSocSec  <<< makeFromInt) $ chooseInt 0 50000

data TestTaxableIncome = TestTaxableIncome TaxableIncome

instance arbTaxableIncome :: Arbitrary TestTaxableIncome where
  arbitrary = map (TestTaxableIncome <<< makeFromInt) $ chooseInt 0 100000

data TestSsRelevantOtherIncome = TestSsRelevantOtherIncome SSRelevantOtherIncome

instance arbTestSsRelevantOtherIncome :: Arbitrary TestSsRelevantOtherIncome where
  arbitrary = map (TestSsRelevantOtherIncome <<< makeFromInt) $ chooseInt 0 100000
