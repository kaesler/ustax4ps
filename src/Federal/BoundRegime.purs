module Federal.BoundRegime
  ( BoundRegime(..)
  ) where

import Prelude
import Data.Date (Year)
import CommonTypes (FilingStatus, BirthDate, Money)
import Federal.Regime (Regime)
import Federal.OrdinaryIncome (OrdinaryIncomeBrackets, fromPairs) as FO
import Federal.QualifiedIncome (QualifiedIncomeBrackets, fromPairs) as FQ

data BoundRegime
  = BoundRegime
    { regime :: Regime
    , year :: Year
    , filingStatus :: FilingStatus
    , birthDate :: BirthDate
    , personalExemptions :: Int
    , --
      -- The following are inflatable. They may get adjusted to estimate the
      -- the tax regime for a future year, based on estimated inflation.
      perPersonExemption :: Money
    , unadjustedStandardDeduction :: Int
    , adjustmentWhenOver65 :: Int
    , adjustmentWhenOver65AndSingle :: Int
    }
