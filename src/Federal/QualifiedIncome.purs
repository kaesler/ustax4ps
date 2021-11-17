module Federal.QualifiedIncome(
  QualifiedRate(..)
  , applyQualifiedIncomeBrackets
  , startOfNonZeroQualifiedRateBracket
)

where
  
import Prelude

import Data.Int (toNumber)
import Data.Map (Map)
import Data.List (List, foldl, reverse, (!!))
import Data.Map as Map
import Data.Maybe (fromJust)
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)

import CommonTypes (FilingStatus(..), OrdinaryIncome, QualifiedIncome)
import Federal.Types (BracketStart(..))
import TaxMath(nonNeg)

data Triple a = Triple a a a
third :: forall a. Triple a -> a
third (Triple _ _ a) = a

newtype QualifiedRate = QualifiedRate Int
derive instance Eq QualifiedRate
derive instance Ord QualifiedRate

qualifiedRateAsFraction :: QualifiedRate -> Number
qualifiedRateAsFraction (QualifiedRate r) = toNumber r / 100.0

type QualifiedBracketStarts = Map QualifiedRate BracketStart

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





startOfNonZeroQualifiedRateBracket :: FilingStatus -> Int
startOfNonZeroQualifiedRateBracket fs =
  let
    -- Note: Safe by inspection of the data.
    BracketStart n = unsafePartial (fromJust (Map.values (qualifiedBracketStarts fs) !! 1))
  in
    n

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
