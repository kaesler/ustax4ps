module Test.Main where

import AgeSpec as AgeSpec
import Effect (Effect)
import FutureYearsGoldenTestsAgainstScalaImpl as FutureYearsGolden
import KnownYearsGoldenTestsAgainstScalaImpl as KnownYearsGolden
import Federal.OrdinaryBracketSpec as OrdinaryBracketSpec
import Prelude

main :: Effect Unit
main = do
  OrdinaryBracketSpec.runAllTests
  FutureYearsGolden.runAllTests
  KnownYearsGolden.runAllTests
  AgeSpec.runAllTests
