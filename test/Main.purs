module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Test.Spec (it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] do
        it "a dumb test" do
          (9 + 8) `shouldEqual` 17
          logInAff "You should add some tests."

logInAff :: String -> Aff Unit
logInAff msg = liftEffect $ log msg
