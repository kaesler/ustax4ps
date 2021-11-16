module Taxes
  ( BracketStart
  , FederalTaxResults(..)
  , OrdinaryRate(..)
  , QualifiedRate
  , StandardDeduction(..)
  , applyOrdinaryIncomeBrackets
  , applyQualifiedIncomeBrackets
  , federalTaxDue
  , federalTaxDueDebug
  , federalTaxResults
  , incomeToEndOfOrdinaryBracket
  , maStateTaxDue
  , maStateTaxRate
  , nonNeg
  , ordinaryIncomeBracketStart
  , ordinaryIncomeBracketStarts
  , ordinaryIncomeBracketWidth
  , ordinaryRateAsFraction
  , ordinaryRatesExceptTop
  , ordinaryRateSuccessor
  , rmdFractionForAge
  , roundHalfUp
  , standardDeduction
  , startOfNonZeroQualifiedRateBracket
  , taxToEndOfOrdinaryIncomeBracket
  , topRateOnOrdinaryIncome
  , unsafeOrdinaryRateFromNumber
  , unsafeOrdinaryRateSuccessor
  , unsafeRmdFractionForAge
  ) where

import Prelude

import Data.Array as Array
import Data.Foldable as Data
import Data.Int (fromNumber, round, toNumber)
import Data.List (List, (!!), find, foldl, reverse, tail, zip)
import Data.Map (Map, keys)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromJust)
import Data.Set as Set
import Data.Tuple (Tuple(..), fst, snd)
import Effect (Effect)
import Effect.Console (log)
import Partial.Unsafe (unsafePartial)

import CommonTypes (Age(..), CombinedIncome, DistributionPeriod, FilingStatus(..), MassachusettsGrossIncome, OrdinaryIncome, QualifiedIncome, SSRelevantOtherIncome, SocSec, Year)
import Federal.TaxableSocialSecurity

newtype OrdinaryRate = OrdinaryRate Int
derive instance Eq OrdinaryRate
derive instance Ord OrdinaryRate
instance showOrdinaryRate :: Show OrdinaryRate where
  show (OrdinaryRate r) = show r
unsafeOrdinaryRateFromNumber :: Number -> OrdinaryRate
unsafeOrdinaryRateFromNumber n =
  unsafePartial $ fromJust $ map (\i -> OrdinaryRate i) (fromNumber n)

ordinaryRateAsFraction :: OrdinaryRate -> Number

ordinaryRateAsFraction (OrdinaryRate r) = toNumber r / 100.0

newtype QualifiedRate = QualifiedRate Int
derive instance Eq QualifiedRate
derive instance Ord QualifiedRate

qualifiedRateAsFraction :: QualifiedRate -> Number
qualifiedRateAsFraction (QualifiedRate r) = toNumber r / 100.0

newtype BracketStart = BracketStart Int
derive instance Eq BracketStart
derive instance Ord BracketStart
instance showBracketStart :: Show BracketStart where
  show (BracketStart s) = show s
bracketStartAsNumber :: BracketStart -> Number
bracketStartAsNumber (BracketStart i) = toNumber i

newtype StandardDeduction = StandardDeduction Int
derive instance Eq StandardDeduction
derive instance Ord StandardDeduction
instance showStandardDeduction :: Show StandardDeduction where
  show (StandardDeduction sd) = show sd 

type OrdinaryBracketStarts = Map OrdinaryRate BracketStart

type QualifiedBracketStarts = Map QualifiedRate BracketStart

data Triple a = Triple a a a
third :: forall a. Triple a -> a
third (Triple _ _ a) = a

newtype FederalTaxResults
  = FederalTaxResults { ssRelevantOtherIncome :: Number
    , taxableSocSec :: Number
    , stdDeduction :: StandardDeduction
    , taxableOrdinaryIncome :: Number
    , taxOnOrdinaryIncome :: Number
    , taxOnQualifiedIncome :: Number
    } 
instance showFederalTaxResults :: Show FederalTaxResults where
  show (FederalTaxResults r) = (show r)

nonNeg :: Number -> Number
nonNeg x
  | x < 0.0 = 0.0
  | true = x

roundHalfUp :: Number -> Number
roundHalfUp = toNumber <<< round

maStateTaxRate :: Number
maStateTaxRate = 0.05

maStateTaxDue :: Year -> Int -> FilingStatus -> MassachusettsGrossIncome -> Number
maStateTaxDue year dependents filingStatus maGrossIncome =
  let
    personalExemption = if filingStatus == HeadOfHousehold then 6800.0 else 4400.0

    ageExemption = 700.0

    dependentsExemption = 1000.0 * (toNumber dependents)
  in
    maStateTaxRate * nonNeg (maGrossIncome - personalExemption - ageExemption - dependentsExemption)

