module Taxes
  ( FederalTaxResults(..)
  , federalTaxDue
  , federalTaxDueDebug
  , federalTaxResults
  , maStateTaxDue
  , maStateTaxRate
  ) where

import Prelude
import Data.Int (toNumber)
import Effect (Effect)
import Effect.Console (log)
import CommonTypes
  ( FilingStatus(..)
  , MassachusettsGrossIncome
  , OrdinaryIncome
  , QualifiedIncome
  , SocSec
  , Year
  )
import TaxMath (nonNeg)
import Federal.TaxableSocialSecurity (taxableSocialSecurity)
import Federal.Types (StandardDeduction(..), standardDeduction)
import Federal.OrdinaryIncome (applyOrdinaryIncomeBrackets)
import Federal.QualifiedIncome (applyQualifiedIncomeBrackets)

newtype FederalTaxResults
  = FederalTaxResults
  { ssRelevantOtherIncome :: Number
  , taxableSocSec :: Number
  , stdDeduction :: StandardDeduction
  , taxableOrdinaryIncome :: Number
  , taxOnOrdinaryIncome :: Number
  , taxOnQualifiedIncome :: Number
  }

instance Show FederalTaxResults where
  show (FederalTaxResults r) = (show r)

maStateTaxRate :: Number
maStateTaxRate = 0.05

maStateTaxDue :: Year -> Int -> FilingStatus -> MassachusettsGrossIncome -> Number
maStateTaxDue year dependents filingStatus maGrossIncome =
  let
    personalExemption = if filingStatus == HeadOfHousehold then 6800.0 else 4400.0

    ageExemption = 700.0

    dependentsExemption = 1000.0 * (toNumber dependents)
  in
    maStateTaxRate * nonNeg (maGrossIncome - personalExemption - ageExemption - dependentsExemption)

federalTaxResults :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> FederalTaxResults
federalTaxResults year filingStatus socSec ordinaryIncome qualifiedIncome =
  let
    ssRelevantOtherIncome = ordinaryIncome + qualifiedIncome

    taxableSocSec = taxableSocialSecurity filingStatus socSec ssRelevantOtherIncome

    StandardDeduction sd = standardDeduction filingStatus

    taxableOrdinaryIncome = nonNeg (taxableSocSec + ordinaryIncome - toNumber sd)

    taxOnOrdinaryIncome = applyOrdinaryIncomeBrackets filingStatus taxableOrdinaryIncome

    taxOnQualifiedIncome = applyQualifiedIncomeBrackets filingStatus taxableOrdinaryIncome qualifiedIncome
  in
    FederalTaxResults
      { ssRelevantOtherIncome: ssRelevantOtherIncome
      , taxableSocSec: taxableSocSec
      , stdDeduction: standardDeduction filingStatus
      , taxableOrdinaryIncome: taxableOrdinaryIncome
      , taxOnOrdinaryIncome: taxOnOrdinaryIncome
      , taxOnQualifiedIncome: taxOnQualifiedIncome
      }

federalTaxDue :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> Number
federalTaxDue year filingStatus socSec taxableOrdinaryIncome qualifiedIncome =
  let
    FederalTaxResults results = federalTaxResults year filingStatus socSec taxableOrdinaryIncome qualifiedIncome
  in
    results.taxOnOrdinaryIncome + results.taxOnQualifiedIncome

federalTaxDueDebug :: Year -> FilingStatus -> SocSec -> OrdinaryIncome -> QualifiedIncome -> Effect Unit
federalTaxDueDebug year filingStatus socSec taxableOrdinaryIncome qualifiedIncome =
  let
    FederalTaxResults r = federalTaxResults year filingStatus socSec taxableOrdinaryIncome qualifiedIncome

    StandardDeduction sd = r.stdDeduction
  in
    do
      log "Inputs"
      log (" fs: " <> show filingStatus)
      log (" socSec: " <> show socSec)
      log (" taxableOrdinaryIncome: " <> show taxableOrdinaryIncome)
      log (" qualifiedIncome: " <> show qualifiedIncome)
      log "Outputs"
      log ("  ssRelevantOtherIncome: " <> show r.ssRelevantOtherIncome)
      log ("  taxableSocSec: " <> show r.taxableSocSec)
      log ("  standardDeduction: " <> show sd)
      log ("  taxableOrdinaryIncome: " <> show r.taxableOrdinaryIncome)
      log ("  taxOnOrdinaryIncome: " <> show r.taxOnOrdinaryIncome)
      log ("  taxOnQualifiedIncome: " <> show r.taxOnQualifiedIncome)
      log ("  result: " <> show (r.taxOnOrdinaryIncome + r.taxOnQualifiedIncome))
