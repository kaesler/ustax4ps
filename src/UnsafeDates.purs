module UnsafeDates
  ( makeDateFromGoogleSheetRep
  , unsafeMakeDate
  , unsafeMakeDay
  , unsafeMakeMonth
  , unsafeMakeYear
  )
  where

import Prelude

import Data.Date (Date, Day, Month, Year, adjust, canonicalDate)
import Data.Enum (toEnum)
import Data.Maybe (Maybe, fromJust)
import Data.Time.Duration (Days (..))
import Partial.Unsafe (unsafePartial)

unsafeMakeYear :: Int -> Year
unsafeMakeYear i = unsafePartial $ fromJust $ toEnum i

unsafeMakeMonth :: Int -> Month
unsafeMakeMonth i = unsafePartial $ fromJust $ toEnum i

unsafeMakeDay :: Int -> Day
unsafeMakeDay i = unsafePartial $ fromJust $ toEnum i

unsafeMakeDate :: Int -> Int -> Int -> Date
unsafeMakeDate y m d = canonicalDate (unsafeMakeYear y) (unsafeMakeMonth m) (unsafeMakeDay d)

-- TODO: make a test
-- See https://www.ablebits.com/office-addins-blog/google-sheets-change-date-format/
makeDateFromGoogleSheetRep :: Number -> Maybe Date
makeDateFromGoogleSheetRep daysOffSet = 
  do baseYear <- toEnum 1899
     baseMonth <- toEnum 12
     baseDayOfMonth <- toEnum 30
     googleBaseDate <- pure $ canonicalDate baseYear baseMonth baseDayOfMonth
     adjust (Days daysOffSet) googleBaseDate

