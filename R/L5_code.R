## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 5 - Distance - Thu 3 Sep 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L5STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/05_L5_Distance_Sep03.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#    Now in R: one column, then two, then three
# --------------------------------------------------------------------------

library(pheatmap)             # draws a distance matrix as a heat map
wh <- read.csv("data/worldhealth2022.csv", row.names = 1)   # Lecture 2
X  <- as.matrix(wh[, 4:11])   # the eight indicators -- Lecture 3's X
rownames(X) <- wh$country     # country NAMES, so every ranking below reads
dim(X)

v  <- X[, "pop65"]            # ONE column: % of population aged 65+
d1 <- abs(v - v["Qatar"])     # the gap to Qatar, sign dropped
sort(d1)[2:3]                 # the two closest; no. 1 is Qatar itself
sort(d1, decreasing = TRUE)[1:2]     # and the two farthest

w <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
all(w$country == wh$country)  # same 175 rows, same order?
P2 <- cbind(pop65 = v, pop0014 = w$pop0014)  # same UNIT: % of population
rownames(P2) <- wh$country
m2 <- as.matrix(dist(P2))     # every pairwise distance, as a table
sort(m2["Qatar", ])[2:3]      # two closest
sort(m2["Qatar", ], decreasing = TRUE)[1]    # and the farthest

P3 <- cbind(P2, gdp_pc = X[, "gdp_pc"])      # add DOLLARS to percentages
m3 <- as.matrix(dist(P3))
sort(m3["Qatar", ])[2:3]
round(P3[c("Qatar", "Singapore", "United Arab Emirates"), ], 2)

# --------------------------------------------------------------------------
#    The six, one at a time
# --------------------------------------------------------------------------

D_euc <- dist(X)              # ALL pairwise straight-line distances
m_euc <- as.matrix(D_euc)     # the same thing as a 175 x 175 table
sort(m_euc["Qatar", ])[2:4]   # nearest three; no. 1 is Qatar itself

D_city <- dist(X, method = "manhattan")
m_city <- as.matrix(D_city)
sort(m_city["Qatar", ])[2:4]

D_cheb <- dist(X, method = "maximum")
m_cheb <- as.matrix(D_cheb)
sort(m_cheb["Qatar", ])[2:4]

Z <- scale(X)                 # every column: mean 0, sd 1 (Worksheet 3)
D_std <- dist(Z)              # the SAME dist() call, on the rescaled table
m_std <- as.matrix(D_std)
sort(m_std["Qatar", ])[2:4]

D_cor <- as.dist(1 - cor(t(X)))   # t(X): rows and columns swapped
m_cor <- as.matrix(D_cor)
sort(m_cor["Qatar", ])[2:4]

XW <- X %*% solve(chol(cov(X)))   # uncorrelated columns, equal spread
D_mah <- dist(XW)                 # then the straight line, as usual
m_mah <- as.matrix(D_mah)
sort(m_mah["Qatar", ])[2:4]

# --------------------------------------------------------------------------
#    All six on one page
# --------------------------------------------------------------------------

sub <- c("Qatar", "United Arab Emirates", "Kuwait", "Bahrain", "Oman",
         "Saudi Arabia", "Singapore", "Switzerland", "Luxembourg",
         "Norway", "Japan", "Italy", "Croatia", "Afghanistan",
         "Somalia, Fed. Rep.")   # one fixed order, used by every panel
pheatmap(m_euc[sub, sub], cluster_rows = FALSE, cluster_cols = FALSE)

# --------------------------------------------------------------------------
#  Euclidean against Mahalanobis: same or different?
# --------------------------------------------------------------------------

c(euclidean   = names(sort(m_euc["Qatar", ]))[2],
  mahalanobis = names(sort(m_mah["Qatar", ]))[2])

c(whitened_squared = m_mah["Qatar", "United Arab Emirates"]^2,
  mahalanobis = mahalanobis(X["Qatar", ], X["United Arab Emirates", ],
                            cov(X)))

c(section_2 = m_std["Qatar", "United Arab Emirates"],
  recipe    = sqrt(sum((X["Qatar", ] - X["United Arab Emirates", ])^2 /
                       diag(cov(X)))))

Zr <- t(scale(t(X)))          # scale each ROW -- each country's profile
R  <- cor(t(X))               # correlation between two countries' rows
c(gap_squared = sum((Zr["Qatar", ] - Zr["United Arab Emirates", ])^2),
  formula     = 2 * (8 - 1) * (1 - R["Qatar", "United Arab Emirates"]))
max(abs(as.matrix(dist(Zr))^2 - 2 * (8 - 1) * (1 - R)))

# --------------------------------------------------------------------------
#    When can Euclidean and Mahalanobis be the same?
# --------------------------------------------------------------------------

U  <- cbind(a = c(1, 2, 3, 4), b = c(1, -1, -1, 1))
Z0 <- scale(U)                # mean 0, sd 1 -- and cor(a, b) is exactly 0
round(cov(Z0), 10)            # the covariance matrix is the identity
max(abs(dist(Z0) - dist(Z0 %*% solve(chol(cov(Z0))))))

V <- U; V[, "b"] <- U[, "a"] + U[, "b"]  # put correlation back in
cor(V)[1, 2]
max(abs(dist(scale(V)) - dist(V %*% solve(chol(cov(V))))))
max(abs(D_std - D_mah))                  # and on the real 175 countries

# --------------------------------------------------------------------------
#    Step 1 - look at the columns before computing anything
# --------------------------------------------------------------------------

round(apply(X, 2, sd), 2)     # workflow step 1: every column's spread

# --------------------------------------------------------------------------
#    Step 2 - columns in one unit: the plain distances are fine
# --------------------------------------------------------------------------

Xp <- X[, c("pop65", "urban_pct", "health_exp_pct", "internet_pct")]
mp <- as.matrix(dist(Xp))     # four columns, all in percent
sort(mp["Qatar", ])[2:4]

# --------------------------------------------------------------------------
#    Step 4 - hunting unusual units when columns move together
# --------------------------------------------------------------------------

P <- X[, c("gdp_pc", "pop65")]           # two columns, dollars + percent
sel <- c("Qatar", "Singapore", "United Arab Emirates", "Croatia")
round(cbind(P[sel, ], d2 = mahalanobis(P, colMeans(P), cov(P))[sel]), 2)
mean(P[, "gdp_pc"])                      # the world average income

d2p <- mahalanobis(P, colMeans(P), cov(P))    # from the centre, all 175
eup <- sqrt(rowSums(sweep(P, 2, colMeans(P))^2))
c(straight_line = rank(-eup)[["Croatia"]], by_d2 = rank(-d2p)[["Croatia"]])

# --------------------------------------------------------------------------
#  Problems to try at home - all in R
# --------------------------------------------------------------------------

ind  <- w[, 5:56]                    # the 52 indicators of whwide2022
keep <- colSums(is.na(ind)) == 0     # complete for all 175 countries
W <- as.matrix(ind[, keep]); rownames(W) <- w$country
dim(W)

v12 <- c(colnames(X), "mobile", "gdp_growth", "death_rate", "birth_rate")
W12 <- W[, v12]                      # a set checked to be safe for d^2
