module CommonTypes(
  Age(..),
  BirthDate(..),
  CombinedIncome,
  DistributionPeriod,
  FilingStatus(..),
  MassachusettsGrossIncome,
  OrdinaryIncome,
  QualifiedIncome,
  SSRelevantOtherIncome,
  SocSec,
  unsafeReadFilingStatus
)
where

import Prelude
import Data.Date(Date)
import Data.String.Read (class Read, read)
import Data.Maybe (Maybe(..), fromJust)
import Partial.Unsafe (unsafePartial)

type BirthDate = Date
type CombinedIncome = Number
type DistributionPeriod = Number
type MassachusettsGrossIncome = Number
type OrdinaryIncome = Number
type QualifiedIncome = Number
type SSRelevantOtherIncome = Number
type SocSec = Number

newtype Age = Age Int
derive instance Eq Age
derive instance Ord Age
instance showAge :: Show Age where
  show (Age i) = show i

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

