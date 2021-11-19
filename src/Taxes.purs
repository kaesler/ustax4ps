module Taxes
  ( FederalTaxResults(..)
  , federalTaxDue
  , federalTaxDueDebug
  , federalTaxResults
  , maStateTaxDue
  , maStateTaxRate
  , ordinaryIncomeBrackets
  ) where

import Prelude

import CommonTypes (FilingStatus(..), MassachusettsGrossIncome, OrdinaryIncome, QualifiedIncome, SocSec)
import Data.Date (Year)
import Data.Int (toNumber)
import Data.Map as Map
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Federal.OrdinaryIncome (OrdinaryIncomeBrackets, applyOrdinaryIncomeBrackets, fromPairs, ordinaryRate)
import Federal.QualifiedIncome (applyQualifiedIncomeBrackets)
import Federal.TaxableSocialSecurity (taxableSocialSecurity)
import Federal.Types (BracketStart(..), StandardDeduction(..), standardDeduction)
import TaxMath (nonNeg)

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

    taxOnOrdinaryIncome = applyOrdinaryIncomeBrackets (ordinaryIncomeBrackets filingStatus) taxableOrdinaryIncome

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

-- TODO: will go elsewhere
ordinaryIncomeBrackets :: FilingStatus -> OrdinaryIncomeBrackets
ordinaryIncomeBrackets Single =
  fromPairs
    [ Tuple 10.0 0
    , Tuple 12.0 9950
    , Tuple 22.0 40525
    , Tuple 24.0 86375
    , Tuple 32.0 164925
    , Tuple 35.0 209425
    , Tuple 37.0 523600
    ]

-- TODO: will go
ordinaryIncomeBrackets HeadOfHousehold =
  fromPairs
    [ Tuple 10.0 0
    , Tuple 12.0 14200
    , Tuple 22.0 54200
    , Tuple 24.0 86350
    , Tuple 32.0 164900
    , Tuple 35.0 209400
    , Tuple 37.0 523600
    ]

