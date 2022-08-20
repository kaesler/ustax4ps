module Federal.Yearly.Year2016
  ( values
  ) where

import Data.Tuple
import CommonTypes (FilingStatus(..))
import Federal.OrdinaryBrackets (fromRPairs) as OB
import Federal.QualifiedBrackets (fromRPairs) as QB
import Federal.Regime (Regime(..))
import Federal.Yearly.Type (YearlyValues)
import Moneys (makeFromInt)
import UnsafeDates (unsafeMakeYear)

values :: YearlyValues
values =
  { regime: PreTCJA
  , year: unsafeMakeYear 2016
  , perPersonExemption: makeFromInt 4050
  , unadjustedStandardDeduction:
      case _ of
        Married -> makeFromInt 12600
        HeadOfHousehold -> makeFromInt 9300
        Single -> makeFromInt 6300
  , adjustmentWhenOver65: makeFromInt 1250
  , adjustmentWhenOver65AndSingle: makeFromInt 300
  , ordinaryBrackets:
      case _ of
        Married ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 18550 15.0)
            , (Tuple 75300 25.0)
            , (Tuple 151900 28.0)
            , (Tuple 231450 33.0)
            , (Tuple 413350 35.0)
            , (Tuple 466950 39.6)
            ]
        HeadOfHousehold ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 13250 15.0)
            , (Tuple 50400 25.0)
            , (Tuple 130150 28.0)
            , (Tuple 210800 33.0)
            , (Tuple 413350 35.0)
            , (Tuple 441000 39.6)
            ]
        Single ->
          OB.fromRPairs
            [ (Tuple 0 10.0)
            , (Tuple 9275 15.0)
            , (Tuple 37650 25.0)
            , (Tuple 91150 28.0)
            , (Tuple 190150 33.0)
            , (Tuple 413350 35.0)
            , (Tuple 415050 39.6)
            ]
  , qualifiedBrackets:
      case _ of
        Married ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 75300 15.0)
            , (Tuple 466950 20.0)
            ]
        HeadOfHousehold ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 50400 15.0)
            , (Tuple 441000 20.0)
            ]
        Single ->
          QB.fromRPairs
            [ (Tuple 0 0.0)
            , (Tuple 37650 15.0)
            , (Tuple 415050 20.0)
            ]
  }
