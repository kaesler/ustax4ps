module Federal.Yearly.Year2024
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
  , year: unsafeMakeYear 2024
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        MarriedJoint -> makeFromInt 29200
        HeadOfHousehold -> makeFromInt 21900
        Single -> makeFromInt 14600
  , adjustmentWhenOver65: makeFromInt 1550
  , adjustmentWhenOver65AndSingle: makeFromInt 400
  , ordinaryBrackets:
      case _ of
        MarriedJoint ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 23200 12.0)
            , (Tuple 94300 22.0)
            , (Tuple 201050 24.0)
            , (Tuple 383900 32.0)
            , (Tuple 487450 35.0)
            , (Tuple 731200 37.0)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 16550 12.0)
            , (Tuple 63100 22.0)
            , (Tuple 100500 24.0)
            , (Tuple 191950 32.0)
            , (Tuple 243700 35.0)
            , (Tuple 609350 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 11600 12.0)
            , (Tuple 47150 22.0)
            , (Tuple 100525 24.0)
            , (Tuple 191950 32.0)
            , (Tuple 243725 35.0)
            , (Tuple 609350 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        MarriedJoint ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 94050 15.0)
            , (Tuple 583750 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 63000 15.0)
            , (Tuple 551350 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 47025 15.0)
            , (Tuple 518900 20.0)
            ]
  }
