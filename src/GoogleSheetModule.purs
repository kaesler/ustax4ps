module GoogleSheetModule
  ( module CommonTypes
  , module Federal.BoundRegime
  , module Federal.Calculator
  , module Federal.OrdinaryBrackets
  , module Federal.QualifiedBrackets
  , module Federal.RMDs
  , module Federal.Regime
  , module Federal.TaxableSocialSecurity
  , module UnsafeDates
  , maStateTaxDue
  , maStateTaxRate
  ) where

-- Import here what we want accessbible from GoogleSheetInterface

import CommonTypes (BirthDate, FilingStatus(..), unsafeReadFilingStatus)
import Data.Date (Year)
import Federal.BoundRegime (BoundRegime(..), boundRegimeForKnownYear, netDeduction, personalExemptionDeduction, standardDeduction)
import Federal.Calculator (taxDueForKnownYear)
import Federal.OrdinaryBrackets (ordinaryIncomeBracketWidth)
import Federal.QualifiedBrackets (startOfNonZeroQualifiedRateBracket)
import Federal.RMDs (unsafeRmdFractionForAge)
import Federal.Regime (Regime(..), unsafeReadRegime)
import Federal.TaxableSocialSecurity (amountTaxable, amountTaxableInflationAdjusted)
import Moneys (TaxPayable)
import StateMA.Calculator as StateCalc
import StateMA.StateMATaxRate (StateMATaxRate)
import StateMA.Types (MassachusettsGrossIncome)
import UnsafeDates (makeDateFromGoogleSheetRep, unsafeMakeDate, unsafeMakeDay, unsafeMakeMonth, unsafeMakeYear)

maStateTaxDue :: Year -> BirthDate -> Int -> FilingStatus -> MassachusettsGrossIncome -> TaxPayable
maStateTaxDue = StateCalc.taxDue

maStateTaxRate :: Year -> StateMATaxRate
maStateTaxRate = StateCalc.taxRate

