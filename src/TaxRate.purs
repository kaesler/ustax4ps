module TaxRate
  ( class TaxRate,
    zero,
    rateToNumber,
    absoluteDifference
  )

where

import Prelude

class Ord r <= TaxRate r where
  zero :: r
  rateToNumber :: r -> Number
  absoluteDifference :: r -> r -> r
