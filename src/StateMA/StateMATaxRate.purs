module StateMA.StateMATaxRate(
  StateMATaxRate,
  mkStateMATaxRate
)

where

import TaxRate ( class TaxRate )
import Effect.Exception.Unsafe (unsafeThrow)
import Data.Interpolate (i)
import Math (abs)
import Prelude
newtype StateMATaxRate = StateMATaxRate Number 
derive newtype instance Eq StateMATaxRate
derive newtype instance Ord StateMATaxRate
derive newtype instance Show StateMATaxRate

mkStateMATaxRate :: Number -> StateMATaxRate
mkStateMATaxRate d
  | d < 0.0 = unsafeThrow $ i "Invalid StaateMARaxRate " (show d)
  | d > 0.9 = unsafeThrow $ i "Invalid StaateMARaxRate " (show d)
  | otherwise = StateMATaxRate d

instance TaxRate StateMATaxRate where
  zeroRate = mkStateMATaxRate 0.0
  rateToNumber (StateMATaxRate d) = d
  absoluteDifference (StateMATaxRate d1) (StateMATaxRate d2) = 
    StateMATaxRate (abs (d1 - d2))
