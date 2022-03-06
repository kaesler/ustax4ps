module Federal.Yearly.Year2020
  ( values
  ) where

import CommonTypes (FilingStatus(..))
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
  , year: unsafeMakeYear 2020
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        Married -> makeFromInt 24800
        HeadOfHousehold -> makeFromInt 18650
        Single -> makeFromInt 12400
  , adjustmentWhenOver65: makeFromInt 1300
  , adjustmentWhenOver65AndSingle: makeFromInt 350
  , ordinaryBrackets:
      case _ of
        Married ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 19750 12.0)
            , (Tuple 80250 22.0)
            , (Tuple 171050 24.0)
            , (Tuple 326600 32.0)
            , (Tuple 414700 35.0)
            , (Tuple 622050 37.0)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 14100 12.0)
            , (Tuple 53700 22.0)
            , (Tuple 85500 24.0)
            , (Tuple 163300 32.0)
            , (Tuple 207350 35.0)
            , (Tuple 518400 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9875 12.0)
            , (Tuple 40125 22.0)
            , (Tuple 85525 24.0)
            , (Tuple 163300 32.0)
            , (Tuple 207350 35.0)
            , (Tuple 518400 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        Married ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 80000 15.0)
            , (Tuple 496600 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 53600 15.0)
            , (Tuple 469050 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 40000 15.0)
            , (Tuple 442450 20.0)
            ]
  }
