module Federal.FederalTaxRate
  ( FederalTaxRate
  , mkFederalTaxRate
  ) where

import Prelude

import TaxRate (class TaxRate )
import Effect.Exception.Unsafe (unsafeThrow)
import Data.Interpolate (i)
import Math (abs)
newtype FederalTaxRate = FederalTaxRate Number
derive newtype instance Eq FederalTaxRate
derive newtype instance Ord FederalTaxRate
derive newtype instance Show FederalTaxRate

mkFederalTaxRate :: Number -> FederalTaxRate
mkFederalTaxRate d
  | d < 0.0 = unsafeThrow $ i "Invalid FederalTaxRate " (show d)
  | d > 0.9 = unsafeThrow $ i "Invalid FederalTaxRate " (show d)
  | otherwise = FederalTaxRate d

instance TaxRate FederalTaxRate where
  zeroRate = mkFederalTaxRate 0.0
  rateToNumber (FederalTaxRate d) = d
  absoluteDifference (FederalTaxRate d1) (FederalTaxRate d2) =
    FederalTaxRate (abs (d1 - d2))
