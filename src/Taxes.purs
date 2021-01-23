module Taxes
  ( FilingStatus(..)
  , OrdinaryRate
  , BracketStart
  , ordinaryBracketStarts
  ) where

-- TODO: push the partials out of here
import Data.Maybe (Maybe(..), fromJust)
import Data.Tuple (Tuple(..), fst, snd)
import Data.Array (fromFoldable, zip, find, tail)
import Data.Int (toNumber)
import Data.Map (Map)
import Data.Map as Map
import Data.Ord ((<))
import Data.List ((!!))
import Data.Set as Set
import Data.Show (class Show, show)
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, (/), (+), (-), bind, (==))

type Year
  = Int

newtype Age
  = Age Int

derive instance eqAge :: Eq Age

derive instance ordAge :: Ord Age

data FilingStatus
  = HeadOfHousehold
  | Single

derive instance eqFilingStatus :: Eq FilingStatus

derive instance ordFilingStatus :: Ord FilingStatus

newtype OrdinaryRate
  = OrdinaryRate Int

derive instance eqOrdinaryRate :: Eq OrdinaryRate

derive instance ordOrdinaryRate :: Ord OrdinaryRate

instance showOrdinaryRate :: Show OrdinaryRate where
  show (OrdinaryRate r) = show r

ordinaryRateAsFraction :: OrdinaryRate -> Number
ordinaryRateAsFraction (OrdinaryRate r) = toNumber r / 100.0

newtype QualifiedRate
  = QualifiedRate Int

derive instance eqQualifiedRate :: Eq QualifiedRate

derive instance ordQualifiedRate :: Ord QualifiedRate

qualifiedRateAsFraction :: QualifiedRate -> Number
qualifiedRateAsFraction (QualifiedRate r) = toNumber r / 100.0

newtype BracketStart
  = BracketStart Int

derive instance eqBracketStart :: Eq BracketStart

derive instance ordBracketStart :: Ord BracketStart

instance showBracketStart :: Show BracketStart where
  show (BracketStart s) = show s

newtype StandardDeduction
  = StandardDeduction Int

derive instance eqStandardDeduction :: Eq StandardDeduction

derive instance ordStandardDeduction :: Ord StandardDeduction

type SocialSecurityBenefits
  = Number

type SSRelevantIncome
  = Number

type CombinedIncome
  = Number

type OrdinaryBracketStarts
  = Map OrdinaryRate BracketStart

type QualifiedBracketStarts
  = Map QualifiedRate BracketStart

type TaxableOrdinaryIncome
  = Number

type QualifiedInvestmentIncome
  = Number

type DistributionPeriod
  = Number

nonNeg :: Number -> Number
nonNeg x
  | x < 0.0 = 0.0
  | true = x

topRateOnOrdinaryIncome :: OrdinaryRate
topRateOnOrdinaryIncome = OrdinaryRate 37

ordinaryBracketStarts :: FilingStatus -> Map OrdinaryRate BracketStart
ordinaryBracketStarts Single =
  Map.fromFoldable
    [ Tuple (OrdinaryRate 10) (BracketStart 0)
    , Tuple (OrdinaryRate 12) (BracketStart 9950)
    , Tuple (OrdinaryRate 22) (BracketStart 40525)
    , Tuple (OrdinaryRate 24) (BracketStart 86375)
    , Tuple (OrdinaryRate 32) (BracketStart 164925)
    , Tuple (OrdinaryRate 35) (BracketStart 209425)
    , Tuple topRateOnOrdinaryIncome (BracketStart 523600)
    ]

ordinaryBracketStarts HeadOfHousehold =
  Map.fromFoldable
    [ Tuple (OrdinaryRate 10) (BracketStart 0)
    , Tuple (OrdinaryRate 12) (BracketStart 14200)
    , Tuple (OrdinaryRate 22) (BracketStart 54200)
    , Tuple (OrdinaryRate 24) (BracketStart 86350)
    , Tuple (OrdinaryRate 32) (BracketStart 164900)
    , Tuple (OrdinaryRate 35) (BracketStart 209400)
    , Tuple topRateOnOrdinaryIncome (BracketStart 523600)
    ]

-- Note: could be a constant. Keep as example of Partial
bottomRateOnOrdinaryIncome :: FilingStatus -> OrdinaryRate
bottomRateOnOrdinaryIncome fs =
  let
    brackets = ordinaryBracketStarts fs

    keys = Map.keys brackets
  in
    unsafePartial (fromJust (Set.findMin keys))

qualifiedBracketStarts :: FilingStatus -> Map QualifiedRate BracketStart
qualifiedBracketStarts Single =
  Map.fromFoldable
    [ Tuple (QualifiedRate 0) (BracketStart 0)
    , Tuple (QualifiedRate 15) (BracketStart 40400)
    , Tuple (QualifiedRate 20) (BracketStart 445850)
    ]

qualifiedBracketStarts HeadOfHousehold =
  Map.fromFoldable
    [ Tuple (QualifiedRate 0) (BracketStart 0)
    , Tuple (QualifiedRate 15) (BracketStart 54100)
    , Tuple (QualifiedRate 20) (BracketStart 473850)
    ]

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

rmdFractionForAge :: Age -> Number
rmdFractionForAge age = 1.0 / unsafePartial (fromJust (Map.lookup age distributionPeriods))

over65Increment :: Int
over65Increment = 1350

standardDeduction :: FilingStatus -> StandardDeduction
standardDeduction HeadOfHousehold = StandardDeduction (18800 + over65Increment)

standardDeduction Single = StandardDeduction (12550 + over65Increment)

bracketWidth :: (Partial) => FilingStatus -> OrdinaryRate -> Int
bracketWidth fs rate =
  --unsafePartial
  ( fromJust
      ( do
          let
            brackets = (ordinaryBracketStarts fs)

            rates = fromFoldable (Map.keys brackets)

            ratesTail = unsafePartial (fromJust (tail rates))

            pairs = zip rates ratesTail
          pair <- find (\p -> fst p == rate) pairs
          let
            successor = snd pair
          BracketStart rateStart <- Map.lookup rate brackets
          BracketStart successorStart <- Map.lookup successor brackets
          Just (successorStart - rateStart)
      )
  )

ltcgTaxStart :: FilingStatus -> Int
ltcgTaxStart fs =
  let
    BracketStart n = unsafePartial (fromJust (Map.values (qualifiedBracketStarts fs) !! 1))
  in
    n
