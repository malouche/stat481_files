## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 3 (R LAB) - R, RStudio and Quarto - Sun 30 Aug 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L3STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/03_L3_RLab_R_RStudio_Quarto_Aug30.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs
dir.create("figures", showWarnings = FALSE)  # this lecture writes a PDF there

# --------------------------------------------------------------------------
#  Step 1 - The project, and a real file
# --------------------------------------------------------------------------

basename(getwd())     # which folder is R working in right now?

wh <- read.csv("data/worldhealth2022.csv", row.names = 1)
dim(wh)

str(wh, vec.len = 1)

# --------------------------------------------------------------------------
#  Step 2 - data.frame or matrix?
# --------------------------------------------------------------------------

class(wh)           # what kind of object is it?
is.matrix(wh)

as.matrix(wh)[1:3, c("country", "life_exp", "fertility")]

X <- as.matrix(wh[, 4:11])   # the eight numeric columns only
class(X)
dim(X)

# --------------------------------------------------------------------------
#  Step 3 - Getting at the data
# --------------------------------------------------------------------------

wh[1:3, c("country", "life_exp", "fertility")]   # 3 rows, 3 columns

wh$life_exp[1:5]        # that column, then its first 5 entries

wh[wh$life_exp > 84, c("country", "life_exp", "pop65")]

# --------------------------------------------------------------------------
#  Step 4 - apply(), and a question it answers wrongly
# --------------------------------------------------------------------------

round(apply(X, 2, mean), 2)    # MARGIN = 2 -> work down each COLUMN

round(apply(X, 2, sd), 2)      # the eight standard deviations

round(diag(cov(X)), 1)

round(100 * diag(cov(X)) / sum(diag(cov(X))), 3)   # percent of total

# --------------------------------------------------------------------------
#  Step 5 - One line, and what it catches
# --------------------------------------------------------------------------

library(psych)
describe(wh[, c("life_exp", "gdp_pc", "internet_pct")])

wh[wh$life_exp < 40, c("country", "life_exp", "infant_mort")]

ok <- wh$life_exp > 40            # everything except the bad row
round(c(all = cor(wh$life_exp, wh$infant_mort),
        ok  = cor(wh$life_exp[ok], wh$infant_mort[ok])), 3)

round(cor(wh[, c("life_exp", "infant_mort", "fertility",
                 "internet_pct")]), 3)

# --------------------------------------------------------------------------
#  Step 6 - Summaries by group
# --------------------------------------------------------------------------

round(tapply(wh$life_exp, wh$income, mean), 1)

econ <- c("Low income", "Lower middle income",
          "Upper middle income", "High income")
round(tapply(wh$life_exp, wh$income, mean)[econ], 1)

round(tapply(wh$health_exp_pct, wh$income, mean)[econ], 2)

# --------------------------------------------------------------------------
#  Step 7 - The country no single variable flags
# --------------------------------------------------------------------------

zq <- (X["QAT", ] - apply(X, 2, mean)) / apply(X, 2, sd)
round(zq, 2)

# --------------------------------------------------------------------------
#  Wrap-up
# --------------------------------------------------------------------------

pdf("figures/L3_life_pop65.pdf", width = 6, height = 4.2)
par(mar = c(4.2, 4.2, 0.6, 0.6))  # margins in lines: b, l, t, r
plot(wh$life_exp, wh$pop65, pch = 21, bg = "grey80", col = "grey30",
     xlab = "life expectancy at birth (years)",
     ylab = "population aged 65+ (%)")
dev.off()
