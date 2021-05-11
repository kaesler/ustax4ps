module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Taxes (FilingStatus(..), applyOrdinaryIncomeBrackets)

main :: Effect Unit
main = 
  let answer = applyOrdinaryIncomeBrackets HeadOfHousehold 5000000.0
  in
    do
      log $ show answer
      log "Hello sailor!"
