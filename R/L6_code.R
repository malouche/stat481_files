## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 6 - The Data Table as a Matrix - Sun 13 Sep 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L6STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/06_L6_DataTableAsMatrix_Sep13.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

options(digits = 4)
w <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)  # L5
X <- as.matrix(w[, c("pop0014", "pop65", "life_exp", "gdp_pc")])
X[, "gdp_pc"] <- X[, "gdp_pc"] / 1000   # income in THOUSAND US$
colnames(X)[4] <- "gdp_k"
rownames(X) <- w$country
dim(X)
round(X[c("Qatar", "Japan", "Niger"), ], 2)

n <- nrow(X); p <- ncol(X); c(n = n, p = p)
x1 <- X[, 1]                  # first COLUMN: one variable, 175 numbers
length(x1)
X["Qatar", ]                  # one ROW: one country, four numbers

A <- matrix(c(3, 1, -1, 5, 2, 4), nrow = 2)   # J&W Example 2.3, a 2 x 3
A
t(A)                          # rows become columns: a 3 x 2
dim(A); dim(t(A))

one  <- rep(1, n)             # the vector 1: n ones
xbar <- t(X) %*% one / n      # (1/n) X'1 -- a p x 1 column
t(xbar)                       # printed as a row to save space
colMeans(X)                   # the shortcut
all.equal(as.vector(xbar), unname(colMeans(X)))

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

B <- matrix(c(1, 0, 2, -1, 3, 1), nrow = 3)   # a 3 x 2
A %*% B                       # (2 x 3)(3 x 2) = 2 x 2
B %*% A                       # (3 x 2)(2 x 3) = 3 x 3: different
all.equal(t(A %*% B), t(B) %*% t(A))          # (AB)' = B'A'

u <- X[, "pop65"]; v <- X[, "life_exp"]      # two columns, 175 each
t(u) %*% v                    # inner product u'v: ONE number (a 1 x 1)
sum(u * v)                    # the same number, written as a sum
crossprod(u, v)               # the same again: R's name for t(u) %*% v
dim(u %*% t(v))               # outer product uv': a 175 x 175 table

round(crossprod(X))           # X'X: every column against every column

# ~~ added by make_lecture_scripts.py, NOT printed on the page: the lecture prints this call BECAUSE it fails (inner dimensions 3 and 2).
# ~~ try() only lets the file continue; the error still prints.
try({
  A %*% A                       # (2 x 3)(2 x 3): inner dimensions 3 and 2
})

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

H3 <- diag(3) - matrix(1, 3, 3) / 3          # I - (1/n) 11' for n = 3
H3
H3 %*% c(1, 2, 6)             # subtracts the mean 3 from every entry

H  <- diag(n) - matrix(1, n, n) / n          # 175 x 175 centring matrix
Xc <- H %*% X                 # every column minus its own mean
round(colMeans(Xc), 10)       # centred: every column mean is 0
S_hand <- t(Xc) %*% Xc / (n - 1)             # S = Xc'Xc / (n - 1)
round(S_hand, 3)
all.equal(S_hand, cov(X))

all.equal(H %*% H, H)         # centring twice = centring once
all.equal(Xc, scale(X, center = TRUE, scale = FALSE),
          check.attributes = FALSE)          # the shortcut

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

M  <- matrix(1, 2, 2); D2 <- diag(c(2, 10))
D2 %*% M                      # D on the LEFT: row i times d_i
M %*% D2                      # D on the RIGHT: column j times d_j
D2 %*% M %*% D2               # both sides: entry (i, j) times d_i * d_j

S    <- cov(X)
Dm12 <- diag(1 / sqrt(diag(S)))      # D^{-1/2}: 1/s_j on the diagonal
R_hand <- Dm12 %*% S %*% Dm12                # the sandwich
dimnames(R_hand) <- dimnames(S)
round(R_hand, 3)
all.equal(R_hand, cor(X))
D12 <- diag(sqrt(diag(S)))           # D^{1/2}: s_j on the diagonal
all.equal(D12 %*% cor(X) %*% D12, S, check.attributes = FALSE)
all.equal(cov(scale(X)), cor(X), check.attributes = FALSE)

Dd <- diag(c(1, 1, 1, 1000))  # income back to dollars, rest untouched
round((Dd %*% S %*% Dd)[4, ]) # the income row of S, in dollars
round(cov(X %*% Dd)[4, ])     # the same row, from the rescaled data
all.equal(cor(X %*% Dd), cor(X), check.attributes = FALSE)  # R unmoved

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

x <- c(1, 3, 2); y <- c(-2, 1, -1)           # J&W Example 2.1
Lx <- sqrt(sum(x^2)); Ly <- sqrt(sum(y^2))
c(Lx = Lx, Ly = Ly, cos_theta = sum(x * y) / (Lx * Ly))
acos(sum(x * y) / (Lx * Ly)) * 180 / pi      # the angle, in degrees

