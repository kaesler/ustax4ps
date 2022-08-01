#!/usr/bin/env amm
import scala.io.Source
  Source.stdin
    .getLines()
    .takeWhile(_ != "export {")
    .foreach(println)