## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 1 - Organising Multivariate Data - Tue 25 Aug 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L1STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/01_L1_OrganisingMultivariateData_Aug25.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#    Load the data, and ask it its shape
# --------------------------------------------------------------------------

library(HSAUR2)          # make the HSAUR2 package's contents available
data("USairpollution")   # load the data set into this R session
dim(USairpollution)      # how many rows, how many columns?

# --------------------------------------------------------------------------
#    Ask it what the columns are
# --------------------------------------------------------------------------

str(USairpollution)      # "structure": what type is each column?

# --------------------------------------------------------------------------
#    Ask it to show you the top of the table
# --------------------------------------------------------------------------

head(USairpollution, 4)  # the first 4 rows

# --------------------------------------------------------------------------
#    Reach into the table: one row, one column, one cell
# --------------------------------------------------------------------------

USairpollution["Albuquerque", ]        # one row: all 7 variables, one city

USairpollution["Phoenix", "precip"]   # one cell: both names given

which.max(USairpollution$SO2)   # which row holds the largest SO2?
rownames(USairpollution)[7]     # so ask for the 7th row name

rownames(USairpollution)[which.max(USairpollution$SO2)]
max(USairpollution$SO2)

# --------------------------------------------------------------------------
#    Put a column in order: sort(), order(), rank()
# --------------------------------------------------------------------------

# Albany, Albuquerque, Atlanta, Baltimore, Buffalo
v <- USairpollution$SO2[1:5]
v

sort(v)    # the VALUES, rearranged smallest to largest
order(v)   # the POSITIONS, in the order that would sort v
rank(v)    # for each value, WHERE IT STANDS -- left where it was

head(USairpollution[order(-USairpollution$SO2), ], 3)   # the three worst

x <- c(7, 2, 9, 2)
x
rank(x)

so2 <- USairpollution$SO2                 # a bare column: no names attached
names(so2) <- rownames(USairpollution)    # give it the city names
wind <- USairpollution$wind
names(wind) <- rownames(USairpollution)

sum(so2 == 10)             # how many cities tie at 10 ...
rank(so2)[so2 == 10]       # ... and the HALF an even-sized tie gives
rank(wind)[wind == 10.9]   # an odd-sized tie: a WHOLE number, still a tie

n  <- nrow(USairpollution)
rd <- rank(-so2)                   # rank 1 = LARGEST (the Section 1 end)
rd["Chicago"]
all.equal(rd, n + 1 - rank(so2))   # the same thing, computed two ways

a <- c(3, 9, 2)
b <- c(5, 1, 8)
sum(a, b)    # one number
a + b        # one per position -- and nobody finds this surprising
min(a, b)    # one number
pmin(a, b)   # one per position -- the same idea, for minima

r <- 1:7
rbind(r = r, "8 - r" = 8 - r, e = pmin(r, 8 - r))

# --------------------------------------------------------------------------
#  One picture, before we have any formula
# --------------------------------------------------------------------------

plot(USairpollution$temp, USairpollution$precip,
     xlab = "average annual temperature (F)",
     ylab = "average annual rainfall (inches)")
