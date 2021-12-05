module MathInSpecs
  ( closeEnoughTo
  ) where

import Prelude
import Math (abs)

closeEnoughTo :: Number -> Number -> Boolean
closeEnoughTo x y = abs (x - y) <= 2.0
