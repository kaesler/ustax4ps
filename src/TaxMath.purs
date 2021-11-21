module TaxMath
  ( nonNeg
  , nonNegSub
  , roundHalfUp
  ) 
where

import Prelude
import Data.Int (round, toNumber)

nonNeg :: Number -> Number
nonNeg x
  | x < 0.0 = 0.0
  | true = x

nonNegSub :: Number -> Number -> Number
nonNegSub x y = nonNeg (x - y)

roundHalfUp :: Number -> Number
roundHalfUp = toNumber <<< round
