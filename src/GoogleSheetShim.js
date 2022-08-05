// Note: This file must be loaded AFTER the code compiled from Purescript.

/**
 * Standard deduction for a known year and filing status.
 * Example: KTL_STD_DEDUCTION(2022, 'HeadOfHousehold', 1955-10-02)
 *
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @returns The standard deduction
 * @customfunction
 */
function KTL_STD_DEDUCTION(yearAsNumber, filingStatusName, birthDateAsObject) {
  const br = bindRegimeForKnownYear(yearAsNumber, filingStatusName);  
  const birthDate = toPurescriptDate(birthDateAsObject);

  return standardDeduction(br)(birthDate);
}

/**
 * Standard deduction for a future year and filing status.
 * Example: KTL_FUTURE_STD_DEDUCTION('Trump', 3%, 2030, 'HeadOfHousehold', 1955-10-02)
 *
 * @param {string} regimeName 
 * @param {number} yearAsNumber 
 * @param {number} inflationDeltaEstimate
 * @param {string} filingStatusName 
 * @param {number} birthDateAsObject
 * @returns The standard deduction
 * @customfunction
 */
 function KTL_FUTURE_STD_DEDUCTION(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName, birthDateAsObject) {
  const br = bindRegimeForFutureYear(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName);  
  const birthDate = toPurescriptDate(birthDateAsObject);

  return standardDeduction(br)(birthDate);
}

/**
 * Width of an ordinary income tax bracket.
 * Example: KTL_BRACKET_WIDTH(2022, 'Single', 10)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {number} ordinaryRatePercentage 
 * @returns The width of the specified bracket.
 * @customfunction
 */
function KTL_BRACKET_WIDTH(yearAsNumber, filingStatusName, ordinaryRatePercentage) {
  const br = bindRegimeForKnownYear(yearAsNumber, filingStatusName);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}

