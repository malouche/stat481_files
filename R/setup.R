## ─────────────────────────────────────────────────────────────────────────────
##  STAT 481 — Multivariate Analysis — Fall 2026
##  R/setup.R — run this first.
##
##      source("R/setup.R")     # reports which packages you are missing
##      stat481_check()         # the same report, on demand
##      stat481_load("L4")      # attach what Lecture 4 needs
##
##  GENERATED FILE — do not edit by hand.  It is written by
##  make_stat481_files.py from the instructor's package map, so the list below
##  is always the same one the lectures were built against.  27 packages,
##  generated 14 Sep 2026.
## ─────────────────────────────────────────────────────────────────────────────

## package -> the lecture that introduces it
STAT481_PACKAGES <- c(
  HSAUR2           = "L1",
  corrplot         = "L2",
  psych            = "L3",
  quarto           = "L3",
  knitr            = "L3",
  sessioninfo      = "L3",
  renv             = "L3",
  GGally           = "L4",
  aplpack          = "L4",
  ggplot2          = "L4",
  seriation        = "L4A",
  palmerpenguins   = "L4",
  car              = "L7",
  expm             = "L7",
  pheatmap         = "L5",
  MASS             = "L6",
  mvtnorm          = "L11",
  MVN              = "L13",
  energy           = "L13",
  DescTools        = "L14",
  heplots          = "L19",
  effectsize       = "L20",
  FactoMineR       = "L22",
  factoextra       = "L22",
  GPArotation      = "L24",
  candisc          = "L25",
  cluster          = "L26"
)

stat481_check <- function(quiet = FALSE) {
  have <- vapply(names(STAT481_PACKAGES),
                 function(p) requireNamespace(p, quietly = TRUE), logical(1))
  if (!quiet) {
    cat(sprintf("STAT 481: %d of %d packages available.\n",
                sum(have), length(have)))
    if (any(!have)) {
      cat("Missing:", paste(names(have)[!have], collapse = ", "), "\n")
      cat('Install with:\n  install.packages(c(',
          paste(sprintf('"%s"', names(have)[!have]), collapse = ", "),
          "))\n", sep = "")
    } else {
      cat("Nothing missing - you can run every lecture in this project.\n")
    }
  }
  invisible(have)
}

stat481_load <- function(what) {
  pkgs <- if (length(what) == 1 && grepl("^L[0-9]", what))
    names(STAT481_PACKAGES)[STAT481_PACKAGES == what] else what
  for (p in pkgs) suppressPackageStartupMessages(library(p, character.only = TRUE))
  invisible(pkgs)
}

## The two data sets of the course so far.  Both are frozen CSVs: the World Bank
## revises past years, so every number printed in the notes came from these
## copies and not from the live API.
stat481_data <- function(name = c("worldhealth2022", "whwide2022")) {
  name <- match.arg(name)
  if (name == "worldhealth2022")
    utils::read.csv("data/worldhealth2022.csv", row.names = 1)
  else
    utils::read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
}

if (interactive()) stat481_check()
