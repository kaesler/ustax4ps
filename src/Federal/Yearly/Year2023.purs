module Federal.Yearly.Year2023
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
  { regime: TCJA
  , year: unsafeMakeYear 2023
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        Married -> makeFromInt 27700
        HeadOfHousehold -> makeFromInt 20800
        Single -> makeFromInt 13850
  , adjustmentWhenOver65: makeFromInt 1500
  , adjustmentWhenOver65AndSingle: makeFromInt 350
  , ordinaryBrackets:
      case _ of
        Married ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 22000 12.0)
            , (Tuple 89450 22.0)
            , (Tuple 190750 24.0)
            , (Tuple 364200 32.0)
            , (Tuple 462500 35.0)
            , (Tuple 693750 37.0)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 15700 12.0)
            , (Tuple 59850 22.0)
            , (Tuple 95350 24.0)
            , (Tuple 182100 32.0)
            , (Tuple 231250 35.0)
            , (Tuple 578100 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 11000 12.0)
            , (Tuple 44725 22.0)
            , (Tuple 95375 24.0)
            , (Tuple 182100 32.0)
            , (Tuple 231250 35.0)
            , (Tuple 578125 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        Married ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 89250 15.0)
            , (Tuple 553850 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 59750 15.0)
            , (Tuple 523050 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 44625 15.0)
            , (Tuple 492300 20.0)
            ]
  }
