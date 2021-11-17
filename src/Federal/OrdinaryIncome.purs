module Federal.OrdinaryIncome(
  OrdinaryRate(..),
  applyOrdinaryIncomeBrackets,
  ordinaryRateAsFraction,
  topRateOnOrdinaryIncome,
  incomeToEndOfOrdinaryBracket, 
  ordinaryRatesExceptTop, 
  ordinaryIncomeBracketStart, 
  taxToEndOfOrdinaryIncomeBracket,
  ordinaryIncomeBracketWidth,
  ordinaryRateSuccessor,
  unsafeOrdinaryRateFromNumber,
  unsafeOrdinaryRateSuccessor
)

where
  
import Prelude (class Eq, class Ord, class Show, bind, map, show, ($), (*), (+), (-), (/), (<=), (==))

import Data.Int (fromNumber, toNumber)
import Data.Map (Map, keys)
import Data.List (List, find, foldl, reverse, tail, zip)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromJust)
import Data.Tuple (Tuple(..), fst, snd)
import Partial.Unsafe (unsafePartial)
import Data.Array as Array
import Data.Foldable as Data
import Data.Set as Set

import CommonTypes
import Federal.Types
import TaxMath

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

type OrdinaryBracketStarts = Map OrdinaryRate BracketStart

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

