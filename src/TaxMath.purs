module TaxMath
  ( nonNeg
  , roundHalfUp
  ) 
where

import Prelude
import Data.Int (round, toNumber)

nonNeg :: Number -> Number
nonNeg x
  | x < 0.0 = 0.0
  | true = x

roundHalfUp :: Number -> Number
roundHalfUp = toNumber <<< round
