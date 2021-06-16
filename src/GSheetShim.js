function STD_DEDUCTION(filingStatus) {
  const T = PS.Taxes;

  return T.standardDeduction(T.unsafeReadFilingStatus(filingStatus));
}

function BRACKET_START(filingStatus, rate) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);
  const r = T.unsafeOrdinaryRateFromNumber(rate);

  return T.ordinaryIncomeBracketStart(fs)(r);
}

function BRACKET_WIDTH(filingStatus, rate) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);
  const r = T.unsafeOrdinaryRateFromNumber(rate);

  return T.ordinaryIncomeBracketWidth(fs)(r);
}

function LTCG_TAX_START(filingStatus) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);

  return T.startOfNonZeroQualifiedRateBracket(fs);
}

function RATE_SUCCESSOR(filingStatus, rate) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);
  const r = T.unsafeOrdinaryRateFromNumber(rate);

  return T.unsafeOrdinaryRateSuccessor(fs)(r);
}

function RMD_FRACTION_FOR_AGE(age) {
  const T = PS.Taxes;

  return T.unsafeRmdFractionForAge(age);
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
