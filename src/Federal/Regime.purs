module Federal.Regime
  ( Regime (..),
    lastYearKnown,
    requireRegimeValidInYear
  )
where

import Prelude
import Data.Interpolate(i)
import Effect.Exception.Unsafe(unsafeThrow)

import CommonTypes (Year)

data Regime = Trump | NonTrump
derive instance Eq Regime
derive instance Ord Regime
instance Show Regime where
  show Trump = " Trump"
  show NonTrump = "NonTrump"

lastYearKnown :: Regime -> Year
lastYearKnown Trump = 2021
lastYearKnown NonTrump = 2017

requireRegimeValidInYear :: Regime -> Year -> Unit
requireRegimeValidInYear r y =
  if regimeValidInYear r y
    then unit
    else unsafeThrow $ i "Regime " (show r) " not valid in year " y

regimeValidInYear :: Regime -> Year -> Boolean
regimeValidInYear Trump y = y >= 2018
regimeValidInYear NonTrump y = y < 2018 || y > 2025
