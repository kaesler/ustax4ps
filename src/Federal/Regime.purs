module Federal.Regime
  ( Regime (..),
    lastYearKnown,
    requireRegimeValidInYear
  )
where

import Prelude (class Eq, class Ord, class Show, Unit, show, unit, ($), (<), (>), (>=), (||))
import Data.Date( Year)
import Data.Enum
import Data.Interpolate(i)
import Data.Maybe (fromJust)
import Effect.Exception.Unsafe(unsafeThrow)
import Partial.Unsafe (unsafePartial)

data Regime = Trump | NonTrump
derive instance Eq Regime
derive instance Ord Regime
instance Show Regime where
  show Trump = " Trump"
  show NonTrump = "NonTrump"

lastYearKnown :: Regime -> Year
lastYearKnown Trump = unsafePartial $ fromJust $ toEnum 2021
lastYearKnown NonTrump = unsafePartial $ fromJust $ toEnum 2017

requireRegimeValidInYear :: Regime -> Year -> Unit
requireRegimeValidInYear r y =
  if regimeValidInYear r y
    then unit
    else invalidRegime r y

regimeValidInYear :: Regime -> Year -> Boolean
regimeValidInYear Trump y = fromEnum y >= 2018
regimeValidInYear NonTrump y = fromEnum y < 2018 || fromEnum y > 2025

invalidRegime :: Regime -> Year -> Unit
invalidRegime regime year = 
  unsafeThrow $ i "Regime " (show regime) " not valid in year " (show year)
