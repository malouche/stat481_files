## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 2 - Summary Statistics: Mean Vector, Covariance, Correlation - Thu 27 Aug 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L2STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/02_L2_SummaryStatistics_Aug27.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#  The mean vector
# --------------------------------------------------------------------------

wh <- read.csv("data/worldhealth2022.csv", row.names = 1)
W  <- wh[, 4:11]          # the eight numeric indicators; cols 1-3 are labels
n  <- nrow(W); p <- ncol(W)
c(n = n, p = p)

round(colMeans(W), 2)          # the sample mean vector

# --------------------------------------------------------------------------
#  The covariance matrix, once by hand
# --------------------------------------------------------------------------

X <- matrix(c(2, 8,
              4, 9,
              4, 11,
              6, 12), ncol = 2, byrow = TRUE)   # byrow: fill row by row
colMeans(X)
cov(X)          # divides by n - 1

cor(X)

# --------------------------------------------------------------------------
#  S on the real data - and why it will not answer our question
# --------------------------------------------------------------------------

round(diag(cov(W)), 1)         # the eight sample variances

round(cov(W[, c("life_exp", "infant_mort", "gdp_pc")]), 1)

# --------------------------------------------------------------------------
#  R, and the answer to today's question
# --------------------------------------------------------------------------

options(width = 100)     # 8 columns do not fit R's default width of 80
round(cor(W), 2)

# --------------------------------------------------------------------------
#    A matrix you can look at
# --------------------------------------------------------------------------

library(corrplot)
corrplot.mixed(cor(W), upper = "ellipse", lower = "number")

# --------------------------------------------------------------------------
#    What "scale-free" does and does not mean (read at home; Home Exercise 3)
# --------------------------------------------------------------------------

cor(W$gdp_pc,        W$internet_pct)
cor(W$gdp_pc / 1000, W$internet_pct)   # a = 1/1000, positive
cor(-W$gdp_pc,       W$internet_pct)   # a = -1,     negative

# --------------------------------------------------------------------------
#  One number for the whole spread: the generalized variance
# --------------------------------------------------------------------------

det(cov(W))     # generalized variance of the raw data
det(cor(W))     # the same thing for the standardised data