federalTaxResults :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> FederalTaxResults
federalTaxResults year filingStatus socSec ordinaryIncome qualifiedIncome =
  let
    ssRelevantOtherIncome = ordinaryIncome + qualifiedIncome

    taxableSocSec = taxableSocialSecurity filingStatus socSec ssRelevantOtherIncome

    StandardDeduction sd = standardDeduction filingStatus

    taxableOrdinaryIncome = nonNeg (taxableSocSec + ordinaryIncome - toNumber sd)

    taxOnOrdinaryIncome = applyOrdinaryIncomeBrackets filingStatus taxableOrdinaryIncome

    taxOnQualifiedIncome = applyQualifiedIncomeBrackets filingStatus taxableOrdinaryIncome qualifiedIncome
  in
    FederalTaxResults { ssRelevantOtherIncome: ssRelevantOtherIncome
    , taxableSocSec: taxableSocSec
    , stdDeduction: standardDeduction filingStatus
    , taxableOrdinaryIncome: taxableOrdinaryIncome
    , taxOnOrdinaryIncome: taxOnOrdinaryIncome
    , taxOnQualifiedIncome: taxOnQualifiedIncome
    }

federalTaxDue :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> Number
federalTaxDue year filingStatus socSec taxableOrdinaryIncome qualifiedIncome =
  let
    FederalTaxResults results = federalTaxResults year filingStatus socSec taxableOrdinaryIncome qualifiedIncome
  in
    results.taxOnOrdinaryIncome + results.taxOnQualifiedIncome

federalTaxDueDebug :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> Effect Unit
federalTaxDueDebug year filingStatus socSec taxableOrdinaryIncome qualifiedIncome =
  let
    FederalTaxResults r = federalTaxResults year filingStatus socSec taxableOrdinaryIncome qualifiedIncome
    StandardDeduction sd = r.stdDeduction
  in
    do
      log "Inputs"
      log (" fs: " <> show filingStatus)
      log (" socSec: " <> show socSec)
      log (" taxableOrdinaryIncome: " <> show taxableOrdinaryIncome)
      log (" qualifiedIncome: " <> show qualifiedIncome)
      log "Outputs"
      log ("  ssRelevantOtherIncome: " <> show r.ssRelevantOtherIncome)
      log ("  taxableSocSec: " <> show r.taxableSocSec)
      log ("  standardDeduction: " <> show sd)
      log ("  taxableOrdinaryIncome: " <> show r.taxableOrdinaryIncome)
      log ("  taxOnOrdinaryIncome: " <> show r.taxOnOrdinaryIncome)
      log ("  taxOnQualifiedIncome: " <> show r.taxOnQualifiedIncome)
      log ("  result: " <> show (r.taxOnOrdinaryIncome + r.taxOnQualifiedIncome))

topRateOnOrdinaryIncome :: OrdinaryRate
topRateOnOrdinaryIncome = OrdinaryRate 37

ordinaryIncomeBracketStarts :: FilingStatus -> Map OrdinaryRate BracketStart
ordinaryIncomeBracketStarts Single =
  Map.fromFoldable
    [ Tuple (OrdinaryRate 10) (BracketStart 0)
    , Tuple (OrdinaryRate 12) (BracketStart 9950)
    , Tuple (OrdinaryRate 22) (BracketStart 40525)
    , Tuple (OrdinaryRate 24) (BracketStart 86375)
    , Tuple (OrdinaryRate 32) (BracketStart 164925)
    , Tuple (OrdinaryRate 35) (BracketStart 209425)
    , Tuple topRateOnOrdinaryIncome (BracketStart 523600)
    ]

ordinaryIncomeBracketStarts HeadOfHousehold =
  Map.fromFoldable
    [ Tuple (OrdinaryRate 10) (BracketStart 0)
    , Tuple (OrdinaryRate 12) (BracketStart 14200)
    , Tuple (OrdinaryRate 22) (BracketStart 54200)
    , Tuple (OrdinaryRate 24) (BracketStart 86350)
    , Tuple (OrdinaryRate 32) (BracketStart 164900)
    , Tuple (OrdinaryRate 35) (BracketStart 209400)
    , Tuple topRateOnOrdinaryIncome (BracketStart 523600)
    ]

ordinaryIncomeBracketStart :: FilingStatus -> OrdinaryRate -> BracketStart
ordinaryIncomeBracketStart filingStatus ordinaryRate = 
  let
    brackets = ordinaryIncomeBracketStarts filingStatus
  in
    unsafePartial $ fromJust $ Map.lookup ordinaryRate brackets

ordinaryRateSuccessor :: FilingStatus -> OrdinaryRate -> Maybe OrdinaryRate
ordinaryRateSuccessor fs rate =
  let
    brackets = ordinaryIncomeBracketStarts fs

    rates = Array.fromFoldable $ keys brackets

    ratesTail = Array.drop 1 rates

    pairs = Array.zip rates ratesTail

    pair = Array.find (\p -> fst p == rate) pairs
  in
    map snd pair

unsafeOrdinaryRateSuccessor :: FilingStatus -> OrdinaryRate -> Int
unsafeOrdinaryRateSuccessor fs rate = 
  let 
    (OrdinaryRate r) = unsafePartial $ fromJust $ ordinaryRateSuccessor fs rate
   in
     r

