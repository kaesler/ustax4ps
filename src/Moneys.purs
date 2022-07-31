module Moneys
  ( Deduction
  , Income
  , IncomeThreshold
  , TaxCredit
  , TaxPayable
  , TaxableIncome
  , amountOverThreshold
  , applyDeductions
  , applyTaxRate
  , asTaxable
  , class HasAmountOverThreshold
  , class HasCloseEnoughTo
  , class HasMakeFromInt
  , class HasMul
  , class HasNoMoney
  , class HasTimes
  , closeEnoughTo
  , closeEnoughToImpl
  , divInt
  , inflateThreshold
  , isBelow
  , makeFromInt
  , mul
  , noMoney
  , reduceBy
  , roundTaxPayable
  , taxableAsIncome
  , thresholdAsTaxableIncome
  , thresholdDifference
  , times
  ) where
  
import TaxRate
import Data.Int (round, toNumber)
import Data.Monoid.Additive (Additive(..))
import Effect.Exception.Unsafe (unsafeThrow)
import Data.Number (abs)
import Prelude (class Eq, class Monoid, class Ord, class Semigroup, class Show, mempty, otherwise, ($), (/), (*), (-), (<), (<=), (>), (<<<))
import Safe.Coerce (class Coercible, coerce)

class Monoid m <= HasNoMoney m where
  noMoney :: m
noMoneyImpl :: forall m. Monoid m => m
noMoneyImpl = mempty

class Coercible Number m <= HasMakeFromInt m where
  makeFromInt :: Int -> m
-- TODO: require non-negative
makeFromIntImpl :: forall m. Coercible Number m => Int -> m
makeFromIntImpl i = coerce $ toNumber i

class Coercible Number m <= HasMul m where
  mul :: m -> Number -> m
-- TODO: require non-negative
mulImpl :: forall m. Coercible Number m => m -> Number -> m
mulImpl m n = coerce $ n * coerce m

class Coercible Number m <= HasCloseEnoughTo m where
  closeEnoughTo :: m -> m -> Boolean

closeEnoughToImpl :: forall m. Coercible Number m => m -> m -> Boolean
closeEnoughToImpl x y = abs ((coerce x :: Number) - (coerce y :: Number)) <= 2.0

class Coercible Number m <= HasTimes m where
  times :: Int -> m -> m

class Coercible Number h <= HasAmountOverThreshold h where
  amountOverThreshold :: h -> IncomeThreshold -> h

amountOverThresholdImpl :: forall m. Coercible Number m => m -> IncomeThreshold -> m
amountOverThresholdImpl m threshold = coerce $ monus (coerce m) (coerce threshold)

timesImpl :: forall m. Coercible Number m => Int -> m -> m
timesImpl i m = coerce $ (toNumber i) * (coerce m)

type Money = Additive Number

mkMoney :: Number -> Money
mkMoney d
  | d < 0.0 = unsafeThrow "Money can't be negative"
  | otherwise = coerce d

monus :: Money -> Money -> Money
monus m1 m2
  | m1 > m2 = coerce $ (coerce m1 :: Number) - coerce m2
  | otherwise = mkMoney 0.0

diff :: Money -> Money -> Money
diff m1 m2 = coerce $ abs $ (coerce m1) - (coerce m2)

newtype Income = Income Money
derive instance Eq Income
derive newtype instance Monoid Income
derive instance Ord Income
derive newtype instance Semigroup Income
derive newtype instance Show Income
instance HasAmountOverThreshold Income where
  amountOverThreshold = amountOverThresholdImpl
instance HasMakeFromInt Income where
  makeFromInt = makeFromIntImpl
instance HasMul Income where
  mul = mulImpl
instance HasNoMoney Income where
  noMoney = noMoneyImpl

isBelow :: Income -> IncomeThreshold -> Boolean
isBelow i it = (coerce i :: Money) < coerce it

asTaxable :: Income -> TaxableIncome
asTaxable = coerce

newtype Deduction = Deduction Money
derive instance Eq Deduction
derive newtype instance Monoid Deduction
derive instance Ord Deduction
derive newtype instance Semigroup Deduction
derive newtype instance Show Deduction
instance HasMakeFromInt Deduction where
  makeFromInt = makeFromIntImpl
instance HasMul Deduction where
  mul = mulImpl
instance HasNoMoney Deduction where
  noMoney = noMoneyImpl
instance HasTimes Deduction where
  times = timesImpl

newtype IncomeThreshold = IncomeThreshold Money
derive newtype instance Monoid IncomeThreshold
derive newtype instance Semigroup IncomeThreshold
derive newtype instance Show IncomeThreshold
instance HasMakeFromInt IncomeThreshold where
  makeFromInt = makeFromIntImpl

thresholdDifference :: IncomeThreshold -> IncomeThreshold -> TaxableIncome
thresholdDifference it1 it2 = coerce $ diff (coerce it1) (coerce it2)

inflateThreshold :: Number -> IncomeThreshold -> IncomeThreshold
inflateThreshold factor threshold = coerce $ roundHalfUp (coerce threshold * factor)

thresholdAsTaxableIncome :: IncomeThreshold -> TaxableIncome
thresholdAsTaxableIncome = coerce

newtype TaxableIncome = TaxableIncome Money
derive instance Eq TaxableIncome
derive newtype instance Monoid TaxableIncome
derive instance Ord TaxableIncome
derive newtype instance Semigroup TaxableIncome
derive newtype instance Show TaxableIncome
instance HasMakeFromInt TaxableIncome where
  makeFromInt = makeFromIntImpl
instance HasNoMoney TaxableIncome where
  noMoney = noMoneyImpl
instance HasAmountOverThreshold TaxableIncome where
  amountOverThreshold = amountOverThresholdImpl

divInt :: TaxableIncome -> Int -> TaxableIncome
divInt ti i = coerce $ (coerce ti :: Number) / (toNumber i)

taxableAsIncome :: TaxableIncome -> Income
taxableAsIncome = coerce

applyDeductions :: Income -> Deduction -> TaxableIncome
applyDeductions income deductions = coerce $ coerce income `monus` coerce deductions

newtype TaxCredit = TaxCredit Money
derive newtype instance Monoid TaxCredit
derive newtype instance Semigroup TaxCredit
derive newtype instance Show TaxCredit

newtype TaxPayable = TaxPayable Money
derive instance Eq TaxPayable
derive newtype instance Monoid TaxPayable
derive instance Ord TaxPayable
derive newtype instance Semigroup TaxPayable
derive newtype instance Show TaxPayable
instance HasMakeFromInt TaxPayable where
  makeFromInt = makeFromIntImpl
instance HasNoMoney TaxPayable where
  noMoney = noMoneyImpl
instance HasCloseEnoughTo TaxPayable where
  closeEnoughTo = closeEnoughToImpl

applyTaxRate :: forall r. TaxRate r => r -> TaxableIncome -> TaxPayable
applyTaxRate rate income = coerce $ coerce income * rateToNumber rate

reduceBy :: TaxPayable -> TaxPayable -> TaxPayable
reduceBy x y = coerce $ coerce x `monus` coerce y

roundTaxPayable :: TaxPayable -> TaxPayable
roundTaxPayable tp = coerce $ roundHalfUp $ coerce tp

roundHalfUp :: Number -> Number
roundHalfUp = toNumber <<< round