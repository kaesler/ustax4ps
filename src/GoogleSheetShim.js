
function DUMMY() {
  const FR = PS.Federal_Regime;
  const regime = FR.unsafeReadRegime("Trump");
  const res = PS.showRegime(regime);
  return res
}

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

function RMD_FRACTION_FOR_AGE(age) {
  const T = PS.Taxes;

  return T.unsafeRmdFractionForAge(age);
}

function FEDERAL_TAX_DUE(year, filingStatus, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const T = PS.Taxes;
  const fs = T.unsafeReadFilingStatus(filingStatus);

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
