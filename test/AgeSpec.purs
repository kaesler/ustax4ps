module AgeSpec
  ( runAllTests
  ) where

import Prelude
import Age as Age
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')
import UnsafeDates (unsafeMakeDate, unsafeMakeYear)

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $ let
        config = defaultConfig { exit = false }
      in
        runSpec' config [ consoleReporter ]
          ageSpec

ageSpec :: Spec Unit
ageSpec =
  describe "Age.isAge65OrOlder" do
    it "works as expected" do
      (Age.isAge65OrOlder (unsafeMakeDate 1956 1 1) (unsafeMakeYear 2020)) `shouldEqual` true
      (Age.isAge65OrOlder (unsafeMakeDate 1955 10 2) (unsafeMakeYear 2020)) `shouldEqual` true
      (Age.isAge65OrOlder (unsafeMakeDate 1955 10 2) (unsafeMakeYear 2019)) `shouldEqual` false
