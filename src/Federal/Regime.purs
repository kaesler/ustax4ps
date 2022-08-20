module Federal.Regime
  ( Regime(..)
  , unsafeReadRegime
  )
  where

import Data.Maybe (Maybe(..), fromJust)
import Data.String.Read (class Read, read)
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, class Show, ($))

data Regime = TCJA | PreTCJA
derive instance Eq Regime
derive instance Ord Regime
instance Show Regime where
  show TCJA = "TCJA"
  show PreTCJA = "PreTCJA"
instance Read Regime where
  read s = 
    case s of 
      "TCJA" -> Just TCJA
      "PreTCJA" -> Just PreTCJA
      _ -> Nothing

unsafeReadRegime :: String -> Regime
unsafeReadRegime s = unsafePartial $ fromJust (read s) :: Regime

