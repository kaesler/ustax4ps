
// Note: This file must be loaded AFTER the PS bundle.
const M = PS.GoogleSheetModule;
const Trump = M.unsafeReadRegime('Trump');
const year2021 = M.unsafeMakeYear(2021);
const birthDate = M.unsafeMakeDate(1955)(10)(2);
const personalExemptions = 1;
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

// TODO: Why year here? For taxable SS?
function FEDERAL_TAX_DUE(year, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const filingStatus = T.unsafeReadFilingStatus(filingStatusName);

  return T.federalTaxDue(year)(fs)(socSec)(ordinaryIncomeNonSS)(qualifiedIncome);
}

function MA_STATE_TAX_DUE(age, dependents, filingStatus, massacchusettsGrossIncome) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);

  return T.maStateTaxDue(age)(dependents)(fs)(massacchusettsGrossIncome);
}

function TAX_SLOPE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);
  const deltaX = 1000.0
  const federalTaxAtStart = T.federalTaxDue(year)(fs)(socSec)(ordinaryIncomeNonSS)(qualifiedIncome);
  const federalTaxAtEnd = T.federalTaxDue(year)(fs)(socSec)(ordinaryIncomeNonSS + deltaX)(qualifiedIncome);
  const deltaY = (federalTaxAtEnd - federalTaxAtStart) + (deltaX * T.maStateTaxRate);

  return deltaY/deltaX;
}

function TAXABLE_SS(filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);

  return T.taxableSocialSecurity(fs)(ssRelevantOtherIncome)(socSec);
}

function TAXABLE_SS_ADJUSTED(year, filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);

  return T.taxableSocialSecurityAdjusted(year)(fs)(ssRelevantOtherIncome)(socSec);
}
