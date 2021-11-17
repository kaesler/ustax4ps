{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "retirement-model-purescript"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "integers"
  , "interpolate"
  , "lists"
  , "maybe"
  , "ordered-collections"
  , "partial"
  , "prelude"
  , "psci-support"
  , "quickcheck"
  , "read"
  , "spec"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
