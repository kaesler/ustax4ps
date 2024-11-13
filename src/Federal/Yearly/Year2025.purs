module Federal.Yearly.Year2025
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
  , year: unsafeMakeYear 2025
  , perPersonExemption: makeFromInt 0
  , unadjustedStandardDeduction:
      case _ of
        MarriedJoint -> makeFromInt 30000
        HeadOfHousehold -> makeFromInt 22500
        Single -> makeFromInt 15000
  , adjustmentWhenOver65: makeFromInt 1600
  , adjustmentWhenOver65AndSingle: makeFromInt 400
  , ordinaryBrackets:
      case _ of
        MarriedJoint ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 23850 12.0)
            , (Tuple 96950 22.0)
            , (Tuple 206700 24.0)
            , (Tuple 394600 32.0)
            , (Tuple 501050 35.0)
            , (Tuple 751600 37.0)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 17000 12.0)
            , (Tuple 64850 22.0)
            , (Tuple 103350 24.0)
            , (Tuple 197300 32.0)
            , (Tuple 250500 35.0)
            , (Tuple 626350 37.0)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 11925 12.0)
            , (Tuple 48475 22.0)
            , (Tuple 103350 24.0)
            , (Tuple 197300 32.0)
            , (Tuple 250525 35.0)
            , (Tuple 626350 37.0)
            ]
  , qualifiedBrackets:
      case _ of
        MarriedJoint ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 96700 15.0)
            , (Tuple 600050 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 64750 15.0)
            , (Tuple 566700 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 48350 15.0)
            , (Tuple 533400 20.0)
            ]
  }
