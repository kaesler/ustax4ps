module Test.Main where

import Prelude
import Effect (Effect)
import Federal.OrdinaryIncomeBracketSpec as OrdinaryIncomeBracketSpec
import GoldenTestsAgainstScalaImpl as Golden

main :: Effect Unit
main = do
  OrdinaryIncomeBracketSpec.runAllTests
  Golden.runAllTests

