module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Taxes (FilingStatus(..))

main :: Effect Unit
main = do
  log $ show Single
  log "Hello sailor!"
