module Federal.QualifiedBrackets(
  QualifiedBrackets
  , fromPairs
  , inflateThresholds
  , ordinaryIncomeBracketWidth
  , ordinaryRatesExceptTop
  , rateSuccessor
  , taxFunctionFor
  , taxToEndOfOrdinaryBracket
  , taxableIncomeToEndOfOrdinaryBracket
)

where
  
import Brackets as Brackets
import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Federal.FederalTaxRate (FederalTaxRate, mkFederalTaxRate)
import Moneys (TaxPayable, TaxableIncome)
import Prelude
import Safe.Coerce (coerce)
import TaxFunction (TaxFunction, bracketsTaxFunction)

newtype QualifiedBrackets = QualifiedBrackets (Brackets.Brackets FederalTaxRate)
derive newtype instance Show QualifiedBrackets

fromPairs :: Array (Tuple Number Int) -> QualifiedBrackets
fromPairs pairs = coerce $ Brackets.fromPairs pairs mkFederalTaxRate

inflateThresholds :: Number -> QualifiedBrackets -> QualifiedBrackets
inflateThresholds factor (QualifiedBrackets brackets) = coerce $ Brackets.inflateThresholds factor brackets

taxFunctionFor :: QualifiedBrackets -> TaxFunction
taxFunctionFor (QualifiedBrackets brs) = bracketsTaxFunction brs

rateSuccessor :: FederalTaxRate -> QualifiedBrackets -> Maybe FederalTaxRate
rateSuccessor rate brackets = coerce $ Brackets.rateSuccessor rate (coerce brackets)

ordinaryRatesExceptTop :: QualifiedBrackets -> Array FederalTaxRate
ordinaryRatesExceptTop brackets = Brackets.ratesExceptTop (coerce brackets)

taxableIncomeToEndOfOrdinaryBracket :: QualifiedBrackets -> FederalTaxRate -> TaxableIncome
taxableIncomeToEndOfOrdinaryBracket brackets = Brackets.taxableIncomeToEndOfBracket (coerce brackets)

ordinaryIncomeBracketWidth :: QualifiedBrackets -> FederalTaxRate -> TaxableIncome
ordinaryIncomeBracketWidth brackets = Brackets.bracketWidth (coerce brackets)

taxToEndOfOrdinaryBracket :: QualifiedBrackets -> FederalTaxRate -> TaxPayable
taxToEndOfOrdinaryBracket brackets = Brackets.taxToEndOfBracket (coerce brackets)
