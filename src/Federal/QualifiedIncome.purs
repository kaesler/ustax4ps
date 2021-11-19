module Federal.QualifiedIncome(
  QualifiedRate(..)
  , QualifiedIncomeBrackets
  , applyQualifiedIncomeBrackets
  , fromPairs
  , startOfNonZeroQualifiedRateBracket
)

where
  
import Prelude

import CommonTypes (OrdinaryIncome, QualifiedIncome)
import Data.Int (toNumber)
import Data.List (foldl, reverse, (!!))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (fromJust)
import Data.Tuple (Tuple(..))
import Federal.Types (BracketStart(..))
import Partial.Unsafe (unsafePartial)
import TaxMath (nonNeg)

data Triple a = Triple a a a
third :: forall a. Triple a -> a
third (Triple _ _ a) = a

newtype QualifiedRate = QualifiedRate Int
derive instance Eq QualifiedRate
derive instance Ord QualifiedRate

qualifiedRateAsFraction :: QualifiedRate -> Number
qualifiedRateAsFraction (QualifiedRate r) = toNumber r / 100.0

type QualifiedIncomeBrackets = Map QualifiedRate BracketStart
fromPairs :: Array (Tuple Int Int) ->  QualifiedIncomeBrackets 
fromPairs pairs = 
  Map.fromFoldable $
    map f pairs
      where 
        f :: Tuple Int Int -> Tuple QualifiedRate BracketStart
        f (Tuple rate start) = Tuple (QualifiedRate rate) (BracketStart start)


startOfNonZeroQualifiedRateBracket :: QualifiedIncomeBrackets -> Int
startOfNonZeroQualifiedRateBracket brackets =
  let
    -- Note: Safe by inspection of the data.
    BracketStart n = unsafePartial (fromJust (Map.values brackets !! 1))
  in
    n

applyQualifiedIncomeBrackets :: QualifiedIncomeBrackets -> OrdinaryIncome -> QualifiedIncome -> Number
applyQualifiedIncomeBrackets brackets taxableOrdinaryIncome qualifiedIncome =
  let
    bracketsDescending = reverse $ Map.toUnfoldable brackets
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
