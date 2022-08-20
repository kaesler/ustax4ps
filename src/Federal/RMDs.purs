module Federal.RMDs
  ( rmdFractionForAge
  ) where

import Prelude
import Data.Map as Map
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)
import Data.Maybe (fromJust)
import CommonTypes (Age(..))
import Federal.Types(DistributionPeriod)

rmdFractionForAge :: Age -> Number
rmdFractionForAge age 
  | age < Age 72 = 0.0
  | age > Age 120 = 0.5
  | otherwise = 1.0 / (unsafePartial $ fromJust $ Map.lookup age distributionPeriods)

distributionPeriods :: Map.Map Age DistributionPeriod
distributionPeriods =
  Map.fromFoldable
    [ Tuple (Age 72) 27.4
    , Tuple (Age 74) 25.5
    , Tuple (Age 75) 24.6
    , Tuple (Age 76) 23.7
    , Tuple (Age 77) 22.9
    , Tuple (Age 78) 22.0
    , Tuple (Age 79) 21.1
    , Tuple (Age 80) 20.2
    , Tuple (Age 81) 19.4
    , Tuple (Age 82) 18.5
    , Tuple (Age 83) 17.7
    , Tuple (Age 84) 16.8
    , Tuple (Age 85) 16.0
    , Tuple (Age 86) 15.2
    , Tuple (Age 87) 14.4
    , Tuple (Age 88) 13.7
    , Tuple (Age 89) 12.9
    , Tuple (Age 91) 11.5
    , Tuple (Age 92) 10.8
    , Tuple (Age 93) 10.1
    , Tuple (Age 94) 9.5
    , Tuple (Age 95) 8.9
    , Tuple (Age 96) 8.4
    , Tuple (Age 97) 7.8
    , Tuple (Age 98) 7.3
    , Tuple (Age 99) 6.8
    , Tuple (Age 100) 6.4
    , Tuple (Age 101) 6.0
    , Tuple (Age 102) 5.6
    , Tuple (Age 103) 5.2
    , Tuple (Age 104) 4.9
    , Tuple (Age 105) 4.6
    , Tuple (Age 106) 4.3
    , Tuple (Age 107) 4.1
    , Tuple (Age 108) 3.9
    , Tuple (Age 109) 3.7
    , Tuple (Age 110) 3.5
    , Tuple (Age 111) 3.4
    , Tuple (Age 112) 3.3
    , Tuple (Age 113) 3.1
    , Tuple (Age 114) 3.0
    , Tuple (Age 115) 2.9
    , Tuple (Age 116) 2.8
    , Tuple (Age 117) 2.7
    , Tuple (Age 118) 2.5
    , Tuple (Age 119) 2.3
    , Tuple (Age 120) 2.0
    ]
