module Federal.BoundRegime
  ( BoundRegime(..),
    bindRegime,
    netDeduction,
    personalExemptionDeduction,
    standardDeduction
  ) where

import Prelude

import CommonTypes (BirthDate, FilingStatus(..), Money, isUnmarried)
import Data.Date (Year)
import Data.Date as Date
import Data.Enum (fromEnum)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..))
import Federal.OrdinaryIncome (OrdinaryIncomeBrackets)
import Federal.OrdinaryIncome (fromPairs) as FO
import Federal.QualifiedIncome (QualifiedIncomeBrackets)
import Federal.QualifiedIncome (fromPairs) as FQ
import Federal.Regime (Regime(..), invalidRegime, unsafeMakeYear)
import Federal.Types (ItemizedDeductions, PersonalExemptions, StandardDeduction(..))

newtype BoundRegime
  = BoundRegime
    { regime :: Regime
    , year :: Year
    , filingStatus :: FilingStatus
    , birthDate :: BirthDate
    , personalExemptions :: Int
      --
      -- The following are inflatable. They may get adjusted to estimate the
      -- the tax regime for a future year, based on estimated inflation.
    ,  perPersonExemption :: Money
    , unadjustedStandardDeduction :: Int
    , adjustmentWhenOver65 :: Int
    , adjustmentWhenOver65AndSingle :: Int
    , ordinaryIncomeBrackets :: OrdinaryIncomeBrackets
    , qualifiedIncomeBrackets :: QualifiedIncomeBrackets
    }
instance Show BoundRegime where
  show (BoundRegime r) = (show r)

mkBoundRegime ::
  Regime ->
  Year ->
  FilingStatus ->
  BirthDate ->
  Int ->
  Money ->
  Int ->
  Int ->
  Int ->
  OrdinaryIncomeBrackets ->
  QualifiedIncomeBrackets ->
  BoundRegime
 
mkBoundRegime r y fs bd pes ppe uasd a65 a65s ob qb = 
   BoundRegime {
     regime: r,
     year: y,
     filingStatus: fs,
     birthDate: bd,
     personalExemptions: pes,
     perPersonExemption: ppe,
     unadjustedStandardDeduction: uasd,
     adjustmentWhenOver65: a65,
     adjustmentWhenOver65AndSingle: a65s,
     ordinaryIncomeBrackets: ob,
     qualifiedIncomeBrackets: qb
   }

standardDeduction :: BoundRegime -> StandardDeduction
standardDeduction (BoundRegime br) =
  StandardDeduction $
    br.unadjustedStandardDeduction +
       ( if ageAtYearEnd br.year br.birthDate > 65
            then
              br.adjustmentWhenOver65
                + ( if isUnmarried br.filingStatus
                      then br.adjustmentWhenOver65AndSingle
                      else 0
                  )
            else 0
        )
personalExemptionDeduction :: BoundRegime -> Money
personalExemptionDeduction (BoundRegime br) =
  br.perPersonExemption * toNumber br.personalExemptions

netDeduction :: BoundRegime -> ItemizedDeductions -> Money
netDeduction br itemized =
  let StandardDeduction stdDed = standardDeduction br
   in personalExemptionDeduction br + max itemized (toNumber stdDed)

-- Note: does't seem to get adjusted for inflation.
perPersonExemptionFor :: Regime -> Int -> Money
perPersonExemptionFor NonTrump _ = 4050.0
perPersonExemptionFor Trump _ = 0.0

year2017 :: Year
year2017 = unsafeMakeYear 2017
year2021 :: Year
year2021 = unsafeMakeYear 2017

unAdjustedStdDeductionFor :: Regime -> Int -> FilingStatus -> Int
unAdjustedStdDeductionFor NonTrump 2017 Single = 6350
unAdjustedStdDeductionFor NonTrump 2017 HeadOfHousehold = 9350
unAdjustedStdDeductionFor Trump 2021 Single = 12550
unAdjustedStdDeductionFor Trump 2021 HeadOfHousehold = 18800
unAdjustedStdDeductionFor r y _ = invalidRegime r (unsafeMakeYear y)

ageAdjustmentFor :: Regime -> Int -> Int
ageAdjustmentFor Trump 2021 = 1350
ageAdjustmentFor NonTrump 2017 = 1250
ageAdjustmentFor r y = invalidRegime r (unsafeMakeYear y)

ageAndSingleAdjustmentFor :: Regime -> Int -> Int
ageAndSingleAdjustmentFor Trump 2021 = 350
ageAndSingleAdjustmentFor NonTrump 2017 = 300
ageAndSingleAdjustmentFor r y = invalidRegime r (unsafeMakeYear y)

ageAtYearEnd :: Year -> BirthDate -> Int
ageAtYearEnd year birthDate =
  fromEnum year - fromEnum (Date.year birthDate)

bindRegime :: Regime -> Int -> FilingStatus -> BirthDate -> PersonalExemptions -> BoundRegime
bindRegime Trump 2021 Single bd pes =
  let regime = Trump
      yearAsInt = 2021
      year = unsafeMakeYear yearAsInt
      fs = Single
    in
      mkBoundRegime
        regime
        year
        fs
        bd
        pes
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        (FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9950),
            (Tuple 22.0 40525),
            (Tuple 24.0 86375),
            (Tuple 32.0 164925),
            (Tuple 35.0 209425),
            (Tuple 37.0 523600)
          ])
        (FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 40400),
            (Tuple 20 445850)
          ])

bindRegime Trump 2021 HeadOfHousehold bd pes =
  let regime = Trump
      yearAsInt = 2021
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
    in      
      mkBoundRegime
        Trump
        year
        fs
        bd
        pes
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14200),
            (Tuple 22.0 54200),
            (Tuple 24.0 86350),
            (Tuple 32.0 164900),
            (Tuple 35.0 209400),
            (Tuple 37.0 523600)
          ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 54100),
            (Tuple 20 473850)
          ]
        )
bindRegime NonTrump 2017 Single bd pes =
  let regime = NonTrump
      yearAsInt = 2017
      year = unsafeMakeYear yearAsInt
      fs = Single
    in      
      mkBoundRegime
      regime
      year
      fs
      bd
      pes
      (perPersonExemptionFor regime yearAsInt)
      (unAdjustedStdDeductionFor regime yearAsInt fs)
      (ageAdjustmentFor regime yearAsInt)
      (ageAndSingleAdjustmentFor regime yearAsInt)
      ( FO.fromPairs
        [ (Tuple 10.0 0),
            (Tuple 15.0 9235),
            (Tuple 25.0 37950),
            (Tuple 28.0 91900),
            (Tuple 33.0 191650),
            (Tuple 35.0 416700),
            (Tuple 39.6 418400)
        ]
      )
      ( FQ.fromPairs
        [ (Tuple 0 0),
          (Tuple 15 37950),
          (Tuple 20 418400)
        ]
      )
bindRegime NonTrump 2017 HeadOfHousehold bd pes =
  let regime = NonTrump
      yearAsInt = 2017
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
    in      
      mkBoundRegime
        regime
        year
        fs
        bd
        pes
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
           [ (Tuple 10.0 0),
              (Tuple 15.0 13350),
              (Tuple 25.0 50800),
              (Tuple 28.0 131200),
              (Tuple 33.0 212500),
              (Tuple 35.0 416700),
               (Tuple 39.6 444550)
           ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 50800),
            (Tuple 20 444550)
          ]
      )
bindRegime r y _ _ _ =
  invalidRegime r (unsafeMakeYear y)
