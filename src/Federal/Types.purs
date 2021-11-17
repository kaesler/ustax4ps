module Federal.Types(
  BracketStart(..),
  StandardDeduction(..),
  bracketStartAsNumber,
  standardDeduction
)

where

import Prelude (class Eq, class Ord, class Show, show, (+))

import Data.Int (toNumber)
  
import CommonTypes

newtype BracketStart = BracketStart Int
derive instance Eq BracketStart
derive instance Ord BracketStart
instance showBracketStart :: Show BracketStart where
  show (BracketStart s) = show s
bracketStartAsNumber :: BracketStart -> Number
bracketStartAsNumber (BracketStart i) = toNumber i

newtype StandardDeduction = StandardDeduction Int
derive instance Eq StandardDeduction
derive instance Ord StandardDeduction
instance showStandardDeduction :: Show StandardDeduction where
  show (StandardDeduction sd) = show sd 

over65Increment :: Int
over65Increment = 1350

standardDeduction :: FilingStatus -> StandardDeduction
standardDeduction HeadOfHousehold = StandardDeduction (18800 + over65Increment)
standardDeduction Single = StandardDeduction (12550 + over65Increment)
