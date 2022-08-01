module UnsafeDatesSpec
  ( runAllTests
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (Spec, it, describe)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (defaultConfig, runSpec')
import UnsafeDates (makeDateFromGoogleSheetRep, unsafeMakeDate)

runAllTests :: Effect Unit
runAllTests = do
  launchAff_
    $
      let
        config = defaultConfig { exit = false }
      in
        runSpec' config [ consoleReporter ]
          unsafeDatesSpec

unsafeDatesSpec :: Spec Unit
unsafeDatesSpec =
  describe "UnsafeDates.makeDateFromGoogleSheetRep" do
    it "works as expected" do
      makeDateFromGoogleSheetRep 0.0 `shouldEqual` (Just $ unsafeMakeDate 1899 12 30)
      makeDateFromGoogleSheetRep 20364.0 `shouldEqual` (Just $ unsafeMakeDate 1955 10 2)

