module Federal.RMDs
  ( rmdFractionForAge
  , unsafeRmdFractionForAge
  ) where

import Prelude
import Data.Map as Map
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)
import Data.Maybe (Maybe(..), fromJust)
import CommonTypes (Age(..))
import Federal.Types(DistributionPeriod)

unsafeRmdFractionForAge :: Int -> Number
unsafeRmdFractionForAge age = unsafePartial $ fromJust $ rmdFractionForAge (Age age)

rmdFractionForAge :: Age -> Maybe Number
rmdFractionForAge age = do
  distributionPeriod <- Map.lookup age distributionPeriods
  Just (1.0 / distributionPeriod)

distributionPeriods :: Map.Map Age DistributionPeriod
distributionPeriods =
  Map.fromFoldable
    [ Tuple (Age 70) 27.4
    , Tuple (Age 71) 26.5
    , Tuple (Age 72) 25.6
    , Tuple (Age 73) 24.7
    , Tuple (Age 74) 23.8
    , Tuple (Age 75) 22.9
    , Tuple (Age 76) 22.0
    , Tuple (Age 77) 21.2
    , Tuple (Age 78) 20.3
    , Tuple (Age 79) 19.5
    , Tuple (Age 80) 18.7
    , Tuple (Age 81) 17.9
    , Tuple (Age 82) 17.1
    , Tuple (Age 83) 16.3
    , Tuple (Age 84) 15.5
    , Tuple (Age 85) 14.8
    , Tuple (Age 86) 14.1
    , Tuple (Age 87) 13.4
    , Tuple (Age 88) 12.7
    , Tuple (Age 89) 12.0
    , Tuple (Age 90) 11.4
    , Tuple (Age 91) 10.8
    , Tuple (Age 92) 10.2
    , Tuple (Age 93) 9.6
    , Tuple (Age 94) 9.1
    , Tuple (Age 95) 8.6
    , Tuple (Age 96) 8.1
    , Tuple (Age 97) 7.6
    , Tuple (Age 98) 7.1
    , Tuple (Age 99) 6.7
    , Tuple (Age 100) 6.3
    , Tuple (Age 101) 5.9
    , Tuple (Age 102) 5.5
    , Tuple (Age 103) 5.2
    , Tuple (Age 104) 4.9
    , Tuple (Age 105) 4.5
    , Tuple (Age 106) 4.2
    , Tuple (Age 107) 3.9
    , Tuple (Age 108) 3.7
    , Tuple (Age 109) 3.4
    , Tuple (Age 110) 3.1
    , Tuple (Age 111) 2.9
    , Tuple (Age 112) 2.6
    , Tuple (Age 113) 2.4
    , Tuple (Age 114) 2.1
    ]