ordinaryRatesExceptTop :: FilingStatus -> (Array OrdinaryRate)
ordinaryRatesExceptTop fs =
  let
    brackets = ordinaryIncomeBracketStarts fs

    rates = Array.fromFoldable $ keys brackets
  in
    Array.dropEnd 1 rates

incomeToEndOfOrdinaryBracket :: FilingStatus -> OrdinaryRate -> Number
incomeToEndOfOrdinaryBracket filingStatus bracketRate =
  let
    bracketStarts = ordinaryIncomeBracketStarts filingStatus

    successorRate = unsafePartial $ fromJust (ordinaryRateSuccessor filingStatus bracketRate)

    BracketStart startOfSuccessor = unsafePartial $ fromJust (Map.lookup successorRate bracketStarts)

    StandardDeduction deduction = standardDeduction filingStatus
  in
    toNumber (startOfSuccessor + deduction)

taxToEndOfOrdinaryIncomeBracket :: FilingStatus -> OrdinaryRate -> Number
taxToEndOfOrdinaryIncomeBracket filingStatus bracketRate =
  let
    relevantRates = Array.takeWhile (_ <= bracketRate) (ordinaryRatesExceptTop filingStatus)

    bracketWidths = map (ordinaryIncomeBracketWidth filingStatus) relevantRates

    pairs = relevantRates `Array.zip` bracketWidths

    taxesDue = map taxForBracket pairs
      where
      taxForBracket (Tuple ordinaryRate width) = (toNumber width) * (ordinaryRateAsFraction ordinaryRate)
  in
    Data.sum taxesDue

-- Note: could be a constant. Keep as example of use of unsafePartial
bottomRateOnOrdinaryIncome :: FilingStatus -> OrdinaryRate
bottomRateOnOrdinaryIncome fs =
  let
    brackets = ordinaryIncomeBracketStarts fs

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

unsafeRmdFractionForAge :: Int -> Number
unsafeRmdFractionForAge age = 
  unsafePartial $ fromJust $ rmdFractionForAge (Age age)
  --(unsafePartial <<< fromJust <<< rmdFractionForAge)

over65Increment :: Int
over65Increment = 1350

standardDeduction :: FilingStatus -> StandardDeduction
standardDeduction HeadOfHousehold = StandardDeduction (18800 + over65Increment)

standardDeduction Single = StandardDeduction (12550 + over65Increment)

safeOrdinaryIncomeBracketWidth :: FilingStatus -> OrdinaryRate -> Maybe Int
safeOrdinaryIncomeBracketWidth fs rate = do
  let
    brackets = (ordinaryIncomeBracketStarts fs)

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

ordinaryIncomeBracketWidth :: FilingStatus -> OrdinaryRate -> Int
ordinaryIncomeBracketWidth fs rate = unsafePartial $ fromJust $ safeOrdinaryIncomeBracketWidth fs rate

startOfNonZeroQualifiedRateBracket :: FilingStatus -> Int
startOfNonZeroQualifiedRateBracket fs =
  let
    -- Note: Safe by inspection of the data.
    BracketStart n = unsafePartial (fromJust (Map.values (qualifiedBracketStarts fs) !! 1))
  in
    n

applyOrdinaryIncomeBrackets :: FilingStatus -> OrdinaryIncome -> Number
applyOrdinaryIncomeBrackets fs ordinaryincome =
  let
    -- Note: is this how one uses toUnfoldable?
    brackets = Map.toUnfoldable (ordinaryIncomeBracketStarts fs) :: List (Tuple OrdinaryRate BracketStart)

    bracketsDescending = reverse brackets
  in
    snd (foldl func (Tuple ordinaryincome 0.0) bracketsDescending)
  where
  func :: (Tuple Number Number) -> (Tuple OrdinaryRate BracketStart) -> Tuple Number Number
  func (Tuple incomeYetToBeTaxed taxSoFar) (Tuple rate (BracketStart start)) =
    let
      incomeInThisBracket = nonNeg (incomeYetToBeTaxed - toNumber start)

      taxInThisBracket = incomeInThisBracket * ordinaryRateAsFraction rate
    in
      ( Tuple (nonNeg (incomeYetToBeTaxed - incomeInThisBracket))
          (taxSoFar + taxInThisBracket)
      )

applyQualifiedIncomeBrackets :: FilingStatus -> OrdinaryIncome -> QualifiedIncome -> Number
applyQualifiedIncomeBrackets fs taxableOrdinaryIncome qualifiedIncome =
  let
    brackets = Map.toUnfoldable (qualifiedBracketStarts fs) :: List (Tuple QualifiedRate BracketStart)

    bracketsDescending = reverse brackets
  in
    third (foldl func (Triple 0.0 qualifiedIncome 0.0) bracketsDescending)
  where
  totalIncome = taxableOrdinaryIncome + qualifiedIncome

  func :: (Triple Number) -> (Tuple QualifiedRate BracketStart) -> (Triple Number)
  func (Triple totalIncomeInHigherBrackets gainsYetToBeTaxed gainsTaxSoFar) (Tuple rate (BracketStart start)) =
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
