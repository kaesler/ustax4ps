module Federal.Calculator(
  TaxCalculator,
  FederalTaxResults(..),
  makeCalculator,
  taxDue,
  taxDueDebug,
  taxResults
)

where

import Prelude
import Effect.Console (log)
import Data.Date (Year)
import Data.Enum (fromEnum)
import Effect (Effect)
import CommonTypes (BirthDate, FilingStatus, Money, OrdinaryIncome, QualifiedIncome, SocSec)
import Federal.OrdinaryIncome (applyOrdinaryIncomeBrackets)
import Federal.QualifiedIncome (applyQualifiedIncomeBrackets)
import Federal.BoundRegime (BoundRegime(..), bindRegime, netDeduction, personalExemptionDeduction, standardDeduction)
import Federal.Regime (Regime)
import Federal.TaxableSocialSecurity as TSS
import Federal.Types (ItemizedDeductions, PersonalExemptions, StandardDeduction)
import TaxMath(nonNegSub)

type TaxCalculator = SocSec -> OrdinaryIncome -> QualifiedIncome -> ItemizedDeductions -> FederalTaxResults

makeCalculator :: BoundRegime -> TaxCalculator
makeCalculator br socSec ordinaryIncome qualifiedIncome itemized =
  let BoundRegime brRec = br
      ssRelevantOtherIncome = ordinaryIncome + qualifiedIncome
      taxableSocSec = TSS.amountTaxable brRec.filingStatus socSec ssRelevantOtherIncome
      taxableOrdinaryIncome = (taxableSocSec + ordinaryIncome) `nonNegSub` (netDeduction br) itemized
      taxOnOrdinaryIncome = applyOrdinaryIncomeBrackets brRec.ordinaryIncomeBrackets taxableOrdinaryIncome
      taxOnQualifiedIncome = applyQualifiedIncomeBrackets brRec.qualifiedIncomeBrackets taxableOrdinaryIncome qualifiedIncome
   in FederalTaxResults
        { boundRegime: br,
          ssRelevantOtherIncome: ssRelevantOtherIncome,
          taxableSocSec: taxableSocSec,
          finalStandardDeduction: standardDeduction br,
          finalPersonalExemptionDeduction: personalExemptionDeduction br,
          finalNetDeduction: netDeduction br itemized,
          taxableOrdinaryIncome: taxableOrdinaryIncome,
          taxOnOrdinaryIncome: taxOnOrdinaryIncome,
          taxOnQualifiedIncome: taxOnQualifiedIncome
        }

newtype FederalTaxResults = FederalTaxResults
  { boundRegime :: BoundRegime,
    ssRelevantOtherIncome :: Money,
    taxableSocSec :: Money,
    finalStandardDeduction :: StandardDeduction,
    finalPersonalExemptionDeduction :: Money,
    finalNetDeduction :: Money,
    taxableOrdinaryIncome :: Money,
    taxOnOrdinaryIncome :: Money,
    taxOnQualifiedIncome :: Money
  }
instance Show FederalTaxResults where
  show (FederalTaxResults r) = (show r)

taxResults ::
  Regime ->
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  FederalTaxResults
taxResults regime year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let boundRegime = bindRegime regime (fromEnum year) filingStatus birthDate personalExemptions
      calculator = makeCalculator boundRegime
   in calculator socSec ordinaryIncome qualifiedIncome itemized

taxDue ::
  Regime ->
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Number
taxDue regime year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults results = taxResults regime year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized
   in results.taxOnOrdinaryIncome + results.taxOnQualifiedIncome

taxDueDebug ::
  Regime ->
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Effect Unit
taxDueDebug regime year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults r = taxResults regime year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized
   in do
        log "Inputs"
        log $ " fs: " <> show filingStatus
        log $ " socSec: " <> show socSec
        log $ " ordinaryIncome: " <> show ordinaryIncome
        log $ " qualifiedIncome: " <> show qualifiedIncome
        log $ " itemizedDeductions: " <> show itemized
        log "Outputs"
        log $ "  ssRelevantOtherIncome: " <> show r.ssRelevantOtherIncome
        log $ "  taxableSocSec: " <> show r.taxableSocSec
        log $ "  finalStandardDeduction: " <> show r.finalStandardDeduction
        log $ "  finalNetDeduction: " <> show r.finalNetDeduction
        log $ "  taxableOrdinaryIncome: " <> show r.taxableOrdinaryIncome
        log $ "  taxOnOrdinaryIncome: " <> show r.taxOnOrdinaryIncome
        log $ "  taxOnQualifiedIncome: " <> show r.taxOnQualifiedIncome
        log $ "  result: " <> show (r.taxOnOrdinaryIncome + r.taxOnQualifiedIncome)
