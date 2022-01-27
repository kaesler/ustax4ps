module Test.Main where

import AgeSpec as AgeSpec
import Effect (Effect)
import GoldenTestsAgainstScalaImpl as Golden
import Federal.OrdinaryBracketSpec as OrdinaryBracketSpec
import Prelude

main :: Effect Unit
main = do
  OrdinaryBracketSpec.runAllTests
  Golden.runAllTests
  AgeSpec.runAllTests
