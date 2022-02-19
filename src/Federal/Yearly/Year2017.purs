module Federal.Yearly.Year2017
  ( values
  ) where

import CommonTypes (FilingStatus(HeadOfHousehold, Single))
import Data.Tuple
import Federal.OrdinaryBrackets (fromRPairs) as OB
import Federal.QualifiedBrackets (fromRPairs) as QB
import Federal.Regime (Regime(..))
import Federal.Yearly.Type (YearlyValues)
import Moneys (makeFromInt)
import UnsafeDates (unsafeMakeYear)

values :: YearlyValues
values =
  { regime: PreTrump
  , year: unsafeMakeYear 2017
  , perPersonExemption: makeFromInt 666
  , unadjustedStandardDeduction:
      case _ of
        HeadOfHousehold -> makeFromInt 666
        Single -> makeFromInt 666
  , adjustmentWhenOver65: makeFromInt 666
  , adjustmentWhenOver65AndSingle: makeFromInt 666
  , ordinaryBrackets:
      case _ of
        HeadOfHousehold ->
          OB.fromRPairs
            []
        Single ->
          OB.fromRPairs
            []
  , qualifiedBrackets:
      case _ of
        HeadOfHousehold ->
          QB.fromRPairs
            []
        Single ->
          QB.fromRPairs
            []
  }
