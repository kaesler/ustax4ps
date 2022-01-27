module Federal.BoundRegime
  ( BoundRegime(..)
  , bindRegime
  , netDeduction
  , personalExemptionDeduction
  , standardDeduction
  ) where

import Age (isAge65OrOlder)
import CommonTypes (BirthDate, FilingStatus(..), isUnmarried)
import Data.Date (Year)
import Data.Enum (fromEnum)
import Data.Tuple (Tuple(..))
import Federal.OrdinaryBrackets (OrdinaryBrackets, fromPairs) as OB
import Federal.QualifiedBrackets (QualifiedBrackets, fromPairs) as QB
import Federal.Regime (Regime(..), invalidRegime)
import Federal.Types (ItemizedDeductions, PersonalExemptions, StandardDeduction)
import Moneys (Deduction, makeFromInt, noMoney, times)
import Prelude
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

-- Note: does't seem to get adjusted for inflation.
perPersonExemptionFor :: Regime -> Year -> Deduction
perPersonExemptionFor PreTrump _ = makeFromInt 4050
perPersonExemptionFor Trump _ = noMoney

unAdjustedStdDeductionFor :: Regime -> Year -> FilingStatus -> Deduction
unAdjustedStdDeductionFor regime year fs = 
  (case T3 regime (fromEnum year) fs of 
     T3 Trump 2022 Single -> 12950
     T3 Trump 2022 Single -> 12950
     T3 Trump 2022 HeadOfHousehold -> 19400
     T3 Trump 2021 Single -> 12550
     T3 Trump 2021 HeadOfHousehold -> 18800
     T3 Trump 2020 HeadOfHousehold -> 18650
     T3 Trump 2020 Single -> 12400
     T3 Trump 2019 HeadOfHousehold -> 18350
     T3 Trump 2019 Single -> 12200
     T3 Trump 2018 HeadOfHousehold -> 18000
     T3 Trump 2018 Single -> 12000
     T3 PreTrump 2017 Single -> 6350
     T3 PreTrump 2017 HeadOfHousehold -> 9350
     T3 r yy _ -> invalidRegime r (unsafeMakeYear yy)
  ) # makeFromInt

ageAdjustmentFor :: Regime -> Year -> Deduction
ageAdjustmentFor regime year = 
  (case T2 regime (fromEnum year) of 
    T2 Trump 2022 -> 1400
    T2 Trump 2021 -> 1350
    T2 Trump 2020 -> 1300
    T2 Trump 2019 -> 1300
    T2 Trump 2018 -> 1300
    T2 PreTrump 2017 -> 1250
    T2 r y -> invalidRegime r (unsafeMakeYear y)
  ) # makeFromInt

ageAndSingleAdjustmentFor :: Regime -> Year -> Deduction
ageAndSingleAdjustmentFor regime year =
  (case T2 regime (fromEnum year) of 
    T2 Trump 2022 -> 350
    T2 Trump 2021 -> 350
    T2 Trump 2020 -> 350
    T2 Trump 2019 -> 350
    T2 Trump 2018 -> 300
    T2 PreTrump 2017 -> 300
    T2 r y -> invalidRegime r (unsafeMakeYear y)
  ) # makeFromInt

bindRegime :: Regime -> Int -> BirthDate -> FilingStatus -> PersonalExemptions -> BoundRegime
bindRegime Trump 2022 bd HeadOfHousehold pes =
  let regime = Trump
      yearAsInt = 2022
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        Trump
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14650),
            (Tuple 22.0 55900),
            (Tuple 24.0 89050),
            (Tuple 32.0 170050),
            (Tuple 35.0 215950),
            (Tuple 37.0 539900)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 55800),
            (Tuple 20.0 488500)
          ]
        )
bindRegime Trump 2022 bd Single pes =
  let regime = Trump
      yearAsInt = 2022
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        (OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 10275),
            (Tuple 22.0 41775),
            (Tuple 24.0 89075),
            (Tuple 32.0 170050),
            (Tuple 35.0 215950),
            (Tuple 37.0 539900)
          ])
        (QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 41675),
            (Tuple 20.0 459750)
          ])

bindRegime Trump 2021 bd HeadOfHousehold pes =
  let regime = Trump
      yearAsInt = 2021
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        Trump
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14200),
            (Tuple 22.0 54200),
            (Tuple 24.0 86350),
            (Tuple 32.0 164900),
            (Tuple 35.0 209400),
            (Tuple 37.0 523600)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 54100),
            (Tuple 20.0 473850)
          ]
        )

