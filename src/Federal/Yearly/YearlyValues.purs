module Federal.Yearly.YearlyValues
  ( mostRecent
  , mostRecentForRegime
  , mostRecentYearForRegime
  , unsafeValuesForYear
  , valuesAscendingByYear
  , valuesAscendingByYearForRegime
  , valuesForYear
  ) where

import Data.Date (Year)
import Data.List (List, filter, last, sortBy)
import Data.Map as Map
import Data.Maybe (Maybe, fromJust)
import Data.Tuple (Tuple(..))
import Federal.Regime (Regime)
import Federal.Yearly.Type (YearlyValues)
import Federal.Yearly.Year2016 as Year2016
import Federal.Yearly.Year2017 as Year2017
import Federal.Yearly.Year2018 as Year2018
import Federal.Yearly.Year2019 as Year2019
import Federal.Yearly.Year2020 as Year2020
import Federal.Yearly.Year2021 as Year2021
import Federal.Yearly.Year2022 as Year2022
import Partial.Unsafe (unsafePartial)
import Prelude
import UnsafeDates (unsafeMakeYear)

forYear :: Map.Map Year YearlyValues
forYear =
  Map.fromFoldable
    ( [ (Tuple 2016 Year2016.values)
      , (Tuple 2017 Year2017.values)
      , (Tuple 2018 Year2018.values)
      , (Tuple 2019 Year2019.values)
      , (Tuple 2020 Year2020.values)
      , (Tuple 2021 Year2021.values)
      , (Tuple 2022 Year2022.values)
      ]
        # map case _ of
            Tuple y v -> Tuple (unsafeMakeYear y) v
    )

unsafeValuesForYear :: Year -> YearlyValues
unsafeValuesForYear y = unsafePartial $ fromJust $ Map.lookup y forYear

valuesForYear :: Year -> Maybe YearlyValues
valuesForYear y = Map.lookup y forYear

mostRecent :: YearlyValues
mostRecent = unsafePartial $ fromJust $ last valuesAscendingByYear

mostRecentForRegime :: Regime -> YearlyValues
mostRecentForRegime reg = unsafePartial $ fromJust $ last $ valuesAscendingByYearForRegime reg

mostRecentYearForRegime :: Regime -> Year
mostRecentYearForRegime reg = (mostRecentForRegime reg).year

valuesAscendingByYear :: List YearlyValues
valuesAscendingByYear = sortBy cmp (Map.values forYear)
  where
  cmp :: YearlyValues -> YearlyValues -> Ordering
  cmp yv1 yv2 = compare yv1.year yv2.year

valuesAscendingByYearForRegime :: Regime -> List YearlyValues
valuesAscendingByYearForRegime reg = filter (\yv -> yv.regime == reg) valuesAscendingByYear
