module Federal.Yearly.YearlyValuesSpec(
  runAllTests
) where

import Federal.Yearly.YearlyValues

import Data.Maybe (fromJust)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Moneys (roundHalfUp)
import Partial.Unsafe (unsafePartial)
import Prelude (Unit, discard, ($), (*), (-), (/))
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')
import UnsafeDates (unsafeMakeYear)

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $ let
        config = defaultConfig { exit = false }
      in
        runSpec' config [ consoleReporter ]
          yearlyValuesSpec
yearlyValuesSpec :: Spec Unit
yearlyValuesSpec = do
  describe "YearlyValues.yearIsFuture produces expected values" do
    it "" do
      yearIsFuture (unsafeMakeYear 2023) `shouldEqual` true
      yearIsFuture (unsafeMakeYear 2030) `shouldEqual` true
      yearIsFuture (unsafeMakeYear 2022) `shouldEqual` false
  describe "YearlyValues.averageThresholdChangeOverPrevious produces expected values" do
    it "for 2018-2022" do
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2017)) `shouldEqual` 0.78
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2018)) `shouldEqual` 1.75
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2019)) `shouldEqual` 2.02
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2020)) `shouldEqual` 1.63
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2021)) `shouldEqual` 0.95
      asPercentage (unsafePartial $ fromJust (averageThresholdChangeOverPrevious $ unsafeMakeYear 2022)) `shouldEqual` 3.13

asPercentage :: Number -> Number
asPercentage factor = (roundHalfUp ((factor - 1.0) * 10000.0)) / 100.0