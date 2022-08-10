module Federal.Calculator
  ( FederalTaxResults(..)
  , TaxCalculator
  , makeCalculator
  , taxDueForFutureYear
  , taxDueForKnownYear
  , taxDueForKnownYearDebug
  , taxResultsForFutureYear
  , taxResultsForFutureYearAsTable
  , taxResultsForKnownYear
  , taxResultsForKnownYearAsTable
  )
  where

import CommonTypes (BirthDate, FilingStatus)
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
type Table = Array (Array String)

makeCalculator :: BoundRegime -> BirthDate -> PersonalExemptions -> TaxCalculator
makeCalculator br birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let BoundRegime brRec = br
      ssRelevantOtherIncome = ordinaryIncome <> qualifiedIncome
      taxableSocSec = TSS.amountTaxable brRec.filingStatus socSec ssRelevantOtherIncome
      netDeds = netDeduction br birthDate personalExemptions itemized
      taxableOrdinaryIncome = (taxableSocSec <> ordinaryIncome) `applyDeductions` netDeds
      taxOnOrdinaryIncome = TFS.taxDueOnOrdinaryIncome brRec.ordinaryBrackets taxableOrdinaryIncome
      taxOnQualifiedIncome =
        TFS.taxDueOnQualifiedIncome brRec.qualifiedBrackets taxableOrdinaryIncome (asTaxable qualifiedIncome)
   in FederalTaxResults
        { boundRegime: br,
          ssRelevantOtherIncome: ssRelevantOtherIncome,
          taxableSocSec: taxableSocSec,
          finalStandardDeduction: standardDeduction br birthDate,
          finalPersonalExemptionDeduction: personalExemptionDeduction br personalExemptions,
          finalNetDeduction: netDeds,
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
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  FederalTaxResults
taxResultsForKnownYear year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let boundRegime = boundRegimeForKnownYear year filingStatus
      calculator = makeCalculator boundRegime birthDate personalExemptions
   in calculator socSec ordinaryIncome qualifiedIncome itemized

taxResultsForKnownYearAsTable :: 
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Table  
taxResultsForKnownYearAsTable year filingStatus birthDate  personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  resultsAsTable $ taxResultsForKnownYear year filingStatus birthDate  personalExemptions socSec ordinaryIncome qualifiedIncome itemized

taxDueForKnownYear ::
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  TaxPayable
taxDueForKnownYear year filingStatus birthDate  personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults results = taxResultsForKnownYear year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized
   in results.taxOnOrdinaryIncome <> results.taxOnQualifiedIncome 

taxDueForKnownYearDebug ::
  Year ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Effect Unit
taxDueForKnownYearDebug year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults r = taxResultsForKnownYear year filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized
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

taxResultsForFutureYearAsTable ::
  Regime ->
  Year -> 
  Number ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  Table
taxResultsForFutureYearAsTable reg futureYear estimate filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  resultsAsTable $ taxResultsForFutureYear reg futureYear estimate filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized

taxResultsForFutureYear ::
  Regime ->
  Year -> 
  Number ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  FederalTaxResults
taxResultsForFutureYear reg futureYear estimate filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let boundRegime = boundRegimeForFutureYear 
                      reg 
                      futureYear 
                      estimate 
                      filingStatus 
      calculator = makeCalculator boundRegime birthDate personalExemptions
   in calculator socSec ordinaryIncome qualifiedIncome itemized  


taxDueForFutureYear ::
  Regime ->
  Year ->
  Number ->
  FilingStatus ->
  BirthDate ->
  PersonalExemptions ->
  SocSec ->
  OrdinaryIncome ->
  QualifiedIncome ->
  ItemizedDeductions ->
  TaxPayable
taxDueForFutureYear regime futureYear inflationEstimate filingStatus birthDate personalExemptions socSec ordinaryIncome qualifiedIncome itemized =
  let FederalTaxResults results = taxResultsForFutureYear 
                                    regime 
                                    futureYear 
                                    inflationEstimate 
                                    filingStatus 
                                    birthDate 
                                    personalExemptions 
                                    socSec 
                                    ordinaryIncome 
                                    qualifiedIncome 
                                    itemized
   in results.taxOnOrdinaryIncome <> results.taxOnQualifiedIncome

resultsAsTable :: FederalTaxResults -> Array (Array String)
resultsAsTable (FederalTaxResults r) = 
  [
    ["ssRelevantOtherIncome: ", show r.ssRelevantOtherIncome],
    ["taxableSocSec: ", show r.taxableSocSec],
    ["finalStandardDeduction: ", show r.finalStandardDeduction],
    ["finalNetDeduction: ", show r.finalNetDeduction],
    ["taxableOrdinaryIncome: ", show r.taxableOrdinaryIncome],
    ["taxOnOrdinaryIncome: ", show r.taxOnOrdinaryIncome],
    ["taxOnQualifiedIncome: ", show r.taxOnQualifiedIncome],
    ["totalTaxDue: ", show (r.taxOnOrdinaryIncome <> r.taxOnQualifiedIncome)]
  ]