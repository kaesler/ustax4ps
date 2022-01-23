{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "ustax4ps"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "datetime"
  , "enums"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "integers"
  , "interpolate"
  , "lists"
  , "math"
  , "maybe"
  , "ordered-collections"
  , "partial"
  , "prelude"
  , "psci-support"
  , "quickcheck"
  , "read"
  , "safe-coerce"
  , "spec"
  , "tuples"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
