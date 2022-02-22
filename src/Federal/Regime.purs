module Federal.Regime
  ( Regime(..)
  , unsafeReadRegime
  )
  where

import Data.Maybe (Maybe(..), fromJust)
import Data.String.Read (class Read, read)
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, class Show, ($))

data Regime = Trump | PreTrump
derive instance Eq Regime
derive instance Ord Regime
instance Show Regime where
  show Trump = "Trump"
  show PreTrump = "PreTrump"
instance Read Regime where
  read s = 
    case s of 
      "Trump" -> Just Trump
      "PreTrump" -> Just PreTrump
      _ -> Nothing

unsafeReadRegime :: String -> Regime
unsafeReadRegime s = unsafePartial $ fromJust (read s) :: Regime

