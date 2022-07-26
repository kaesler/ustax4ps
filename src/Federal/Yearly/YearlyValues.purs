module Federal.Yearly.YearlyValues
  ( averageThresholdChange
  , averageThresholdChangeOverPrevious
  , haveCongruentOrdinaryBrackets
  , haveCongruentQualifiedBrackets
  , memoizedAverageThresholdChanges
  , mostRecent
  , mostRecentForRegime
  , mostRecentYearForRegime
  , ordinaryNonZeroThresholdsMap
  , previous
  , qualifiedNonZeroThresholdsMap
  , unsafeValuesForYear
  , valuesAscendingByYear
  , valuesAscendingByYearForRegime
  , valuesForYear
  )
  where

import Prelude
import CommonTypes (FilingStatus(..))
import Data.Array as Array
import Data.Date (Year)
import Data.Enum (pred)
import Data.Int (toNumber)
import Data.List as List
import Data.Map as Map
import Data.Maybe (Maybe, fromJust)
import Data.Tuple (Tuple(..))
import Federal.FederalTaxRate (FederalTaxRate)
import Federal.OrdinaryBrackets as OB
import Federal.QualifiedBrackets as QB
import Federal.Regime (Regime)
import Federal.Yearly.Type (YearlyValues)
import Federal.Yearly.Year2016 as Year2016
import Federal.Yearly.Year2017 as Year2017
import Federal.Yearly.Year2018 as Year2018
import Federal.Yearly.Year2019 as Year2019
import Federal.Yearly.Year2020 as Year2020
import Federal.Yearly.Year2021 as Year2021
import Federal.Yearly.Year2022 as Year2022
import Moneys (IncomeThreshold, divide, nonZero)
import Partial.Unsafe (unsafePartial)
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
mostRecent = unsafePartial $ fromJust $ Array.last valuesAscendingByYear

mostRecentForRegime :: Regime -> YearlyValues
mostRecentForRegime reg = unsafePartial $ fromJust $ Array.last $ valuesAscendingByYearForRegime reg

mostRecentYearForRegime :: Regime -> Year
mostRecentYearForRegime reg = (mostRecentForRegime reg).year

valuesAscendingByYear :: Array YearlyValues
valuesAscendingByYear = Array.sortBy cmp $ Array.fromFoldable (Map.values forYear)
  where
  cmp :: YearlyValues -> YearlyValues -> Ordering
  cmp yv1 yv2 = compare yv1.year yv2.year

valuesAscendingByYearForRegime :: Regime -> Array YearlyValues
valuesAscendingByYearForRegime reg = Array.filter (\yv -> yv.regime == reg) valuesAscendingByYear

previous :: YearlyValues -> Maybe YearlyValues
previous yv = do
  previousYear <- pred yv.year
  valuesForYear previousYear

ordinaryNonZeroThresholdsMap :: YearlyValues -> Map.Map (Tuple FilingStatus FederalTaxRate) IncomeThreshold
ordinaryNonZeroThresholdsMap yv =
  let
    pairs = do
      fs <- [ Single, HeadOfHousehold, Married ]
      let
        obs = (yv.ordinaryBrackets fs)
      (Tuple rate threshold) <- Array.filter hasNonZeroThreshold $ OB.toPairs obs
      pure (Tuple (Tuple fs rate) threshold)
  in
    Map.fromFoldable pairs

qualifiedNonZeroThresholdsMap :: YearlyValues -> Map.Map (Tuple FilingStatus FederalTaxRate) IncomeThreshold
qualifiedNonZeroThresholdsMap yv =
  let
    pairs = do
      fs <- [ Single, HeadOfHousehold, Married ]
      let
        qbs = (yv.qualifiedBrackets fs)
      (Tuple rate threshold) <- Array.filter hasNonZeroThreshold $ QB.toPairs qbs
      pure (Tuple (Tuple fs rate) threshold)
  in
    Map.fromFoldable pairs

hasNonZeroThreshold :: Tuple FederalTaxRate IncomeThreshold -> Boolean
hasNonZeroThreshold (Tuple _ t) = nonZero t

haveCongruentOrdinaryBrackets :: YearlyValues -> YearlyValues -> Boolean
haveCongruentOrdinaryBrackets left right = (Map.keys $ ordinaryNonZeroThresholdsMap left) == (Map.keys $ ordinaryNonZeroThresholdsMap right)

haveCongruentQualifiedBrackets :: YearlyValues -> YearlyValues -> Boolean
haveCongruentQualifiedBrackets left right = (Map.keys $ qualifiedNonZeroThresholdsMap left) == (Map.keys $ qualifiedNonZeroThresholdsMap right)

averageThresholdChange :: YearlyValues -> YearlyValues -> Number
averageThresholdChange left right =
  let -- Note: these lists are sorted ascending by associated key order.
    ordPairs
      | (haveCongruentOrdinaryBrackets left right) = List.zip (Map.values (ordinaryNonZeroThresholdsMap left)) (Map.values (ordinaryNonZeroThresholdsMap right))
      | otherwise = List.Nil

    qualPairs
      | (haveCongruentQualifiedBrackets left right) = List.zip (Map.values (qualifiedNonZeroThresholdsMap left)) (Map.values (qualifiedNonZeroThresholdsMap right))
      | otherwise = List.Nil

    pairs = ordPairs <> qualPairs

    changes = map (\(Tuple l r) -> r `divide` l) pairs

    changesSum = List.foldl (\x y -> x + y) 1.0 changes

    averageChange = changesSum / toNumber (List.length changes)
  in
    averageChange

memoizedAverageThresholdChanges :: Map.Map Year Number
memoizedAverageThresholdChanges =
  let
    yvs = Map.values forYear

    yvPairs = List.zip yvs $ unsafePartial $ fromJust (List.tail yvs)

    mapPairs = map (\(Tuple left right) -> (Tuple right.year (averageThresholdChange left right))) yvPairs
  in
    Map.fromFoldable mapPairs

averageThresholdChangeOverPrevious :: Year -> Maybe Number
averageThresholdChangeOverPrevious y = Map.lookup y memoizedAverageThresholdChanges