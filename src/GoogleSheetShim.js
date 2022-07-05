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

/**
 * Standard deduction for a given year and filing status.
 * Example: STD_DEDUCTION(2022, 'HeadOfHousehold')
 *
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @returns The standard deduction
 * @customfunction
 */
function STD_DEDUCTION(yearAsNumber, filingStatusName) {
  const br = bindRegime(yearAsNumber, filingStatusName); 
  return M.standardDeduction(br);
}

/**
 * Width of an ordinary income tax bracket.
 * Example: BRACKET_WIDTH(2022, 'Single', 10)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} ordinaryRatePercentage 
 * @returns The width of the specified bracket.
 * @customfunction
 */
function BRACKET_WIDTH(yearAsNumber, filingStatusName, ordinaryRatePercentage) {
  const br = bindRegime(yearAsNumber, filingStatusName);
  const brackets = br.ordinaryBrackets;
  const rate = ordinaryRatePercentage / 100.0;
  return M.ordinaryIncomeBracketWidth(brackets)(rate);
}

/**
 * Threshold above which long term capital gains are taxed.
 * Example: LTCG_TAX_START(2022, 'HeadOfHousehold')
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @returns the taxable income threshold.
 * @customfunction
 */
function LTCG_TAX_START(yearAsNumber, filingStatusName) {
  const br = bindRegime(yearAsNumber, filingStatusName);
  return M.startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * The RMD fraction for a given age.
 * Example: RMD_FRACTION_FOR_AGE(76)
 * 
 * @param {number} age
 * @returns the RMD fraction
 * @customfunction
 */
function RMD_FRACTION_FOR_AGE(age) {
  return M.unsafeRmdFractionForAge(age);
}

/**
 * The Federal tax due.
 * Example: FEDERAL_TAX_DUE(2022, 'Single', 10000, 40000, 5000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @returns the Federal tax due
 * @customfunction
 */
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

/**
 * The MA state income tax due.
 * Example: MA_STATE_TAX_DUE(2022, 1, 'Married', 130000)
 * 
 * @param {number} yearAsNumber 
 * @param {number} dependents 
 * @param {string} filingStatusName 
 * @param {number} massachusettsGrossIncome 
 * @returns the MA state income tax due.
 * @customfunction
 */
function MA_STATE_TAX_DUE(yearAsNumber, dependents, filingStatusName, massachusettsGrossIncome) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);
 
  return M.maStateTaxDue(
    use2022after2022(yearAsNumber))(
    TheBirthDate)(
    dependents)(
    filingStatus)(
    massachusettsGrossIncome);
}

/**
 * The marginal tax rate.
 * Example: TAX_SLOPE(2022, 'Single', 10000, 40000, 5000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @returns the marginal tax rate.
 * @customfunction
 */
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

/**
 * The amount of Social Security income that is taxable.
 * Example: TAXABLE_SS('HeadOfHousehold', 20000, 52000)
 * 
 * @param {string} filingStatusName 
 * @param {number} ssRelevantOtherIncome 
 * @param {number} socSec 
 * @returns the amount of Social Security income that is taxable
 * @customfunction
 */
function TAXABLE_SS(filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = M.unsafeReadFilingStatus(filingStatusName);

  return M.amountTaxable(filingStatus)(socSec)(ssRelevantOtherIncome);
}

/**
 * The amount of Social Security income that is taxable, adjusted for inflation.
 * Example: TAXABLE_SS_ADJUSTED(2030, 'HeadOfHousehold', 20000, 52000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} ssRelevantOtherIncome 
 * @param {number} socSec 
 * @returns the amount of Social Security income that is taxable, adjusted for inflation.
 * @customfunction
 */
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
