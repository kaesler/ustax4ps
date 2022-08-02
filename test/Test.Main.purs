module Test.Main where

import Prelude

import AgeSpec as AgeSpec
import Effect (Effect)
import Federal.OrdinaryBracketSpec as OrdinaryBracketSpec
import Federal.Yearly.YearlyValuesSpec as YearlyValuesSpec
import FutureYearsGoldenTestsAgainstScalaImpl as FutureYearsGolden
import KnownYearsGoldenTestsAgainstScalaImpl as KnownYearsGolden

main :: Effect Unit
main = do
  OrdinaryBracketSpec.runAllTests
  YearlyValuesSpec.runAllTests
  FutureYearsGolden.runAllTests
  KnownYearsGolden.runAllTests
  AgeSpec.runAllTests
  