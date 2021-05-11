module Taxes
  ( Age
  , FilingStatus(..)
  , Year
  , BracketStart
  , OrdinaryRate
  , QualifiedRate
  , StandardDeduction
  , ordinaryBracketStarts
  , rmdFractionForAge
  , standardDeduction
  , bracketWidth
  , startOfNonZeroQualifiedRateBracket
  , taxableSocialSecurityAdjusted
  , applyOrdinaryIncomeBrackets
  , applyQualifiedBrackets
  ) where

-- TODO: unit tests
-- TODO: verifagainst Typescript impl
-- TODO: bundle for use in Google sheets
-- TODO: Try Emacs for PS
import Data.Int (toNumber)
import Data.List (List, (!!), find, foldr, reverse, tail, zip)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromJust)
import Data.Ord ((<), min)
import Data.Set as Set
import Data.Show (class Show, show)
import Data.Tuple (Tuple(..), fst, snd)
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, bind, (*), (+), (-), (/), (==))

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

instance showFilingStatus :: Show FilingStatus where
    show HeadOfHousehold = "HeadOfHousehold"
    show Single = "Single"
  
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

data Triple a
  = Triple a a a

third :: forall a. Triple a -> a
third (Triple _ _ a) = a

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

rmdFractionForAge :: Age -> Maybe Number
rmdFractionForAge age = do
  distributionPeriod <- Map.lookup age distributionPeriods
  Just (1.0 / distributionPeriod)

over65Increment :: Int
over65Increment = 1350

standardDeduction :: FilingStatus -> StandardDeduction
standardDeduction HeadOfHousehold = StandardDeduction (18800 + over65Increment)

standardDeduction Single = StandardDeduction (12550 + over65Increment)

bracketWidth :: FilingStatus -> OrdinaryRate -> Maybe Int
bracketWidth fs rate = do
  let
    brackets = (ordinaryBracketStarts fs)

    rates = Set.toUnfoldable (Map.keys brackets) :: List OrdinaryRate
  ratesTail <- (tail rates)
  let
    pairs = zip rates ratesTail
  pair <- find (\p -> fst p == rate) pairs
  let
    successor = snd pair
  BracketStart rateStart <- Map.lookup rate brackets
  BracketStart successorStart <- Map.lookup successor brackets
  Just (successorStart - rateStart)

startOfNonZeroQualifiedRateBracket :: FilingStatus -> Int
startOfNonZeroQualifiedRateBracket fs =
  let
    -- Note: Safe by inspection of the data.
    BracketStart n = unsafePartial (fromJust (Map.values (qualifiedBracketStarts fs) !! 1))
  in
    n

taxableSocialSecurityAdjusted :: Year -> FilingStatus -> SocialSecurityBenefits -> SSRelevantIncome -> Number
taxableSocialSecurityAdjusted year filingStatus ssBenefits relevantIncome =
  let
    unadjusted = taxableSocialSecurity filingStatus ssBenefits relevantIncome

    adjustmentFactor = 1.0 + (0.03 * toNumber (year - 2021))

    adjusted = unadjusted * adjustmentFactor
  in
    min adjusted ssBenefits * 0.85

taxableSocialSecurity :: FilingStatus -> SocialSecurityBenefits -> SSRelevantIncome -> Number
taxableSocialSecurity filingStatus ssBenefits relevantIncome =
  let
    lowBase = case filingStatus of
      Single -> 25000.0
      HeadOfHousehold -> 25000.0

    highBase = case filingStatus of
      Single -> 34000.0
      HeadOfHousehold -> 34000.0

    combinedIncome = relevantIncome + (ssBenefits / 2.0)
  in
    f combinedIncome (Tuple lowBase highBase)
  where
  f :: CombinedIncome -> Tuple CombinedIncome CombinedIncome -> Number
  f combinedIncome (Tuple lowBase highBase)
    | combinedIncome < lowBase = 0.0
    | combinedIncome < highBase =
      let
        fractionTaxable = 0.5

        maxSocSecTaxable = ssBenefits * fractionTaxable
      in
        min ((combinedIncome - lowBase) * fractionTaxable) maxSocSecTaxable
    | true =
      let
        fractionTaxable = 0.85

        maxSocSecTaxable = ssBenefits * fractionTaxable
      in
        min (4500.0 + ((combinedIncome - highBase) * fractionTaxable)) maxSocSecTaxable

applyOrdinaryIncomeBrackets :: FilingStatus -> TaxableOrdinaryIncome -> Number
applyOrdinaryIncomeBrackets fs taxableOrdinaryincome =
  let
    -- Note: is this how one uses toUnfoldable?
    brackets = Map.toUnfoldable (ordinaryBracketStarts fs) :: List (Tuple OrdinaryRate BracketStart)

    bracketsDescending = reverse brackets
  in
    snd (foldr func (Tuple taxableOrdinaryincome 0.0) bracketsDescending)
  where
  func :: (Tuple OrdinaryRate BracketStart) -> Tuple Number Number -> Tuple Number Number
  func (Tuple rate (BracketStart start)) (Tuple incomeYetToBeTaxed taxSoFar) =
    let
      incomeInThisBracket = nonNeg (incomeYetToBeTaxed - toNumber start)

      taxInThisBracket = incomeInThisBracket * ordinaryRateAsFraction rate
    in
      ( Tuple (nonNeg (incomeYetToBeTaxed - incomeInThisBracket))
          (taxSoFar + taxInThisBracket)
      )

applyQualifiedBrackets :: FilingStatus -> TaxableOrdinaryIncome -> QualifiedInvestmentIncome -> Number
applyQualifiedBrackets fs taxableOrdinaryIncome qualifiedInvestmentIncome =
  let
    brackets = Map.toUnfoldable (qualifiedBracketStarts fs) :: List (Tuple QualifiedRate BracketStart)

    bracketsDescending = reverse brackets
  in
    third (foldr func (Triple taxableOrdinaryIncome qualifiedInvestmentIncome 0.0) bracketsDescending)
  where
  totalIncome = taxableOrdinaryIncome + qualifiedInvestmentIncome

  func :: (Tuple QualifiedRate BracketStart) -> (Triple Number) -> (Triple Number)
  func (Tuple rate (BracketStart start)) (Triple totalIncomeInHigherBrackets gainsYetToBeTaxed gainsTaxSoFar) =
    let
      totalIncomeYetToBeTaxed = nonNeg (totalIncome - totalIncomeInHigherBrackets)

      ordinaryIncomeYetToBeTaxed = nonNeg (totalIncomeYetToBeTaxed - gainsYetToBeTaxed)

      totalIncomeInThisBracket = nonNeg (totalIncomeYetToBeTaxed - toNumber start)

      ordinaryIncomeInThisBracket = nonNeg (ordinaryIncomeYetToBeTaxed - toNumber start)

      gainsInThisBracket = nonNeg (totalIncomeInThisBracket - ordinaryIncomeInThisBracket)

      taxInThisBracket = gainsInThisBracket * qualifiedRateAsFraction rate
    in
      ( Triple
          (totalIncomeInHigherBrackets + totalIncomeInThisBracket)
          (nonNeg (gainsYetToBeTaxed - gainsInThisBracket))
          (gainsTaxSoFar + taxInThisBracket)
      )
