module GoogleSheetModule
  ( module CommonTypes
  , module Federal.BoundRegime
  , module Federal.OrdinaryIncome
  , module Federal.QualifiedIncome
  , module Federal.Regime
  , module Federal.RMDs
  , module Federal.TaxableSocialSecurity
  , module UnsafeDates
  , showIt
  ) where

-- Import here waht we want accessbible from GoogleSheetInterface

import Prelude
import UnsafeDates (unsafeMakeDate, unsafeMakeDay, unsafeMakeMonth, unsafeMakeYear)
import CommonTypes (FilingStatus(..), unsafeReadFilingStatus)
import Federal.BoundRegime (BoundRegime(..), bindRegime, netDeduction, personalExemptionDeduction, standardDeduction)
import Federal.OrdinaryIncome (ordinaryIncomeBracketStart, ordinaryIncomeBracketWidth)
import Federal.QualifiedIncome (startOfNonZeroQualifiedRateBracket)
import Federal.RMDs (unsafeRmdFractionForAge)
import Federal.Regime (Regime(..), unsafeReadRegime)
import Federal.TaxableSocialSecurity (amountTaxableInflationAdjusted)

showIt :: forall t. Show t => t -> String
showIt x = show x
