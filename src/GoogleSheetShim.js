// Note: This file must be loaded AFTER the PS bundle.
// TODO: how to deal with years after 2022?
const M = PS.GoogleSheetModule;
const TheRegime = M.unsafeReadRegime('Trump');
const TheBirthDate = M.unsafeMakeDate(1955)(10)(2);
const ThePersonalExemptions = 1;
const TheItemizedDeductions = 0;

// For now use 2022 for future years.
function use2022after2022(year) {
  if (year <= 2022)
    return year;
  else
    return 2022;
}

function bindRegime(year, filingStatusName) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
  return M.bindRegime(TheRegime)(use2022after2022(year))(TheBirthDate)(filingStatus)(ThePersonalExemptions);
}

function STD_DEDUCTION(year, filingStatusName) {
  const br = bindRegime(year, filingStatusName); 
  return M.standardDeduction(br);
}

function BRACKET_WIDTH(year, filingStatusName, ordinaryRate) {
  const br = bindRegime(year, filingStatusName);
  const brackets = br.ordinaryBrackets;
  return M.ordinaryIncomeBracketWidth(brackets)(ordinaryRate);
}

function LTCG_TAX_START(year, filingStatusName) {
  const br = bindRegime(year, filingStatusName);
  return M.startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

function RMD_FRACTION_FOR_AGE(age) {
  return M.unsafeRmdFractionForAge(age);
}

function FEDERAL_TAX_DUE(year, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.taxDue(
    TheRegime)(
    use2022after2022(year))(
    TheBirthDate)(
    filingStatus)(
    ThePersonalExemptions)(socSec)(
    ordinaryIncomeNonSS)(qualifiedIncome)(
    TheItemizedDeductions);
}

function MA_STATE_TAX_DUE(year, dependents, filingStatusName, massacchusettsGrossIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
 
  return M.maStateTaxDue(
    use2022after2022(year))(
    TheBirthDate)(
    dependents)(
    filingStatus)(
    massacchusettsGrossIncome);
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
