module CommonTypes
  ( Age(..)
  , AnnualGrowthRatePercentage
  , BirthDate(..)
  , FilingStatus(..)
  , isUnmarried
  , unsafeReadFilingStatus
  )
  where

import Prelude

import Data.Date (Date)
import Data.Maybe (Maybe(..), fromJust)
import Data.String.Read (class Read, read)
import Partial.Unsafe (unsafePartial)

type BirthDate = Date

newtype Age = Age Int
derive instance Eq Age
derive instance Ord Age
derive newtype instance Show Age

data FilingStatus = MarriedJoint | HeadOfHousehold | Single
derive instance Eq FilingStatus
derive instance Ord FilingStatus
instance Show FilingStatus where
  show MarriedJoint = "MarriedJoint"
  show HeadOfHousehold = "HeadOfHousehold"
  show Single = "Single"
instance Read FilingStatus where
  read s = 
    case s of 
      "MarriedJoint" -> Just MarriedJoint
      "HOH" -> Just HeadOfHousehold
      "HeadOfHousehold" -> Just HeadOfHousehold
      "Single" -> Just Single
      _ -> Nothing

unsafeReadFilingStatus :: String -> FilingStatus
unsafeReadFilingStatus s = unsafePartial $ fromJust (read s) :: FilingStatus

isUnmarried :: FilingStatus -> Boolean
isUnmarried MarriedJoint = false
isUnmarried _ = true

type AnnualGrowthRatePercentage = Number
