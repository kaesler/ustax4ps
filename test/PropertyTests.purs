module PropertyTests
  ( runPropertyTests
  ) where

import Prelude
import Data.Array.NonEmpty.Internal (NonEmptyArray(..))
import Effect (Effect)
import Effect.Console (log)
import CommonTypes (FilingStatus(..), OrdinaryIncome, SSRelevantOtherIncome, SocSec)
import Federal.OrdinaryIncome (applyOrdinaryIncomeBrackets, ordinaryRateAsFraction, topRateOnOrdinaryIncome)
import Test.QuickCheck (class Arbitrary, quickCheck)
import Test.QuickCheck.Gen (choose, elements)
import Taxes (ordinaryIncomeBrackets)

runPropertyTests :: Effect Unit
runPropertyTests = do
  log "Running prop tests"
  -- TODO: try using quickCheckGen here and do away with the
  -- TestXXX newtypes
  quickCheck prop_monotonic

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
