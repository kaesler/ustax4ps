// Note: This file must be loaded AFTER the PS bundle.
const M = PS.GoogleSheetModule;
const TheRegime = M.unsafeReadRegime('Trump');
const TheBirthDate = M.unsafeMakeDate(1955)(10)(2);
const ThePersonalExemptions = 1;
const TheItemizedDeductions = 0;

// For now use 2022 for future years.
function use2022after2022(yearAsNumber) {
  if (yearAsNumber <= 2022)
    return M.unsafeMakeYear(yearAsNumber);
  else
    return M.unsafeMakeYear(2022);
}

function bindRegime(yearAsNumber, filingStatusName) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
  return M.boundRegimeForKnownYear(
    use2022after2022(yearAsNumber))(
    TheBirthDate)(
    filingStatus)(
    ThePersonalExemptions
  );
}

function STD_DEDUCTION(yearAsNumber, filingStatusName) {
  const br = bindRegime(yearAsNumber, filingStatusName); 
  return M.standardDeduction(br);
}

function BRACKET_WIDTH(yearAsNumber, filingStatusName, ordinaryRatePercentage) {
  const br = bindRegime(yearAsNumber, filingStatusName);
  const brackets = br.ordinaryBrackets;
  const rate = ordinaryRatePercentage / 100.0;
  return M.ordinaryIncomeBracketWidth(brackets)(rate);
}

function LTCG_TAX_START(yearAsNumber, filingStatusName) {
  const br = bindRegime(yearAsNumber, filingStatusName);
  return M.startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

function RMD_FRACTION_FOR_AGE(age) {
  return M.unsafeRmdFractionForAge(age);
}

function FEDERAL_TAX_DUE(yearAsNumber, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
 
  return M.taxDueForKnownYear(
    use2022after2022(yearAsNumber))(
    filingStatus)(
    TheBirthDate)(
    ThePersonalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    TheItemizedDeductions);
}

function MA_STATE_TAX_DUE(yearAsNumber, dependents, filingStatusName, massachusettsGrossIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
 
  return M.maStateTaxDue(
    use2022after2022(yearAsNumber))(
    TheBirthDate)(
    dependents)(
    filingStatus)(
    massachusettsGrossIncome);
}

function TAX_SLOPE(yearAsNumber, filingStatusName, socSec, ordinaryIncomeNonSS, qualifiedIncome) {
    const deltaX = 1000.0

  const federalTaxAtStart = FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome
  );
  const federalTaxAtEnd = FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    socSec, 
    ordinaryIncomeNonSS + deltaX, 
    qualifiedIncome
  );
  const deltaY = (federalTaxAtEnd - federalTaxAtStart) + 
    (deltaX * M.maStateTaxRate(M.unsafeMakeYear(yearAsNumber)));

  return deltaY/deltaX;
}

function TAXABLE_SS(filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.amountTaxable(filingStatus)(socSec)(ssRelevantOtherIncome);
}

function TAXABLE_SS_ADJUSTED(yearAsNumber, filingStatusName, ssRelevantOtherIncome, socSec) {
  const year = M.unsafeMakeYear(yearAsNumber);
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.amountTaxableInflationAdjusted(
    year)(
    filingStatus)(
    socSec)(
    ssRelevantOtherIncome
  );
}
