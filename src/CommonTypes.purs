module CommonTypes(
  Age(..),
  BirthDate(..),
  CombinedIncome,
  DistributionPeriod,
  FilingStatus(..),
  MassachusettsGrossIncome,
  Money,
  OrdinaryIncome,
  QualifiedIncome,
  SSRelevantOtherIncome,
  SocSec,
  isUnmarried,
  unsafeReadFilingStatus
)
where

import Prelude
import Data.Date(Date)
import Data.String.Read (class Read, read)
import Data.Maybe (Maybe(..), fromJust)
import Partial.Unsafe (unsafePartial)

type BirthDate = Date
type Money = Number
type CombinedIncome = Money
type DistributionPeriod = Money
type MassachusettsGrossIncome = Money
type OrdinaryIncome = Money
type QualifiedIncome = Money
type SSRelevantOtherIncome = Money
type SocSec = Money

newtype Age = Age Int
derive instance Eq Age
derive instance Ord Age
derive newtype instance Show Age

data FilingStatus = HeadOfHousehold | Single
derive instance Eq FilingStatus
derive instance Ord FilingStatus
instance Show FilingStatus where
  show HeadOfHousehold = "HeadOfHousehold"
  show Single = "Single"
instance Read FilingStatus where
  read s = 
    case s of 
      "HOH" -> Just HeadOfHousehold
      "HeadOfHousehold" -> Just HeadOfHousehold
      "Single" -> Just Single
      _ -> Nothing

unsafeReadFilingStatus :: String -> FilingStatus
unsafeReadFilingStatus s = unsafePartial $ fromJust (read s) :: FilingStatus

isUnmarried :: FilingStatus -> Boolean
isUnmarried _ = true
