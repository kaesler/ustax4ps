function STD_DEDUCTION(filingStatus) {
  const T = PS.Taxes;

  return T.standardDeduction(T.unsafeReadFilingStatus(filingStatus));
}
function BRACKET_START(filingStatus, rate) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function BRACKET_WIDTH(filingStatus, rate) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function LTCG_TAX_START(filingStatus) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function RATE_SUCCESSOR(rate) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function RMD_FRACTION_FOR_AGE(age) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function FEDERAL_TAX_DUE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function MA_STATE_TAX_DUE(age, dependents, filingStatus, massacchusettsGrossIncome) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function TAX_SLOPE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function TAXABLE_SS(filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}
function TAXABLE_SS_ADJUSTED(year, filingStatus, ssRelevantOtherIncome, socSec) {
  const T = PS.Taxes;
  throw new Error("Not yet impmenented");
}