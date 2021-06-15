function STD_DEDUCTION(filingStatus) {
  const T = PS.Taxes;

  return T.standardDeduction(T.unsafeReadFilingStatus(filingStatus));
}
function BRACKET_START(filingStatus, rate) {
  const T = PS.Taxes;
  return 0;
}
function BRACKET_WIDTH(filingStatus, rate) {
  const T = PS.Taxes;
  return 0;
}
function LTCG_TAX_START(filingStatus) {
  const T = PS.Taxes;
  return 0;
}
function RATE_SUCCESSOR(rate) {
  const T = PS.Taxes;
  return 0;
}
function RMD_FRACTION_FOR_AGE(age) {
  const T = PS.Taxes;
  return 0;
}
function FEDERAL_TAX_DUE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  return 0;
}
function MA_STATE_TAX_DUE(age, dependents, filingStatus, massacchusettsGrossIncome) {
  const T = PS.Taxes;
  return 0;
}
function TAX_SLOPE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  return 0;
}
function TAXABLE_SS(filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  return 0;
}
function TAXABLE_SS_ADJUSTED(year, filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  return 0;
}