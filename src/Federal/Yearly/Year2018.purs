module Federal.Yearly.Year2018
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
  { regime: Trump
  , year: unsafeMakeYear 2018
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        HeadOfHousehold -> makeFromInt 18000
        Single -> makeFromInt 12000
  , adjustmentWhenOver65: makeFromInt 1300
  , adjustmentWhenOver65AndSingle: makeFromInt 300
  , ordinaryBrackets:
      case _ of
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 13600 12.0)
            , (Tuple 51800 22.0)
            , (Tuple 82500 24.0)
            , (Tuple 157500 32.0)
            , (Tuple 200000 35.0)
            , (Tuple 500000 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9525 12.0)
            , (Tuple 38700 22.0)
            , (Tuple 82500 24.0)
            , (Tuple 157500 32.0)
            , (Tuple 200000 35.0)
            , (Tuple 500000 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 51700 15.0)
            , (Tuple 452400 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 38600 15.0)
            , (Tuple 425800 20.0)
            ]
  }
