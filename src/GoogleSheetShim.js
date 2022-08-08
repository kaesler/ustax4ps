// JavaScript shim for Purescript code for Taxes In Retirement library.
// Note: This file must be loaded AFTER the code compiled from Purescript.

// TODO: validate params in the shim and provide better error messages when invalid.

/**
 * Standard deduction for a known year and filing status.
 * Example: TIR_STD_DEDUCTION(2022, "HeadOfHousehold", 1955-10-02)
 *
 * @param {number} year
 * @param {string} filingStatus
 * @param {object} birthDate
 * @returns {number} The standard deduction
 * @customfunction
 */
function TIR_STD_DEDUCTION(year, filingStatus, birthDate) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  const psBirthDate = toPurescriptDate(birthDate);

  return standardDeduction(br)(psBirthDate);
}

/**
 * Standard deduction for a future year and filing status.
 * Example: TIR_FUTURE_STD_DEDUCTION("Trump", 3%, 2030, "HeadOfHousehold", 1955-10-02)
 *
 * @param {string} regime 
 * @param {number} year 
 * @param {number} bracketInflationRate
 * @param {string} filingStatus 
 * @param {object} birthDate
 * @returns {number} The standard deduction
 * @customfunction
 */
function TIR_FUTURE_STD_DEDUCTION(regime, year, bracketInflationRate, filingStatus, birthDate) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  const psBirthDate = toPurescriptDate(birthDate);

  return standardDeduction(br)(psBirthDate);
}

/**
 * Width of an ordinary income tax bracket.
 * Example: TIR_ORDINARY_BRACKET_WIDTH(2022, "Single", 10)
 * 
 * @param {number} year
 * @param {string} filingStatus 
 * @param {number} ordinaryRatePercentage 
 * @returns {number} The width of the specified ordinary income bracket.
 * @customfunction
 */
function TIR_ORDINARY_BRACKET_WIDTH(year, filingStatus, ordinaryRatePercentage) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}

/**
 * Width of a future ordinary income tax bracket.
 * Example: TIR_FUTURE_ORDINARY_BRACKET_WIDTH("PreTrump", 2030, "HeadOfHousehold", 10)
 * 
 * @param {string} regime 
 * @param {number} year
 * @param {number} bracketInflationRate
 * @param {string} filingStatus
 * @param {number} ordinaryRatePercentage 
 * @returns {number} The width of the specified ordinary income bracket.
 * @customfunction
 */
function TIR_FUTURE_ORDINARY_BRACKET_WIDTH(regime, year, bracketInflationRate, filingStatus, ordinaryRatePercentage) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  const rate = ordinaryRatePercentage / 100.0;

  return ordinaryIncomeBracketWidth(br.ordinaryBrackets)(rate);
}


/**
 * Threshold above which long term capital gains are taxed.
 * Example: TIR_LTCG_TAX_START(2022, "HeadOfHousehold")
 * 
 * @param {number} year 
 * @param {string} filingStatus
 * @returns {number} the end of the zero tax rate on qualified investment income
 * @customfunction
 */
