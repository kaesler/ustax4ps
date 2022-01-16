module TaxRate
  ( class TaxRate,
    zeroRate,
    rateToNumber,
    absoluteDifference
  )

where

import Prelude

class Ord r <= TaxRate r where
  zeroRate :: r
  rateToNumber :: r -> Number
  absoluteDifference :: r -> r -> r
