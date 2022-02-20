module Federal.Yearly.Year2019
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
  , year: unsafeMakeYear 2019
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        HeadOfHousehold -> makeFromInt 18350
        Single -> makeFromInt 12200
  , adjustmentWhenOver65: makeFromInt 1300
  , adjustmentWhenOver65AndSingle: makeFromInt 350
  , ordinaryBrackets:
      case _ of
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 13850 12.0)
            , (Tuple 52850 22.0)
            , (Tuple 84200 24.0)
            , (Tuple 160700 32.0)
            , (Tuple 204100 35.0)
            , (Tuple 510300 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9700 12.0)
            , (Tuple 39475 22.0)
            , (Tuple 84200 24.0)
            , (Tuple 160725 32.0)
            , (Tuple 204100 35.0)
            , (Tuple 510300 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 52750 15.0)
            , (Tuple 461700 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 39375 15.0)
            , (Tuple 434550 20.0)
            ]
  }
