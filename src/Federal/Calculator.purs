module Federal.Calculator
  ( FederalTaxResults(..)
  , TaxCalculator
  , makeCalculator
  , taxDueForFutureYear
  , taxDueForKnownYear
  , taxDueForKnownYearDebug
  , taxResultsForFutureYear
  , taxResultsForKnownYear
  )
  where

import CommonTypes (BirthDate, FilingStatus, InflationEstimate)
import Data.Date (Year)
import Effect (Effect)
import Effect.Console (log)
import Federal.BoundRegime (BoundRegime(..), boundRegimeForFutureYear, boundRegimeForKnownYear, netDeduction, personalExemptionDeduction, standardDeduction)
import Federal.Regime (Regime)
import Federal.TaxFunctions as TFS
import Federal.TaxableSocialSecurity as TSS
import Federal.Types (OrdinaryIncome, QualifiedIncome, SocSec, ItemizedDeductions, PersonalExemptions)
import Moneys (Deduction, Income, TaxPayable, TaxableIncome, applyDeductions, asTaxable)
import Prelude (class Show, Unit, discard, show, ($), (<>))

type TaxCalculator = SocSec -> OrdinaryIncome -> QualifiedIncome -> ItemizedDeductions -> FederalTaxResults

makeCalculator :: BoundRegime -> TaxCalculator
makeCalculator br socSec ordinaryIncome qualifiedIncome itemized =
  let BoundRegime brRec = br
      ssRelevantOtherIncome = ordinaryIncome <> qualifiedIncome
      taxableSocSec = TSS.amountTaxable brRec.filingStatus socSec ssRelevantOtherIncome
      taxableOrdinaryIncome = (taxableSocSec <> ordinaryIncome) `applyDeductions` netDeduction br itemized
      taxOnOrdinaryIncome = TFS.taxDueOnOrdinaryIncome brRec.ordinaryBrackets taxableOrdinaryIncome
      taxOnQualifiedIncome =
        TFS.taxDueOnQualifiedIncome brRec.qualifiedBrackets taxableOrdinaryIncome (asTaxable qualifiedIncome)
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
    ssRelevantOtherIncome :: Income,
    taxableSocSec :: Income,
    finalStandardDeduction :: Deduction,
    finalPersonalExemptionDeduction :: Deduction,
    finalNetDeduction :: Deduction,
    taxableOrdinaryIncome :: TaxableIncome,
    taxOnOrdinaryIncome :: TaxPayable,
    taxOnQualifiedIncome :: TaxPayable
  }
derive newtype instance Show FederalTaxResults 

taxResultsForKnownYear ::
  Year ->
  BirthDate ->
  FilingStatus ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  FederalTaxResults
taxResultsForKnownYear year birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let boundRegime = boundRegimeForKnownYear year birthDate filingStatus personalExemptions
      calculator = makeCalculator boundRegime
   in calculator socSec ordinaryIncome qualifiedIncome itemized
taxDueForKnownYear ::
  Year ->
  BirthDate ->
  FilingStatus ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  TaxPayable
taxDueForKnownYear year birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults results = taxResultsForKnownYear year birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized
   in results.taxOnOrdinaryIncome <> results.taxOnQualifiedIncome 

taxDueForKnownYearDebug ::
  Year ->
  BirthDate ->
  FilingStatus ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Effect Unit
taxDueForKnownYearDebug year birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults r = taxResultsForKnownYear year birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized
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
        log $ "  result: " <> show (r.taxOnOrdinaryIncome <> r.taxOnQualifiedIncome)

taxResultsForFutureYear ::
  Regime ->
  InflationEstimate ->
  BirthDate ->
  FilingStatus ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  FederalTaxResults
taxResultsForFutureYear reg estimate birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let boundRegime = boundRegimeForFutureYear reg estimate birthDate filingStatus personalExemptions
      calculator = makeCalculator boundRegime
   in calculator socSec ordinaryIncome qualifiedIncome itemized

taxDueForFutureYear ::
  Regime ->
  InflationEstimate ->
  BirthDate ->
  FilingStatus ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  TaxPayable
taxDueForFutureYear regime inflationEstimate birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults results = taxResultsForFutureYear regime inflationEstimate birthDate filingStatus personalExemptions socSec ordinaryIncome qualifiedIncome itemized
   in results.taxOnOrdinaryIncome <> results.taxOnQualifiedIncome 
