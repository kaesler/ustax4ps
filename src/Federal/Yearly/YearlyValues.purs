module Federal.Yearly.YearlyValues
  ( forYear
  , valuesAscendingByYear
  , valuesAscendingByYearForRegime
  ) where

import Data.List
import Data.Ord
import Data.Tuple
import CommonTypes (FilingStatus)
import Data.Date (Year)
import Data.Map as Map
import Federal.OrdinaryBrackets (OrdinaryBrackets)
import Federal.QualifiedBrackets (QualifiedBrackets)
import Federal.Regime (Regime)
import Federal.Yearly.Type (YearlyValues)
import Federal.Yearly.Year2016 as Year2016
import Federal.Yearly.Year2017 as Year2017
import Federal.Yearly.Year2018 as Year2018
import Federal.Yearly.Year2019 as Year2019
import Federal.Yearly.Year2020 as Year2020
import Federal.Yearly.Year2021 as Year2021
import Federal.Yearly.Year2022 as Year2022
import Moneys (Deduction)
import UnsafeDates (unsafeMakeYear)
import Prelude

forYear :: Map.Map Year YearlyValues
forYear =
  Map.fromFoldable
    [ (Tuple (unsafeMakeYear 2016) Year2016.values)
    , (Tuple (unsafeMakeYear 2017) Year2017.values)
    , (Tuple (unsafeMakeYear 2018) Year2018.values)
    , (Tuple (unsafeMakeYear 2019) Year2019.values)
    , (Tuple (unsafeMakeYear 2020) Year2020.values)
    , (Tuple (unsafeMakeYear 2021) Year2021.values)
    , (Tuple (unsafeMakeYear 2022) Year2022.values)
    ]

valuesAscendingByYear :: List YearlyValues
valuesAscendingByYear = sortBy cmp (Map.values forYear)
  where
  cmp :: YearlyValues -> YearlyValues -> Ordering
  cmp yv1 yv2 = compare yv1.year yv2.year

valuesAscendingByYearForRegime :: Regime -> List YearlyValues
valuesAscendingByYearForRegime reg = filter (\yv -> yv.regime == reg) valuesAscendingByYear
