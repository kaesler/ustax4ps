module Federal.Types(
  BracketStart(..),
  ItemizedDeductions,
  PersonalExemptions,
  StandardDeduction(..),
  bracketStartAsNumber
)

where

import Prelude (class Eq, class Ord, class Show, show)
import Data.Int (toNumber)
import CommonTypes

type ItemizedDeductions = Money
type PersonalExemptions = Int

newtype BracketStart = BracketStart Int
derive instance Eq BracketStart
derive instance Ord BracketStart
instance Show BracketStart where
  show (BracketStart s) = show s
bracketStartAsNumber :: BracketStart -> Number
bracketStartAsNumber (BracketStart i) = toNumber i

newtype StandardDeduction = StandardDeduction Int
derive instance Eq StandardDeduction
derive instance Ord StandardDeduction
instance Show StandardDeduction where
  show (StandardDeduction sd) = show sd 


