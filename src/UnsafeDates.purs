module UnsafeDates
  ( unsafeMakeDate
  , unsafeMakeDay
  , unsafeMakeMonth
  , unsafeMakeYear
  ) where

import Prelude
import Data.Date (Date, Day, Month, Year, canonicalDate)
import Data.Enum (toEnum)
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)

unsafeMakeYear :: Int -> Year
unsafeMakeYear i = unsafePartial $ fromJust $ toEnum i

unsafeMakeMonth :: Int -> Month
unsafeMakeMonth i = unsafePartial $ fromJust $ toEnum i

unsafeMakeDay :: Int -> Day
unsafeMakeDay i = unsafePartial $ fromJust $ toEnum i

unsafeMakeDate :: Int -> Int -> Int -> Date
unsafeMakeDate y m d = canonicalDate (unsafeMakeYear y) (unsafeMakeMonth m) (unsafeMakeDay d)
