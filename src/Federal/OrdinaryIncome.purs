module Federal.OrdinaryIncome(
  OrdinaryIncomeBrackets(..),
  OrdinaryRate(..),
  applyOrdinaryIncomeBrackets,
  bottomRateOnOrdinaryIncome,
  fromPairs,
  incomeToEndOfOrdinaryBracket, 
  ordinaryIncomeBracketStart, 
  ordinaryIncomeBracketWidth,
  ordinaryRate,
  ordinaryRateAsFraction,
  ordinaryRatesExceptTop, 
  ordinaryRateSuccessor,
  taxToEndOfOrdinaryIncomeBracket,
  topRateOnOrdinaryIncome,
  unsafeOrdinaryRateSuccessor
)

where
  
import TaxMath

import Data.Array as Array
import Data.Foldable as Foldable
import Data.Int (toNumber)
import Data.List (List, find, foldl, reverse, tail, zip)
import Data.Map (Map, keys)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromJust)
import Data.Set as Set
import Data.Tuple (Tuple(..), fst, snd)
import Federal.Types (BracketStart(..), OrdinaryIncome, StandardDeduction(..))
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, class Show, bind, map, show, ($), (*), (+), (-), (/), (<=), (==))

-- TODO: restrict to 0..99?
newtype OrdinaryRate = OrdinaryRate Number
derive instance Eq OrdinaryRate
derive instance Ord OrdinaryRate
instance Show OrdinaryRate where
  show (OrdinaryRate r) = show r
ordinaryRate :: Int -> OrdinaryRate
ordinaryRate i = OrdinaryRate (toNumber i)

ordinaryRateAsFraction :: OrdinaryRate -> Number
ordinaryRateAsFraction (OrdinaryRate r) = r / 100.0

type OrdinaryIncomeBrackets = Map OrdinaryRate BracketStart

fromPairs :: Array (Tuple Number Int) -> OrdinaryIncomeBrackets
fromPairs tuples = 
  Map.fromFoldable $
    map f tuples
      where 
        f :: Tuple Number Int -> Tuple OrdinaryRate BracketStart
        f (Tuple rate start) = Tuple (OrdinaryRate rate) (BracketStart start)

ordinaryIncomeBracketStart :: OrdinaryIncomeBrackets -> OrdinaryRate -> BracketStart
ordinaryIncomeBracketStart brackets rate = 
  unsafePartial $ fromJust $ Map.lookup rate brackets

ordinaryRateSuccessor :: OrdinaryIncomeBrackets -> OrdinaryRate -> Maybe OrdinaryRate
ordinaryRateSuccessor brackets rate =
  let
    rates = Array.fromFoldable $ keys brackets

    ratesTail = Array.drop 1 rates

    pairs = Array.zip rates ratesTail

    pair = Array.find (\p -> fst p == rate) pairs
  in
    map snd pair

unsafeOrdinaryRateSuccessor :: OrdinaryIncomeBrackets -> OrdinaryRate -> Number
unsafeOrdinaryRateSuccessor brackets rate = 
  let 
    (OrdinaryRate r) = unsafePartial $ fromJust $ ordinaryRateSuccessor brackets rate
   in
     r

ordinaryRatesExceptTop :: OrdinaryIncomeBrackets -> (Array OrdinaryRate)
ordinaryRatesExceptTop brackets =
  let
    rates = Array.fromFoldable $ keys brackets
  in
    Array.dropEnd 1 rates

incomeToEndOfOrdinaryBracket :: OrdinaryIncomeBrackets -> StandardDeduction -> OrdinaryRate -> Number
incomeToEndOfOrdinaryBracket brackets standardDeduction bracketRate =
  let
    successorRate = unsafePartial $ fromJust (ordinaryRateSuccessor brackets bracketRate)

    BracketStart startOfSuccessor = unsafePartial $ fromJust (Map.lookup successorRate brackets)

    StandardDeduction deduction = standardDeduction
  in
    toNumber (startOfSuccessor + deduction)

taxToEndOfOrdinaryIncomeBracket :: OrdinaryIncomeBrackets -> OrdinaryRate -> Number
taxToEndOfOrdinaryIncomeBracket brackets bracketRate =
  let
    relevantRates = Array.takeWhile (_ <= bracketRate) (ordinaryRatesExceptTop brackets)

    bracketWidths = map (ordinaryIncomeBracketWidth brackets) relevantRates

    pairs = relevantRates `Array.zip` bracketWidths

    taxesDue = map taxForBracket pairs
      where
      taxForBracket (Tuple rate width) = (toNumber width) * (ordinaryRateAsFraction rate)
  in
    Foldable.sum taxesDue

topRateOnOrdinaryIncome :: OrdinaryIncomeBrackets -> OrdinaryRate
topRateOnOrdinaryIncome brackets = 
  let
    keys = Map.keys brackets
  in
    unsafePartial (fromJust (Set.findMax keys))

bottomRateOnOrdinaryIncome :: OrdinaryIncomeBrackets -> OrdinaryRate
bottomRateOnOrdinaryIncome brackets =
  let
    keys = Map.keys brackets
  in
    unsafePartial (fromJust (Set.findMin keys))

applyOrdinaryIncomeBrackets :: OrdinaryIncomeBrackets -> OrdinaryIncome -> Number
applyOrdinaryIncomeBrackets brackets ordinaryincome =
  let
    -- Note: is this how one uses toUnfoldable?
    tuples = Map.toUnfoldable brackets :: List (Tuple OrdinaryRate BracketStart)

    bracketsDescending = reverse tuples
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

safeOrdinaryIncomeBracketWidth :: OrdinaryIncomeBrackets -> OrdinaryRate -> Maybe Int
safeOrdinaryIncomeBracketWidth brackets rate = do
  let
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

ordinaryIncomeBracketWidth :: OrdinaryIncomeBrackets -> OrdinaryRate -> Int
ordinaryIncomeBracketWidth brackets rate = 
  unsafePartial $ fromJust $ safeOrdinaryIncomeBracketWidth brackets rate
