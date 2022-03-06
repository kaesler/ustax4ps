module Federal.Yearly.Year2017
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
  { regime: PreTrump
  , year: unsafeMakeYear 2017
  , perPersonExemption: makeFromInt 4050
  , unadjustedStandardDeduction:
      case _ of
        Married -> makeFromInt 12700
        HeadOfHousehold -> makeFromInt 9350
        Single -> makeFromInt 6350
  , adjustmentWhenOver65: makeFromInt 1250
  , adjustmentWhenOver65AndSingle: makeFromInt 300
  , ordinaryBrackets:
      case _ of
        Married ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 18650 15.0)
            , (Tuple 75900 25.0)
            , (Tuple 153100 28.0)
            , (Tuple 233350 33.0)
            , (Tuple 416700 35.0)
            , (Tuple 470700 39.6)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 13350 15.0)
            , (Tuple 50800 25.0)
            , (Tuple 131200 28.0)
            , (Tuple 212500 33.0)
            , (Tuple 416700 35.0)
            , (Tuple 444550 39.6)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9325 15.0)
            , (Tuple 37950 25.0)
            , (Tuple 91900 28.0)
            , (Tuple 191650 33.0)
            , (Tuple 416700 35.0)
            , (Tuple 418400 39.6)
            ]
  , qualifiedBrackets:
      case _ of
        Married ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 75900 15.0)
            , (Tuple 470700 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 50800 15.0)
            , (Tuple 444550 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 37950 15.0)
            , (Tuple 418400 20.0)
            ]
  }
