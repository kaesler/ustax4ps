module Age
  ( isAge65OrOlder
  ) where

import Prelude
import CommonTypes (BirthDate)
import Data.Date (Date, Year, canonicalDate)
import Data.Enum (fromEnum, toEnum)
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)

-- You're considered by the IRS to be 65 on the day before your 
-- 65th birthday. Therefore, you are considered age 65 at the 
-- end of the year if your 65th birthday is on or before 
-- January 1 of the following year.
isAge65OrOlder :: BirthDate -> Year -> Boolean
isAge65OrOlder bd y =
  let
    nextYear :: Int
    nextYear = (fromEnum y) + 1

    nextYearMinus65 :: Year
    nextYearMinus65 = unsafePartial $ fromJust $ toEnum (nextYear - 65)

    firstDayOfYear65DaysPrior :: Date
    firstDayOfYear65DaysPrior = canonicalDate nextYearMinus65 bottom bottom
  in
    bd <= firstDayOfYear65DaysPrior
