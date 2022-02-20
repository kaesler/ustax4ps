module Federal.Yearly.Year2022
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
  , year: unsafeMakeYear 2022
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        HeadOfHousehold -> makeFromInt 19400
        Single -> makeFromInt 12950
  , adjustmentWhenOver65: makeFromInt 1400
  , adjustmentWhenOver65AndSingle: makeFromInt 350
  , ordinaryBrackets:
      case _ of
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 14650 12.0)
            , (Tuple 55900 22.0)
            , (Tuple 89050 24.0)
            , (Tuple 170050 32.0)
            , (Tuple 215950 35.0)
            , (Tuple 539900 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 10275 12.0)
            , (Tuple 41775 22.0)
            , (Tuple 89075 24.0)
            , (Tuple 170050 32.0)
            , (Tuple 215950 35.0)
            , (Tuple 539900 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 55800 15.0)
            , (Tuple 488500 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 41675 15.0)
            , (Tuple 459750 20.0)
            ]
  }