bindRegime Trump 2021 bd Single pes =
  let regime = Trump
      yearAsInt = 2021
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        (OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9950),
            (Tuple 22.0 40525),
            (Tuple 24.0 86375),
            (Tuple 32.0 164925),
            (Tuple 35.0 209425),
            (Tuple 37.0 523600)
          ])
        (QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 40400),
            (Tuple 20.0 445850)
          ])

bindRegime Trump 2020 bd HeadOfHousehold pes =
  let regime = Trump
      yearAsInt = 2020
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        Trump
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14100),
            (Tuple 22.0 53700),
            (Tuple 24.0 85500),
            (Tuple 32.0 163300),
            (Tuple 35.0 207350),
            (Tuple 37.0 518400)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 53600),
            (Tuple 20.0 469050)
          ]
        )

bindRegime Trump 2020 bd Single pes =
  let regime = Trump
      yearAsInt = 2020
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        (OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9875),
            (Tuple 22.0 40125),
            (Tuple 24.0 85525),
            (Tuple 32.0 163300),
            (Tuple 35.0 207350),
            (Tuple 37.0 518400)
          ])
        (QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 40000),
            (Tuple 20.0 442450)
          ])

bindRegime Trump 2019 bd HeadOfHousehold pes =
  let regime = Trump
      yearAsInt = 2019
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        Trump
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 13850),
            (Tuple 22.0 52850),
            (Tuple 24.0 84200),
            (Tuple 32.0 160700),
            (Tuple 35.0 204100),
            (Tuple 37.0 510300)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 52750),
            (Tuple 20.0 461700)
          ]
        )

bindRegime Trump 2019 bd Single pes =
  let regime = Trump
      yearAsInt = 2019
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        (OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9700),
            (Tuple 22.0 39475),
            (Tuple 24.0 84200),
            (Tuple 32.0 160725),
            (Tuple 35.0 204100),
            (Tuple 37.0 510300)
          ])
        (QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 39375),
            (Tuple 20.0 434550)
          ])

bindRegime Trump 2018 bd HeadOfHousehold pes =
  let regime = Trump
      yearAsInt = 2018
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        Trump
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 13600),
            (Tuple 22.0 51800),
            (Tuple 24.0 82500),
            (Tuple 32.0 157500),
            (Tuple 35.0 200000),
            (Tuple 37.0 500000)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 51700),
            (Tuple 20.0 452400)
          ]
        )

bindRegime Trump 2018 bd Single pes =
  let regime = Trump
      yearAsInt = 2018
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        (OB.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9525),
            (Tuple 22.0 38700),
            (Tuple 24.0 82500),
            (Tuple 32.0 157500),
            (Tuple 35.0 200000),
            (Tuple 37.0 500000)
          ])
        (QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 38600),
            (Tuple 20.0 425800)
          ])

bindRegime PreTrump 2017 bd HeadOfHousehold pes =
  let regime = PreTrump
      yearAsInt = 2017
      year = unsafeMakeYear yearAsInt
      fs = HeadOfHousehold
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
           [ (Tuple 10.0 0),
              (Tuple 15.0 13350),
              (Tuple 25.0 50800),
              (Tuple 28.0 131200),
              (Tuple 33.0 212500),
              (Tuple 35.0 416700),
               (Tuple 39.6 444550)
           ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 50800),
            (Tuple 20.0 444550)
          ]
      )
bindRegime PreTrump 2017 bd Single pes =
  let regime = PreTrump
      yearAsInt = 2017
      year = unsafeMakeYear yearAsInt
      fs = Single
   in mkBoundRegime
        regime
        year
        bd
        fs
        pes
        (perPersonExemptionFor regime year)
        (unAdjustedStdDeductionFor regime year fs)
        (ageAdjustmentFor regime year)
        (ageAndSingleAdjustmentFor regime year)
        ( OB.fromPairs
          [ (Tuple 10.0 0),
              (Tuple 15.0 9235),
              (Tuple 25.0 37950),
              (Tuple 28.0 91900),
              (Tuple 33.0 191650),
              (Tuple 35.0 416700),
              (Tuple 39.6 418400)
          ]
        )
        ( QB.fromPairs
          [ (Tuple 0.0 0),
            (Tuple 15.0 37950),
            (Tuple 20.0 418400)
          ]
        )
bindRegime r y _ _ _ =
  invalidRegime r (unsafeMakeYear y)

data T2 x y = T2 x y
data T3 x y z = T3 x y z
