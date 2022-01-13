module TaxRate
  ( class TaxRate,
    zero,
    toNumber,
    absoluteDifference
  )

where

import Prelude

class Ord r <= TaxRate r where
  zero :: r
  toNumber :: r -> Number
  absoluteDifference :: r -> r -> r
