module Test.Main where

import AgeSpec as AgeSpec
import Effect (Effect)
import GoldenTestsAgainstScalaImpl as Golden
import Prelude

main :: Effect Unit
main = do
  --OrdinaryIncomeBracketSpec.runAllTests
  Golden.runAllTests
  AgeSpec.runAllTests
