module Federal.Types(
  BracketStart(..),
  CombinedIncome,
  DistributionPeriod,
  ItemizedDeductions,
  OrdinaryIncome,
  QualifiedIncome,
  PersonalExemptions,
  SSRelevantOtherIncome,
  SocSec,
  StandardDeduction(..),
  bracketStartAsNumber
)

where

import Prelude (class Eq, class Ord, class Show, show)
import Data.Int (toNumber)
import CommonTypes

type ItemizedDeductions = Money
type PersonalExemptions = Int

type CombinedIncome = Money
type DistributionPeriod = Money

type OrdinaryIncome = Money
type QualifiedIncome = Money
type SSRelevantOtherIncome = Money
type SocSec = Money

newtype BracketStart = BracketStart Int
derive instance Eq BracketStart
derive instance Ord BracketStart
derive newtype instance Show BracketStart
bracketStartAsNumber :: BracketStart -> Number
bracketStartAsNumber (BracketStart i) = toNumber i

newtype StandardDeduction = StandardDeduction Int
derive instance Eq StandardDeduction
derive instance Ord StandardDeduction
instance Show StandardDeduction where
  show (StandardDeduction sd) = show sd 


