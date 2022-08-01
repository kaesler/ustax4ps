#!/usr/bin/env amm
import scala.io.Source
  // Removes the export section at the end. It can't be parsed by Google sheets.
  Source.stdin
    .getLines()
    .takeWhile(_ != "export {")
    .foreach(println)