module Federal.OrdinaryBrackets
  ( OrdinaryBrackets
  , fromPairs
  , inflateThresholds
  , ordinaryIncomeBracketWidth
  , ordinaryRatesExceptTop
  , rateSuccessor
  , taxFunctionFor
  , taxToEndOfOrdinaryBracket
  , taxableIncomeToEndOfOrdinaryBracket
  ) where
  
import Brackets as Brackets
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Federal.FederalTaxRate (FederalTaxRate, mkFederalTaxRate)
import Moneys (TaxPayable, TaxableIncome)
import Prelude
import Safe.Coerce (coerce)
import TaxFunction (TaxFunction, bracketsTaxFunction)

newtype OrdinaryBrackets = OrdinaryBrackets (Brackets.Brackets FederalTaxRate)
derive newtype instance Show OrdinaryBrackets

fromPairs :: Array (Tuple Number Int) -> OrdinaryBrackets
fromPairs pairs = coerce $ Brackets.fromPairs pairs mkFederalTaxRate

inflateThresholds :: Number -> OrdinaryBrackets -> OrdinaryBrackets
inflateThresholds factor (OrdinaryBrackets brackets) = coerce $ Brackets.inflateThresholds factor brackets

taxFunctionFor :: OrdinaryBrackets -> TaxFunction
taxFunctionFor (OrdinaryBrackets brs) = bracketsTaxFunction brs

rateSuccessor :: FederalTaxRate -> OrdinaryBrackets -> Maybe FederalTaxRate
rateSuccessor rate brackets = coerce $ Brackets.rateSuccessor rate (coerce brackets)

ordinaryRatesExceptTop :: OrdinaryBrackets -> Array FederalTaxRate
ordinaryRatesExceptTop brackets = Brackets.ratesExceptTop (coerce brackets)

taxableIncomeToEndOfOrdinaryBracket :: OrdinaryBrackets -> FederalTaxRate -> TaxableIncome
taxableIncomeToEndOfOrdinaryBracket brackets = Brackets.taxableIncomeToEndOfBracket (coerce brackets)

ordinaryIncomeBracketWidth :: OrdinaryBrackets -> FederalTaxRate -> TaxableIncome
ordinaryIncomeBracketWidth brackets = Brackets.bracketWidth (coerce brackets)

taxToEndOfOrdinaryBracket :: OrdinaryBrackets -> FederalTaxRate -> TaxPayable
taxToEndOfOrdinaryBracket brackets = Brackets.taxToEndOfBracket (coerce brackets)
