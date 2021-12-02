module Federal.Regime
  ( Regime (..),
    invalidRegime,
    lastYearKnown,
    requireRegimeValidInYear,
    unsafeReadRegime
  )
where

import Data.Enum

import Data.Date (Year)
import Data.Interpolate (i)
import Data.Maybe (Maybe(..), fromJust)
import Data.String.Read (class Read, read)
import Effect.Exception.Unsafe (unsafeThrow)
import Partial.Unsafe (unsafePartial)
import Prelude (class Eq, class Ord, class Show, Unit, show, unit, ($), (<), (>), (>=), (||))
import UnsafeDates (unsafeMakeYear)

data Regime = Trump | NonTrump
derive instance Eq Regime
derive instance Ord Regime
instance Show Regime where
  show Trump = " Trump"
  show NonTrump = "NonTrump"
instance Read Regime where
  read s = 
    case s of 
      "Trump" -> Just Trump
      "NonTrump" -> Just NonTrump
      _ -> Nothing

unsafeReadRegime :: String -> Regime
unsafeReadRegime s = unsafePartial $ fromJust (read s) :: Regime

lastYearKnown :: Regime -> Year
lastYearKnown Trump = unsafeMakeYear 2022
lastYearKnown NonTrump = unsafeMakeYear 2017

requireRegimeValidInYear :: Regime -> Year -> Unit
requireRegimeValidInYear r y =
  if regimeValidInYear r y
    then unit
    else invalidRegime r y

regimeValidInYear :: Regime -> Year -> Boolean
regimeValidInYear Trump y = fromEnum y >= 2018
regimeValidInYear NonTrump y = fromEnum y < 2018 || fromEnum y > 2025

invalidRegime :: forall a. Regime -> Year -> a
invalidRegime regime year = 
  unsafeThrow $ i "Regime " (show regime) " not valid in year " (show year)
