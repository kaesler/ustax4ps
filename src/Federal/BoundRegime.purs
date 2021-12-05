module Federal.BoundRegime
  ( BoundRegime(..)
  , bindRegime
  , netDeduction
  , personalExemptionDeduction
  , standardDeduction
  )
  where

import Prelude

import Age (isAge65OrOlder)
import CommonTypes (BirthDate, FilingStatus(..), Money, isUnmarried)
import Data.Date (Year)
import Data.Int (toNumber)
import Data.Tuple (Tuple(..))
import Federal.OrdinaryIncome (OrdinaryIncomeBrackets)
import Federal.OrdinaryIncome (fromPairs) as FO
import Federal.QualifiedIncome (QualifiedIncomeBrackets)
import Federal.QualifiedIncome (fromPairs) as FQ
import Federal.Regime (Regime(..), invalidRegime)
import Federal.Types (ItemizedDeductions, PersonalExemptions, StandardDeduction(..))
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
    , perPersonExemption :: Money
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
  BirthDate ->
  FilingStatus ->
  Int ->
  Money ->
  Int ->
  Int ->
  Int ->
  OrdinaryIncomeBrackets ->
  QualifiedIncomeBrackets ->
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
     ordinaryIncomeBrackets: ob,
     qualifiedIncomeBrackets: qb
   }

standardDeduction :: BoundRegime -> StandardDeduction
standardDeduction (BoundRegime br) =
  StandardDeduction $
    br.unadjustedStandardDeduction +
       ( if isAge65OrOlder br.birthDate br.year
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
perPersonExemptionFor PreTrump _ = 4050.0
perPersonExemptionFor Trump _ = 0.0

unAdjustedStdDeductionFor :: Regime -> Int -> FilingStatus -> Int
unAdjustedStdDeductionFor Trump 2022 Single = 12950
unAdjustedStdDeductionFor Trump 2022 HeadOfHousehold = 19400
unAdjustedStdDeductionFor Trump 2021 Single = 12550
unAdjustedStdDeductionFor Trump 2021 HeadOfHousehold = 18800
unAdjustedStdDeductionFor Trump 2020 HeadOfHousehold = 18650
unAdjustedStdDeductionFor Trump 2020 Single = 12400
unAdjustedStdDeductionFor Trump 2019 HeadOfHousehold = 18350
unAdjustedStdDeductionFor Trump 2019 Single = 12200
unAdjustedStdDeductionFor Trump 2018 HeadOfHousehold = 18000
unAdjustedStdDeductionFor Trump 2018 Single = 12000
unAdjustedStdDeductionFor PreTrump 2017 Single = 6350
unAdjustedStdDeductionFor PreTrump 2017 HeadOfHousehold = 9350
unAdjustedStdDeductionFor r y _ = invalidRegime r (unsafeMakeYear y)

ageAdjustmentFor :: Regime -> Int -> Int
ageAdjustmentFor Trump 2022 = 1400
ageAdjustmentFor Trump 2021 = 1350
ageAdjustmentFor Trump 2020 = 1300
ageAdjustmentFor Trump 2019 = 1300
ageAdjustmentFor Trump 2018 = 1300

ageAdjustmentFor PreTrump 2017 = 1250
ageAdjustmentFor r y = invalidRegime r (unsafeMakeYear y)

ageAndSingleAdjustmentFor :: Regime -> Int -> Int
ageAndSingleAdjustmentFor Trump 2022 = 350
ageAndSingleAdjustmentFor Trump 2021 = 350
ageAndSingleAdjustmentFor Trump 2020 = 350
ageAndSingleAdjustmentFor Trump 2019 = 350
ageAndSingleAdjustmentFor Trump 2018 = 300
ageAndSingleAdjustmentFor PreTrump 2017 = 300
ageAndSingleAdjustmentFor r y = invalidRegime r (unsafeMakeYear y)


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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14650),
            (Tuple 22.0 55900),
            (Tuple 24.0 89050),
            (Tuple 32.0 170050),
            (Tuple 35.0 215950),
            (Tuple 37.0 539900)
          ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 55800),
            (Tuple 20 488500)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        (FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 10275),
            (Tuple 22.0 41775),
            (Tuple 24.0 89075),
            (Tuple 32.0 170050),
            (Tuple 35.0 215950),
            (Tuple 37.0 539900)
          ])
        (FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 41675),
            (Tuple 20 459750)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 14100),
            (Tuple 22.0 53700),
            (Tuple 24.0 85500),
            (Tuple 32.0 163300),
            (Tuple 35.0 207350),
            (Tuple 37.0 518400)
          ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 53600),
            (Tuple 20 469050)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        (FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9875),
            (Tuple 22.0 40125),
            (Tuple 24.0 85525),
            (Tuple 32.0 163300),
            (Tuple 35.0 207350),
            (Tuple 37.0 518400)
          ])
        (FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 40000),
            (Tuple 20 442450)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 13850),
            (Tuple 22.0 52850),
            (Tuple 24.0 84200),
            (Tuple 32.0 160700),
            (Tuple 35.0 204100),
            (Tuple 37.0 510300)
          ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 52750),
            (Tuple 20 461700)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        (FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9700),
            (Tuple 22.0 39475),
            (Tuple 24.0 84200),
            (Tuple 32.0 160725),
            (Tuple 35.0 204100),
            (Tuple 37.0 510300)
          ])
        (FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 39375),
            (Tuple 20 434550)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        ( FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 13600),
            (Tuple 22.0 51800),
            (Tuple 24.0 82500),
            (Tuple 32.0 157500),
            (Tuple 35.0 200000),
            (Tuple 37.0 500000)
          ]
        )
        ( FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 51700),
            (Tuple 20 452400)
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
        (perPersonExemptionFor regime yearAsInt)
        (unAdjustedStdDeductionFor regime yearAsInt fs)
        (ageAdjustmentFor regime yearAsInt)
        (ageAndSingleAdjustmentFor regime yearAsInt)
        (FO.fromPairs
          [ (Tuple 10.0 0),
            (Tuple 12.0 9525),
            (Tuple 22.0 38700),
            (Tuple 24.0 82500),
            (Tuple 32.0 157500),
            (Tuple 35.0 200000),
            (Tuple 37.0 500000)
          ])
        (FQ.fromPairs
          [ (Tuple 0 0),
            (Tuple 15 38600),
            (Tuple 20 425800)
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
bindRegime r y _ _ _ =
  invalidRegime r (unsafeMakeYear y)
