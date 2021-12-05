module GoogleSheetModule
  ( module CommonTypes
  , module Federal.BoundRegime
  , module Federal.Calculator
  , module Federal.OrdinaryIncome
  , module Federal.QualifiedIncome
  , module Federal.RMDs
  , module Federal.Regime
  , module Federal.TaxableSocialSecurity
  , module UnsafeDates
  , stateTaxDue
  )
  where

-- Import here waht we want accessbible from GoogleSheetInterface

import CommonTypes (BirthDate, FilingStatus(..), Money, unsafeReadFilingStatus)
import Data.Date (Year)
import Federal.BoundRegime (BoundRegime(..), bindRegime, netDeduction, personalExemptionDeduction, standardDeduction)
import Federal.Calculator (taxDue)
import Federal.OrdinaryIncome (ordinaryIncomeBracketStart, ordinaryIncomeBracketWidth)
import Federal.QualifiedIncome (startOfNonZeroQualifiedRateBracket)
import Federal.RMDs (unsafeRmdFractionForAge)
import Federal.Regime (Regime(..), unsafeReadRegime)
import Federal.TaxableSocialSecurity (amountTaxableInflationAdjusted)
import StateMA.Calculator as StateCalc
import StateMA.Types (MassachusettsGrossIncome)
import UnsafeDates (unsafeMakeDate, unsafeMakeDay, unsafeMakeMonth, unsafeMakeYear)

stateTaxDue :: Year -> BirthDate -> Int -> FilingStatus -> MassachusettsGrossIncome -> Money
stateTaxDue = StateCalc.taxDue

