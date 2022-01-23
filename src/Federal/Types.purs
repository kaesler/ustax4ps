module Federal.Types
  ( CombinedIncome
  , DistributionPeriod
  , ItemizedDeductions
  , OrdinaryIncome
  , QualifiedIncome
  , PersonalExemptions
  , SSRelevantOtherIncome
  , SocSec
  , StandardDeduction
  ) where

import Moneys

type CombinedIncome = Income

type DistributionPeriod = Number

type ItemizedDeductions = Deduction

type OrdinaryIncome = Income

type PersonalExemptions = Int

type QualifiedIncome = Income

type SocSec = Income

type SSRelevantOtherIncome = Income

type StandardDeduction = Deduction
