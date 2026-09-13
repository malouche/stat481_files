# STAT 481 — Multivariate Analysis — Fall 2026

Course materials for STAT 481 at Qatar University: the lecture notes, the
in-class worksheets, the lab briefs, and a **runnable R project** with the data.

*Instructor: Dhafer Malouche. Sunday / Tuesday / Thursday, 12:00-12:50,
BCR - Corridor H210.*

---

## Getting started (five minutes, once)

1. Install **R** (4.4 or newer) and **RStudio**.
2. Download this folder — the green **Code -> Download ZIP** button on GitHub,
   or the copy on Blackboard — and unzip it somewhere you will find again.
3. **Double-click `STAT481.Rproj`.** This is the step people skip, and it is the
   one that makes every path in the notes work. Never use `setwd()`.
4. In the R console:

   ```r
   source("R/setup.R")
   ```

   It tells you which packages you are missing and prints the exact
   `install.packages(...)` line to fix it. Run that line, then `source` it again
   until it says nothing is missing.
5. Check the data loads:

   ```r
   wh <- read.csv("data/worldhealth2022.csv", row.names = 1)
   dim(wh)      # 176  11
   ```

If step 5 errors with "cannot open file", you are not inside the project — go
back to step 3.

## What is in here

| folder | what |
|---|---|
| `00_syllabus/` | the syllabus |
| `01_lectures/` | lecture notes, numbered in the order they are taught |
| `02_worksheets/` | the in-class worksheets |
| `03_assessments/` | the R lab briefs and, later, sample quizzes |
| `04_practice_sheets/` | the in-class practice sheets (student copies; corrected in class) |
| `data/` | the frozen CSVs, each with a codebook |
| `R/` | `setup.R`, and one script per lecture holding that lecture's code |

Filenames carry the session date, so the folder sorts into teaching order.

## The lecture code

`R/L1_code.R` ... `R/L5_code.R` hold **every code block printed in that
lecture's notes, in the same order**. They are extracted from the notes
themselves, so the script and the PDF cannot disagree: if a line is in the
script, it was on the page in front of you.

Each one runs top to bottom in a fresh session, from the project root:

```r
source("R/L2_code.R")
```

Reading it is not the point — running it a block at a time, next to the PDF, is.
Change a number and see what moves. `R/L4_code.R` and `R/L5_code.R` each
include their lecture's appendix, which is required reading; that code needs
objects the body defines, so the two stay in one file.

Nothing here is a worksheet answer. The worksheet code lives in the worksheet
keys and is released on Blackboard on the schedule in the syllabus.

## About the packages

`R/setup.R` lists every package the course introduces, tagged with the lecture
that introduces it, so `stat481_check()` can tell you what you are missing
before a lab rather than during one. You do not need all of them in week 1 —
install what the lecture in front of you asks for.

Two notes. **`renv` is on the list because Lecture 3 explains what a lockfile
is, but this folder is not an renv project** — there is no `renv.lock` here and
you do not need one; install packages normally. And **R Lab 1 uses `swiss`**,
which ships inside base R, so it needs no download at all.

## The data

Two files, both **frozen** copies of World Bank 2022 data:

- **`worldhealth2022.csv`** — 176 countries, 8 indicators. The course spine.
- **`whwide2022.csv`** — the same 176 countries in the same order, on 52
  indicators.

Read the codebook beside each one before you use it. Do not re-pull either from
the World Bank API: they revise past years, and every number printed in the
notes came from these exact copies.

## How this folder is updated

Material appears here **after it has been taught and checked**, not before. If a
lecture you expect is missing, it is because it is still being finished — you
are not looking at an incomplete download. Everything here is rebuilt from
source by a script that verifies each file before copying it, so what you have
always matches what was taught.

**Solutions, answer keys, quizzes and exams are never in this folder.** Those
are released through Blackboard, on the schedule in the syllabus. The sample
quiz before each quiz is the exception: its student copy sits in
`03_assessments/` so you can try it before the correction session.

## Using an AI assistant

You may use one, and Lecture 4 onward shows you how: every section of the notes
ends with a box giving the prompt that produces that section's code and the
three things to check in the answer. The habit the course asks for is short:
**name your data and your constraint, ask for the tool the course uses, run it,
and check one number you already know.** Code you cannot check against something
you already believe is not evidence.

## Terms

Course materials (c) 2026 Dhafer Malouche, Qatar University. Provided for the
personal study of students enrolled in STAT 481. The data are World Bank Open
Data, redistributed under CC BY 4.0.
