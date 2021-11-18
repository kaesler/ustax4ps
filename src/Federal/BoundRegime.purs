module Federal.BoundRegime(
  BoundRegime(..)
)
where
  
import Prelude
import Data.Date (Year)

import CommonTypes (FilingStatus, BirthDate)
import Federal.Regime (Regime)

data BoundRegime = BoundRegime 
  {
    regime :: Regime,
    year :: Year,
    filingStatus :: FilingStatus,
    birthDate :: BirthDate
  }