function TIR_LTCG_TAX_START(year, filingStatus) {
  const br = bindRegimeForKnownYear(year, filingStatus);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * Threshold above which long term capital gains are taxed, for a future year
 * Example: TIR_FUTURE_LTCG_TAX_START("PreTrump", 2027, 3.4%, "HeadOfHousehold")
 * 
 * @param {string} regime 
 * @param {number} year 
 * @param {number} bracketInflationRate
 * @param {string} filingStatus 
 * @returns {number} the end of the zero tax rate on qualified investment income
 * @customfunction
 */
function TIR_FUTURE_LTCG_TAX_START(regime, year, bracketInflationRate, filingStatus) {
  const br = bindRegimeForFutureYear(regime, year, bracketInflationRate, filingStatus);  
  return startOfNonZeroQualifiedRateBracket(br.qualifiedBrackets);
}

/**
 * The RMD fraction for a given age.
 * Example: TIR_RMD_FRACTION_FOR_AGE(76)
 * 
 * @param {number} age
 * @returns {number} the RMD fraction
 * @customfunction
 */
function TIR_RMD_FRACTION_FOR_AGE(age) {
  return unsafeRmdFractionForAge(age);
}

/**
 * The Federal tax due.
 * Example: TIR_FEDERAL_TAX_DUE(2022, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} year 
 * @param {string} filingStatus
 * @param {object} birthDate
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns {number} the Federal tax due
 * @customfunction
 */
function TIR_FEDERAL_TAX_DUE(
  year, 
  filingStatus, 
  birthDate,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const psYear = unsafeMakeYear(year);
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return taxDueForKnownYear(
    psYear)(
    psFilingStatus)(
    psBirthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}

/**
 * The Federal tax due.
 * Example: TIR_FUTURE_FEDERAL_TAX_DUE("Trump", 2023, 0.034, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {string} regime 
 * @param {number} year 
 * @param {number} bracketInflationRate
 * @param {string} filingStatus 
 * @param {object} birthDate
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns {number} the Federal tax due
 * @customfunction
 */
function TIR_FUTURE_FEDERAL_TAX_DUE(
  regime,
  year, 
  bracketInflationRate,
  filingStatus, 
  birthDate,
  personalExemptions, 
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const psRegime = unsafeReadRegime(regime);
  const psYear = unsafeMakeYear(year);
  const inflationFactorEstimate = 1.0 + bracketInflationRate;
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return taxDueForFutureYear(
    psRegime)(
    psYear)(
    inflationFactorEstimate)(
    psFilingStatus)(
    psBirthDate)(
    personalExemptions)(
    socSec)(
    ordinaryIncomeNonSS)(
    qualifiedIncome)(
    itemizedDeductions);
}


/**
 * The marginal tax rate.
 * Example: TIR_FEDERAL_TAX_SLOPE(2022, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {number} year
 * @param {string} filingStatus 
 * @param {object} birthDate
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns {number} the marginal tax rate.
 * @customfunction
 */
function TIR_FEDERAL_TAX_SLOPE(
  year, 
  filingStatus, 
  birthDate, 
  personalExemptions,
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
    const deltaX = 1000.0

  const federalTaxAtStart = TIR_FEDERAL_TAX_DUE(
    year, 
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = TIR_FEDERAL_TAX_DUE(
    year, 
    filingStatus, 
    birthDate,
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
 * The marginal tax rate.
 * Example: TIR_FUTURE_FEDERAL_TAX_SLOPE("Trump", 2023, 0.034, "Single", 1955-10-02, 0, 10000, 40000, 5000, 0)
 * 
 * @param {string} regime 
 * @param {number} year 
 * @param {number} bracketInflationRate
 * @param {string} filingStatus
 * @param {object} birthDate
 * @param {number} personalExemptions
 * @param {number} socSec 
 * @param {number} ordinaryIncomeNonSS 
 * @param {number} qualifiedIncome 
 * @param {number} itemizedDeductions 
 * @returns the marginal tax rate.
 * @customfunction
 */
function TIR_FUTURE_FEDERAL_TAX_SLOPE(
  regime,
  year, 
  bracketInflationRate,
  filingStatus, 
  birthDate, 
  personalExemptions,
  socSec, 
  ordinaryIncomeNonSS, 
  qualifiedIncome,
  itemizedDeductions
  ) {
  const deltaX = 1000.0;

  const federalTaxAtStart = TIR_FUTURE_FEDERAL_TAX_DUE(
    regime,
    year, 
    bracketInflationRate,
    filingStatus, 
    birthDate,
    personalExemptions,
    socSec, 
    ordinaryIncomeNonSS, 
    qualifiedIncome,
    itemizedDeductions
  );
  const federalTaxAtEnd = TIR_FUTURE_FEDERAL_TAX_DUE(
    regime,
    year, 
    bracketInflationRate,
    filingStatus, 
    birthDate,
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
 * Example: TIR_TAXABLE_SOCIAL_SECURITY("HeadOfHousehold", 20000, 52000)
 * 
 * @param {string} filingStatus 
 * @param {number} ssRelevantOtherIncome 
 * @param {number} socSec 
 * @returns {number} the amount of Social Security income that is taxable
 * @customfunction
 */
function TIR_TAXABLE_SOCIAL_SECURITY(filingStatus, ssRelevantOtherIncome, socSec) {
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);

  return amountTaxable(psFilingStatus)(socSec)(ssRelevantOtherIncome);
}

/**
 * The MA state income tax due.
 * Example: TIR_MA_STATE_TAX_DUE(2022, "Married", 1955-10-02, 0, 130000)
 * 
 * @param {number} year 
 * @param {string} filingStatus 
 * @param {object} birthDate
 * @param {number} dependents 
 * @param {number} massachusettsGrossIncome 
 * @returns {number} the MA state income tax due.
 * @customfunction
 */
function TIR_MA_STATE_TAX_DUE(
  year, 
  filingStatus, 
  birthDate, 
  dependents, 
  massachusettsGrossIncome
  ) {
  const psYear = unsafeMakeYear(year);
  const psFilingStatus = unsafeReadFilingStatus(filingStatus);
  const psBirthDate = toPurescriptDate(birthDate);

  return maStateTaxDue(
    psYear)(
    psFilingStatus)(
    psBirthDate)(
    dependents)(
    massachusettsGrossIncome);
}

function bindRegimeForKnownYear(yearAsNumber, filingStatusName) {
  const psFilingStatus = unsafeReadFilingStatus(filingStatusName);
  const psYear = unsafeMakeYear(yearAsNumber);

  return boundRegimeForKnownYear(psYear)(psFilingStatus);
}

function bindRegimeForFutureYear(regimeName, yearAsNumber, bracketInflationRate, filingStatusName) {
  const psRegime = unsafeReadRegime(regimeName);
  const psYear = unsafeMakeYear(yearAsNumber);
  const inflationFactorEstimate = 1.0 + bracketInflationRate;
  const psFilingStatus = unsafeReadFilingStatus(filingStatusName);
  
  return boundRegimeForFutureYear(psRegime)(psYear)(inflationFactorEstimate)(psFilingStatus);  
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
