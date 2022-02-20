module Federal.Yearly.Year2021
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
  , year: unsafeMakeYear 2021
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        HeadOfHousehold -> makeFromInt 18800
        Single -> makeFromInt 12550
  , adjustmentWhenOver65: makeFromInt 1350
  , adjustmentWhenOver65AndSingle: makeFromInt 350
  , ordinaryBrackets:
      case _ of
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 14200 12.0)
            , (Tuple 54200 22.0)
            , (Tuple 86350 24.0)
            , (Tuple 164900 32.0)
            , (Tuple 209400 35.0)
            , (Tuple 523600 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9950 12.0)
            , (Tuple 40525 22.0)
            , (Tuple 86375 24.0)
            , (Tuple 164925 32.0)
            , (Tuple 209425 35.0)
            , (Tuple 523600 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 54100 15.0)
            , (Tuple 473750 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 40400 15.0)
            , (Tuple 445850 20.0)
            ]
  }
