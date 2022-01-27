module Undefined(
  undefined
) where

import Prelude

import Unsafe.Coerce (unsafeCoerce)

undefined :: forall t. t
undefined = unsafeCoerce unit