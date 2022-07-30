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
--  , "debug"
  , "enums"
  , "effect"
  , "exceptions"
  , "foldable-traversable"
  , "integers"
  , "interpolate"
  , "lists"
  , "maybe"
  , "numbers"
  , "ordered-collections"
  , "partial"
  , "prelude"
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