/**
 * Width of a future ordinary income tax bracket.
 * Example: KTL_FUTURE_BRACKET_WIDTH('PreTrump', 2030, 'HeadOfHousehold', 10)
 * 
 * @param {string} regimeName 
 * @param {number} yearAsNumber 
 * @param {number} inflationDeltaEstimate
 * @param {string} filingStatusName 
 * @param {number} ordinaryRatePercentage 
 * @returns The width of the specified bracket.
 * @customfunction
 */
 function KTL_FUTURE_BRACKET_WIDTH(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName, ordinaryRatePercentage) {
  const br = bindRegimeForFutureYear(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}


/**
 * Threshold above which long term capital gains are taxed.
 * Example: KTL_LTCG_TAX_START(2022, 'HeadOfHousehold')
 * 
 * @param {number} yearAsNumber 

 */
function KTL_LTCG_TAX_START(yearAsNumber, filingStatusName) {
  const br = bindRegimeForKnownYear(yearAsNumber, filingStatusName);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * Threshold above which long term capital gains are taxed, for a future year
 * Example: KTL_LTCG_TAX_START(2022, 'HeadOfHousehold')
 * 
 * @param {string} regimeName 
 * @param {number} yearAsNumber 
 * @param {number} inflationDeltaEstimate
 * @param {string} filingStatusName 
 * @returns the taxable income threshold.
 * @customfunction
 */
 function KTL_FUTURE_LTCG_TAX_START(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName) {
  const br = bindRegimeForFutureYear(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * The RMD fraction for a given age.
 * Example: KTL_RMD_FRACTION_FOR_AGE(76)
 * 
 * @param {number} age
 * @returns the RMD fraction
 * @customfunction
 */
function KTL_RMD_FRACTION_FOR_AGE(age) {
  return unsafeRmdFractionForAge(age);
}

/**
 * The Federal tax due.
 * Example: KTL_FEDERAL_TAX_DUE(2022, 'Single', 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {object} birthDateAsObject
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the Federal tax due
 * @customfunction
 */
function KTL_FEDERAL_TAX_DUE(
  yearAsNumber, 
  filingStatusName, 
  birthDateAsObject,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const year = unsafeMakeYear(yearAsNumber);
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  const birthDate = toPurescriptDate(birthDateAsObject);

  return taxDueForKnownYear(
    year)(
    filingStatus)(
    birthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}

/**
 * The Federal tax due.
 * Example: KTL_FUTURE_FEDERAL_TAX_DUE("Trump", 2023, 0.034, 'Single', 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {string} regimeName 
 * @param {number} yearAsNumber 
 * @param {number} inflationDeltaEstimate
 * @param {string} filingStatusName 
 * @param {object} birthDateAsObject
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the Federal tax due
 * @customfunction
 */
 function KTL_FUTURE_FEDERAL_TAX_DUE(
  regimeName,
  yearAsNumber, 
  inflationDeltaEstimate,
  filingStatusName, 
  birthDateAsObject,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const regime = unsafeReadRegime(regimeName);
  const year = unsafeMakeYear(yearAsNumber);
  const inflationFactorEstimate = 1.0 + inflationDeltaEstimate;
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  const birthDate = toPurescriptDate(birthDateAsObject);

  return taxDueForFutureYear(
    regime)(
    year)(
    inflationFactorEstimate)(
    filingStatus)(
    birthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}


/**
 * The marginal tax rate.
 * Example: KTL_FEDERAL_TAX_SLOPE(2022, 'Single', 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {object} birthDateAsObject
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the marginal tax rate.
 * @customfunction
 */
function KTL_FEDERAL_TAX_SLOPE(
  yearAsNumber, 
  filingStatusName, 
  birthDateAsObject, 
  personalExemptions,
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
    const deltaX = 1000.0

  const federalTaxAtStart = KTL_FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    birthDateAsObject,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = KTL_FEDERAL_TAX_DUE(
    yearAsNumber, 
    filingStatusName, 
    birthDateAsObject,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS + deltaX, 
    qualifiedIncome,
    itemizedDeductions
  );
  const deltaY = (federalTaxAtEnd - federalTaxAtStart);

  return deltaY/deltaX;
}

/**
 * The amount of Social Security income that is taxable.
 * Example: KTL_TAXABLE_SOCIAL_SECURITY('HeadOfHousehold', 20000, 52000)
 * 
 * @param {string} filingStatusName 
 * @param {number} ssRelevantOtherIncome 
 * @param {number} socSec 
 * @returns the amount of Social Security income that is taxable
 * @customfunction
 */
function KTL_TAXABLE_SOCIAL_SECURITY(filingStatusName, ssRelevantOtherIncome, socSec) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);

  return amountTaxable(filingStatus)(socSec)(ssRelevantOtherIncome);
}

/**
 * The MA state income tax due.
 * Example: KTL_MA_STATE_TAX_DUE(2022, 'Married', 1955-10-02, 0, 130000)
 * 
 * @param {number} yearAsNumber 
 * @param {string} filingStatusName 
 * @param {object} birthDateAsObject
 * @param {number} dependents 
 * @param {number} massachusettsGrossIncome 
 * @returns the MA state income tax due.
 * @customfunction
 */
 function KTL_MA_STATE_TAX_DUE(
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

// TODO: flush
// For now use 2022 for future years.
// TODO: this will have to go.
function use2022after2022(yearAsNumber) {
  if (yearAsNumber <= 2022)
    return unsafeMakeYear(yearAsNumber);
  else
    return unsafeMakeYear(2022);
}

function bindRegimeForKnownYear(yearAsNumber, filingStatusName) {
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  const year = unsafeMakeYear(yearAsNumber);

  return boundRegimeForKnownYear(year)(filingStatus);
}

function bindRegimeForFutureYear(regimeName, yearAsNumber, inflationDeltaEstimate, filingStatusName) {
  const regime = unsafeReadRegime(regimeName);
  const year = unsafeMakeYear(yearAsNumber);
  const inflationFactorEstimate = 1.0 + inflationDeltaEstimate;
  const filingStatus = unsafeReadFilingStatus(filingStatusName);
  
  return boundRegimeForFutureYear(regime)(year)(inflationFactorEstimate)(filingStatus);  
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
