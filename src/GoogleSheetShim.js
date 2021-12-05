// Note: This file must be loaded AFTER the PS bundle.
const M = PS.GoogleSheetModule;
const Trump = M.unsafeReadRegime('Trump');
const year2021 = M.unsafeMakeYear(2021);
const birthDate = M.unsafeMakeDate(1955)(10)(2);
const personalExemptions = 1;
const itemizedDeductions = 0;
const partiallyBoundRegime = M.bindRegime(Trump)(year2021)(birthDate);

function bindFilingStatus(filingStatusName) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
  return partiallyBoundRegime(filingStatus)(personalExemptions);
}

function STD_DEDUCTION(filingStatusName) {
  const boundRegime = bindFilingStatus(filingStatusName); 
  return M.standardDeduction(boundRegime);
}

function BRACKET_START(filingStatusName, ordinaryRate) {
  const br = bindFilingStatus(filingStatusName);
  const brackets = br.ordinaryIncomeBrackets;
  return M.ordinaryIncomeBracketStart(brackets)(ordinaryRate);
}

function BRACKET_WIDTH(filingStatusName, ordinaryRate) {
  const br = bindFilingStatus(filingStatusName);
  const brackets = br.ordinaryIncomeBrackets;
  return M.ordinaryIncomeBracketWidth(brackets)(ordinaryRate);
}

function LTCG_TAX_START(filingStatusName) {
  const br = bindFilingStatus(filingStatusName);
  const brackets = br.ordinaryIncomeBrackets;

  return M.startOfNonZeroQualifiedRateBracket(br.qualifiedIncomeBrackets);
}

function RMD_FRACTION_FOR_AGE(age) {
  return M.unsafeRmdFractionForAge(age);
}

// TODO: Why year here? For taxable SS? Check it.
function FEDERAL_TAX_DUE(year, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.taxDue(Trump)(year)(birthDate)(
          filingStatus)(personalExemptions)(socSec)(
          ordinaryIncomeNonSS)(qualifiedIncome)(
          itemizedDeductions);
}

function MA_STATE_TAX_DUE(age, dependents, filingStatusName, massacchusettsGrossIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
 
  return M.maStateTaxDue(year2021)(birthDate)(dependents)(filingStatus)(massacchusettsGrossIncome);
}

function TAX_SLOPE(year, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const deltaX = 1000.0

  const federalTaxAtStart = FEDERAL_TAX_DUE(year, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome);
  const federalTaxAtEnd   = FEDERAL_TAX_DUE(year, filingStatusName, socSec, ordinaryIncomeNonSS + deltaX, qualifiedIncome);
  const deltaY = (federalTaxAtEnd - federalTaxAtStart) + (deltaX * M.maStateTaxRate(year));

  return deltaY/deltaX;
}

function TAXABLE_SS(filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.amountTaxable(filingStatus)(socSec)(ssRelevantOtherIncome);
}

function TAXABLE_SS_ADJUSTED(year, filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.amountTaxableInflationAdjusted(year)(filingStatus)(socSec)(ssRelevantOtherIncome);
}
