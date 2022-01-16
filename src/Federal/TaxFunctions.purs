module Federal.TaxFunctions
  ( taxDueOnOrdinaryIncome
  , taxDueOnQualifiedIncome
  ) where

import Federal.OrdinaryBrackets as OB
import Federal.QualifiedBrackets as QB
import Federal.QualifiedBrackets (QualifiedBrackets)
import Moneys (TaxPayable, TaxableIncome, reduceBy)
import Prelude

taxDueOnOrdinaryIncome :: OB.OrdinaryBrackets -> TaxableIncome -> TaxPayable
taxDueOnOrdinaryIncome = OB.taxFunctionFor

taxDueOnQualifiedIncome :: QualifiedBrackets -> TaxableIncome -> TaxableIncome -> TaxPayable
taxDueOnQualifiedIncome brackets taxableOrdinaryIncome qualifiedIncome =
  let
    taxFunction = QB.taxFunctionFor brackets

    taxOnBoth = taxFunction $ taxableOrdinaryIncome <> qualifiedIncome

    taxOnOrdinary = taxFunction taxableOrdinaryIncome
  in
    taxOnBoth `reduceBy` taxOnOrdinary