a <- Xc[, "pop0014"]; b <- Xc[, "pop65"]     # two CENTRED columns
c(length_sq = sum(a^2), n1_var = (n - 1) * var(X[, "pop0014"]))
cos_ab <- sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2)))
c(cos_theta = cos_ab, r = cor(X)["pop0014", "pop65"])
acos(cos_ab) * 180 / pi       # the angle between the two columns

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

M3 <- cbind(a = c(1, 2, 3), b = c(2, 4, 6))  # b = 2a: dependent
qr(M3)$rank
qr(cbind(a = c(1, 2, 3), b = c(2, 4, 7)))$rank   # change one entry

X5 <- cbind(X, dep = X[, "pop0014"] + X[, "pop65"])   # 5th col: a SUM
c(rank_X = qr(X)$rank, rank_Xc = qr(Xc)$rank, rank_X5 = qr(X5)$rank)
S5 <- cov(X5)
round(S5, 2)

X3 <- X[c("Qatar", "Kuwait", "Bahrain"), ]   # n = 3 countries, p = 4
qr(scale(X3, scale = FALSE))$rank            # centred: at most n - 1
qr(cov(X3))$rank                             # so S is 4 x 4 of rank 2

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

c(trace = sum(diag(S)), total_variance = sum(apply(X, 2, var)))
round(diag(S) / sum(diag(S)), 3)             # each column's share

S_a <- matrix(c(1, 0, 0, 1), 2); S_b <- matrix(c(1, 0.9, 0.9, 1), 2)
c(trace_a = sum(diag(S_a)), trace_b = sum(diag(S_b)))
c(cor_a = cov2cor(S_a)[1, 2], cor_b = cov2cor(S_b)[1, 2])
all.equal(sum(diag(A %*% B)), sum(diag(B %*% A)))   # tr(AB) = tr(BA)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

M2 <- matrix(c(3, 4, 2, 1), 2)               # J&W Example 2.8
M2
det(M2)                                      # 3 * 1 - 2 * 4
c(det_t = det(t(M2)), det_2M = det(2 * M2), det_MM = det(M2 %*% M2))

c(det_S = det(S), det_R = det(R_hand), ratio = det(S) / prod(diag(S)))

for (r in c(0, 0.5, 0.9, 0.99))
  cat("r =", r, "  |R| =", det(matrix(c(1, r, r, 1), 2)), "\n")

det(S5)                       # the 5-column S of Section 6

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

solve(M2)                     # J&W Example 2.8: the inverse
zapsmall(solve(M2) %*% M2)    # A^{-1} A = I (rounding dust set to 0)
solve(diag(c(2, 4, 5)))       # a diagonal matrix: invert the diagonal

S_inv <- solve(S)
round(S_inv, 4)
zapsmall(S_inv %*% S)         # S^{-1} S = I, tiny rounding set to 0

g <- X["Qatar", ] - colMeans(X)              # Qatar minus the mean
c(by_hand = t(g) %*% S_inv %*% g,
  mahalanobis = mahalanobis(X["Qatar", ], colMeans(X), S))
c(diagonal_S = mahalanobis(X["Qatar", ], colMeans(X), diag(diag(S))),
  std_euclid_sq = sum((g / sqrt(diag(S)))^2))

wh <- read.csv("data/worldhealth2022.csv", row.names = 1)   # Lecture 5
X8 <- as.matrix(wh[, 4:11]); rownames(X8) <- wh$country
d  <- X8["Qatar", ] - X8["United Arab Emirates", ]      # the gap vector
c(by_hand = t(d) %*% solve(cov(X8)) %*% d,
  L5 = mahalanobis(X8["Qatar", ], X8["United Arab Emirates", ],
                   cov(X8)))

# ~~ added by make_lecture_scripts.py, NOT printed on the page: the lecture prints this call BECAUSE it fails (S5 is singular).
# ~~ try() only lets the file continue; the error still prints.
try({
  solve(S5)                     # the singular S of Section 6
})

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

c(S = isSymmetric(S), R = isSymmetric(R_hand), Xc = isSymmetric(Xc))
th <- 30 * pi / 180                          # a rotation by 30 degrees
Q  <- matrix(c(cos(th), sin(th), -sin(th), cos(th)), 2)
round(Q, 3)
zapsmall(t(Q) %*% Q)                         # Q'Q = I: orthogonal

P <- Xc[, c("pop65", "life_exp")]            # two centred columns
Y <- P %*% Q                                 # every country, turned
c(trace_before = sum(diag(cov(P))), trace_after = sum(diag(cov(Y))))
c(det_before = det(cov(P)), det_after = det(cov(Y)))
max(abs(dist(P) - dist(Y)))                  # every distance: unchanged
round(cov(Y), 3)                             # but the covariance moved

# --------------------------------------------------------------------------
#  Warm-up
# --------------------------------------------------------------------------

W1 <- matrix(1:6, nrow = 2)
dim(W1)
dim(t(W1))
W1 %*% t(W1)
t(W1) %*% W1
diag(2) %*% W1

# --------------------------------------------------------------------------
#  Problems to try at home - all in R
# --------------------------------------------------------------------------

U <- as.matrix(w[, c("birth_rate", "death_rate", "mobile",
                     "internet_pct")])
rownames(U) <- w$country
