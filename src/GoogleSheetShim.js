// Note: This file must be loaded AFTER the code compiled from Purescript.

const ThePersonalExemptions = 1;

// For now use 2022 for future years.
// TODO: this will have to go.
function use2022after2022(yearAsNumber) {
  if (yearAsNumber <= 2022)
    return unsafeMakeYear(yearAsNumber);
  else
    return unsafeMakeYear(2022);
}

function bindRegime(yearAsNumber, filingStatusName) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);

  return boundRegimeForKnownYear(use2022after2022(yearAsNumber))(filingStatus);
}

function toPurescriptDate(dateObject) {
  if (typeof(dateObject) != "object")
    throw "Date object required";
  if (! dateObject instanceof Date)
    throw "Date object required";
  const year = 1900 + dateObject.getYear();
  const month = 1 + dateObject.getMonth();
  const dayOfMonth = dateObject.getDate();
  return unsafeMakeDate(year)(month)(dayOfMonth);
}

/**
 * Standard deduction for a given year and filing status.
 * Example: STD_DEDUCTION(2022, 'HeadOfHousehold')
 *
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @returns The standard deduction
 * @customfunction
 */
function STD_DEDUCTION(yearAsNumber, filingStatusName, birthDateAsObject) {
  const br = bindRegime(yearAsNumber, filingStatusName); 
  const birthDate = toPurescriptDate(birthDateAsObject);

  return standardDeduction(br)(birthDate);
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
  return ordinaryIncomeBracketWidth(brackets)(rate);
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
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
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
  return unsafeRmdFractionForAge(age);
}

/**
 * The Federal tax due.
 * Example: FEDERAL_TAX_DUE(2022, 'Single', 10000, 40000, 5000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the Federal tax due
 * @customfunction
 */
function FEDERAL_TAX_DUE(
  yearAsNumber, 
  filingStatusName, 
  birthDateAsObject, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  const birthDate = toPurescriptDate(birthDateAsObject);

  return taxDueForKnownYear(
    use2022after2022(yearAsNumber))(
    filingStatus)(
    birthDate)(
    ThePersonalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}

/**
 * The MA state income tax due.
 * Example: MA_STATE_TAX_DUE(2022, 1, 'Married', 130000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @param {number} dependents 
 * @param {number} massachusettsGrossIncome 
 * @returns the MA state income tax due.
 * @customfunction
 */
function MA_STATE_TAX_DUE(
  yearAsNumber, 
  filingStatusName, 
  birthDateAsObject, 
  dependents, 
  massachusettsGrossIncome
  ) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  const birthDate = toPurescriptDate(birthDateAsObject);

  return maStateTaxDue(
    use2022after2022(yearAsNumber))(
    filingStatus)(
    birthDate)(
    dependents)(
    massachusettsGrossIncome);
}

// TODO: eliminate?
/**
 * The marginal tax rate.
 * Example: TAX_SLOPE(2022, 'Single', 10000, 40000, 5000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the marginal tax rate.
 * @customfunction
 */
function TAX_SLOPE(
  yearAsNumber, 
  filingStatusName, 
  birthDateAsObject, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
    const deltaX = 1000.0

  const federalTaxAtStart = FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    birthDateAsObject,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    birthDateAsObject,
    socSec, 
    ordinaryIncomeNonSS + deltaX, 
    qualifiedIncome,
    itemizedDeductions
  );
  const deltaY = (federalTaxAtEnd - federalTaxAtStart) + 
    (deltaX * maStateTaxRate(unsafeMakeYear(yearAsNumber)));

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
function TAXABLE_SOCIAL_SECURITY(filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);

  return amountTaxable(filingStatus)(socSec)(ssRelevantOtherIncome);
}

// TODO: eliminate
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
  const year = unsafeMakeYear(yearAsNumber);
  const filingStatus = unsafeReadFilingStatus(filingStatusName);

  return amountTaxableInflationAdjusted(
    year)(
    filingStatus)(
    socSec)(
    ssRelevantOtherIncome
  );
}
