module Federal.BoundRegime
  ( BoundRegime(..)
  , boundRegimeForFutureYear
  , boundRegimeForKnownYear
  , netDeduction
  , personalExemptionDeduction
  , standardDeduction
  )
  where

import Federal.Yearly.Type

import Age (isAge65OrOlder)
import CommonTypes (BirthDate, FilingStatus, isUnmarried)
import Data.Date (Year)
import Data.Enum (fromEnum)
import Data.List ((..), foldl)
import Data.Maybe (fromMaybe)
import Federal.OrdinaryBrackets (OrdinaryBrackets, inflateThresholds) as OB
import Federal.QualifiedBrackets (QualifiedBrackets, inflateThresholds) as QB
import Federal.Regime (Regime)
import Federal.Types (ItemizedDeductions, PersonalExemptions, StandardDeduction)
import Federal.Yearly.YearlyValues as YV
import Moneys (Deduction, noMoney, times, mul)
import Prelude (class Show, bind, max, pure, ($), (*), (+), (<>))
import UnsafeDates (unsafeMakeYear)

newtype BoundRegime
  = BoundRegime
    { regime :: Regime
    , year :: Year
    , birthDate :: BirthDate
    , filingStatus :: FilingStatus
    , personalExemptions :: Int
      --
      -- The following are inflatable. They may get adjusted to estimate the
      -- the tax regime for a future year, based on estimated inflation.
    , perPersonExemption :: Deduction
    , unadjustedStandardDeduction :: Deduction
    , adjustmentWhenOver65 :: Deduction
    , adjustmentWhenOver65AndSingle :: Deduction
    , ordinaryBrackets :: OB.OrdinaryBrackets
    , qualifiedBrackets :: QB.QualifiedBrackets
    }
derive newtype instance Show BoundRegime

mkBoundRegime ::
  Regime ->
  Year ->
  BirthDate ->
  FilingStatus ->
  Int ->
  Deduction ->
  Deduction ->
  Deduction ->
  Deduction ->
  OB.OrdinaryBrackets ->
  QB.QualifiedBrackets ->
  BoundRegime
 
mkBoundRegime r y bd fs pes ppe uasd a65 a65s ob qb = 
   BoundRegime {
     regime: r,
     year: y,
     birthDate: bd,
     filingStatus: fs,
     personalExemptions: pes,
     perPersonExemption: ppe,
     unadjustedStandardDeduction: uasd,
     adjustmentWhenOver65: a65,
     adjustmentWhenOver65AndSingle: a65s,
     ordinaryBrackets: ob,
     qualifiedBrackets: qb
   }

standardDeduction :: BoundRegime -> StandardDeduction
standardDeduction (BoundRegime br) =
  br.unadjustedStandardDeduction <>
     ( if isAge65OrOlder br.birthDate br.year
          then
            br.adjustmentWhenOver65
              <> ( if isUnmarried br.filingStatus
                    then br.adjustmentWhenOver65AndSingle
                    else noMoney
                )
          else noMoney
      )
personalExemptionDeduction :: BoundRegime -> Deduction
personalExemptionDeduction (BoundRegime br) =
  br.personalExemptions `times` br.perPersonExemption

netDeduction :: BoundRegime -> ItemizedDeductions -> Deduction
netDeduction br itemized =
  personalExemptionDeduction br <> max itemized (standardDeduction br)

boundRegimeForKnownYear :: Year -> BirthDate -> FilingStatus -> PersonalExemptions -> BoundRegime
boundRegimeForKnownYear y bd fs pe =
  let yvs = YV.unsafeValuesForYear y
   in BoundRegime {
     regime: yvs.regime,
     year: y,
     birthDate: bd,
     filingStatus: fs,
     personalExemptions: pe,
     perPersonExemption: yvs.perPersonExemption,
     unadjustedStandardDeduction: yvs.unadjustedStandardDeduction fs,
     adjustmentWhenOver65: yvs.adjustmentWhenOver65,
     adjustmentWhenOver65AndSingle: yvs.adjustmentWhenOver65AndSingle,
     ordinaryBrackets: yvs.ordinaryBrackets fs,
     qualifiedBrackets: yvs.qualifiedBrackets fs
   }

boundRegimeForFutureYear :: Regime -> Year -> Number -> BirthDate -> FilingStatus -> PersonalExemptions -> BoundRegime
boundRegimeForFutureYear r y annualInflationFactor bd fs pe =
  let baseValues = YV.mostRecentForRegime r :: YearlyValues
      baseYear = fromEnum baseValues.year
      yearsWithInflation = (baseYear + 1) .. fromEnum y
      baseRegime = boundRegimeForKnownYear baseValues.year bd fs pe 
      inflationFactors = 
        do ywi <- yearsWithInflation
           let factor = fromMaybe annualInflationFactor $ YV.averageThresholdChangeOverPrevious $ unsafeMakeYear ywi
           pure factor
      netInflationFactor = foldl  (\a b -> a * b) 1.0 inflationFactors
  in 
    withEstimatedNetInflationFactor y netInflationFactor baseRegime      

withEstimatedNetInflationFactor :: Year -> Number -> BoundRegime -> BoundRegime
withEstimatedNetInflationFactor futureYear netInflationFactor (BoundRegime br) =
  mkBoundRegime
    br.regime
    futureYear
    br.birthDate
    br.filingStatus
    br.personalExemptions
    (br.perPersonExemption `mul` netInflationFactor)
    (br.unadjustedStandardDeduction `mul` netInflationFactor)
    (br.adjustmentWhenOver65 `mul` netInflationFactor)
    (br.adjustmentWhenOver65AndSingle `mul` netInflationFactor)
    (OB.inflateThresholds netInflationFactor br.ordinaryBrackets)
    (QB.inflateThresholds netInflationFactor br.qualifiedBrackets)
