## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 7 - Directions in the Data - Tue 15 Sep 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L7STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/07_L7_DirectionsInTheData_Sep15.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

options(digits = 4)
w <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)  # L6
X <- as.matrix(w[, c("pop0014", "pop65", "life_exp", "gdp_pc")])
X[, "gdp_pc"] <- X[, "gdp_pc"] / 1000   # income in THOUSAND US$
colnames(X)[4] <- "gdp_k"
rownames(X) <- w$country
n <- nrow(X); p <- ncol(X)
Xc <- scale(X, center = TRUE, scale = FALSE)   # centred data, L6
S  <- cov(X)                                   # = t(Xc) %*% Xc/(n-1)
round(S, 2)

Sa <- matrix(c(1, 0.5, 0.5, 1), 2)           # two variables, r = 0.5
a  <- c(1, 1)                                # their sum
t(a) %*% Sa %*% a                            # 1 + 1 + 2 * 0.5

a <- c(1, 1, 0, 0)            # young share + old share
y <- X %*% a                  # one new number per country
c(var_y = var(y), quad_form = t(a) %*% S %*% a)
b <- c(1, -1, 0, 0)           # young share - old share
c(var_diff = var(X %*% b), quad_form = t(b) %*% S %*% b)
u3 <- c(0, 0, 1, 0)           # the third variable alone
c(var_life = var(X %*% u3), quad_form = t(u3) %*% S %*% u3)
c(cov_sum_diff = cov(X %*% a, X %*% b), a_S_b = t(a) %*% S %*% b)

yc <- Xc %*% a                # the centred new variable
all.equal(as.vector(yc), as.vector(y - mean(y)))
sum(yc^2) / (n - 1)           # its variance, from the centred column

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

A2 <- matrix(c(3, -sqrt(2), -sqrt(2), 2), 2)   # J&W Example 2.11
qf <- function(x, A) as.numeric(t(x) %*% A %*% x)
c(x_10 = qf(c(1, 0), A2), x_11 = qf(c(1, 1), A2),
  x_12 = qf(c(1, 2), A2))
B2 <- matrix(c(1, -5, -5, 1), 2)               # J&W Example 2.9
c(x_10 = qf(c(1, 0), B2), x_11 = qf(c(1, 1), B2))

set.seed(481)
A <- matrix(rnorm(5000 * p), nrow = 5000)      # 5000 random directions
A <- A / sqrt(rowSums(A^2))                    # every row: unit length
q <- apply(A, 1, function(a) t(a) %*% S %*% a) # 5000 quadratic forms
c(smallest = min(q), largest = max(q))

X5 <- cbind(X, dep = X[, "pop0014"] + X[, "pop65"])   # L6, Section 6
S5 <- cov(X5)
a0 <- c(1, 1, 0, 0, -1)       # young + old - dep: a constant column
c(var_a0 = var(X5 %*% a0), quad_form = t(a0) %*% S5 %*% a0)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

ev2 <- eigen(A2)              # J&W Example 2.11, by hand: 4 and 1
ev2
e1 <- ev2$vectors[, 1]
c(A_e1 = A2 %*% e1, lambda_e1 = ev2$values[1] * e1)
c(A_neg_e1 = A2 %*% (-e1), lambda_neg_e1 = ev2$values[1] * (-e1))

ev     <- eigen(S)
lambda <- ev$values
E      <- ev$vectors
for (j in 1:p)                # sign rule: largest entry of each e_j > 0
  if (E[which.max(abs(E[, j])), j] < 0) E[, j] <- -E[, j]
dimnames(E) <- list(colnames(X), paste0("e", 1:p))
lambda
round(E, 3)

colSums(E^2)                  # every eigenvector has length 1
zapsmall(t(E) %*% E)          # and they are perpendicular: E'E = I
max(abs(S %*% E[, 1] - lambda[1] * E[, 1]))    # S e1 - lambda_1 e1

Z <- Xc %*% E                 # the four new variables, one per column
colnames(Z) <- paste0("z", 1:p)
zapsmall(cov(Z))
c(var_z1 = var(Z[, 1]), lambda_1 = lambda[1])
round(Z[c("Qatar", "Japan", "Niger"), ], 2)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

A3 <- matrix(c(2.2, 0.4, 0.4, 2.8), 2)         # J&W Result 2A.14
ev3 <- eigen(A3); ev3$values
piece1 <- ev3$values[1] * ev3$vectors[, 1] %*% t(ev3$vectors[, 1])
piece2 <- ev3$values[2] * ev3$vectors[, 2] %*% t(ev3$vectors[, 2])
piece1; piece2
all.equal(piece1 + piece2, A3)

S_back <- E %*% diag(lambda) %*% t(E)         # E Lambda E'
all.equal(S_back, S, check.attributes = FALSE)
S_sum <- matrix(0, p, p)
for (i in 1:p) S_sum <- S_sum + lambda[i] * E[, i] %*% t(E[, i])
all.equal(S_sum, S, check.attributes = FALSE)

c(sum_lambda = sum(lambda), trace_S = sum(diag(S)))
c(prod_lambda = prod(lambda), det_S = det(S))
round(lambda / sum(lambda), 3)               # share of total variance

lambda5 <- eigen(S5)$values   # the five-column table of Section 2
lambda5
c(prod_lambda = prod(lambda5), det_S5 = det(S5))   # L6, Section 8

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

P2  <- Xc[, c("pop0014", "pop65")]           # two centred columns, in %
S2  <- cov(P2)
ev_2 <- eigen(S2); lam2 <- ev_2$values; E2 <- ev_2$vectors
for (j in 1:2)
  if (E2[which.max(abs(E2[, j])), j] < 0) E2[, j] <- -E2[, j]
round(S2, 2); lam2; round(E2, 3)
c(half_length_1 = sqrt(lam2[1]), half_length_2 = sqrt(lam2[2]))

eigen(solve(S2))$values       # the book's A = S^{-1}: its eigenvalues
1 / rev(lam2)

three <- c("Niger", "Japan", "Qatar")
dE <- sqrt(rowSums(P2^2))                    # straight line from centre
dM <- sqrt(mahalanobis(P2, center = c(0, 0), cov = S2))
round(cbind(P2, d_E = dE, d_M = dM)[three, ], 2)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

A_half <- ev2$vectors %*% diag(sqrt(ev2$values)) %*% t(ev2$vectors)
round(A_half, 4)
all.equal(A_half %*% A_half, A2)

S_inv   <- E %*% diag(1 / lambda) %*% t(E)   # E Lambda^{-1} E'
all.equal(S_inv, solve(S), check.attributes = FALSE)
S_half  <- E %*% diag(sqrt(lambda)) %*% t(E) # E Lambda^{1/2} E'
S_ihalf <- E %*% diag(1 / sqrt(lambda)) %*% t(E)
round(S_half, 3)
all.equal(S_half %*% S_half, S, check.attributes = FALSE)
zapsmall(S_ihalf %*% S_half)                 # S^{-1/2} S^{1/2} = I
all.equal(S_ihalf %*% S_ihalf, S_inv)        # S^{-1/2} S^{-1/2} = S^-1
all.equal(expm::sqrtm(S), S_half, check.attributes = FALSE)

Zw <- Xc %*% S_ihalf          # every country, whitened
zapsmall(cov(Zw))             # covariance matrix = identity
d2_w <- rowSums(Zw^2)         # squared Euclidean length, whitened
all.equal(d2_w, mahalanobis(X, center = colMeans(X), cov = S))
d2_w["Qatar"]                 # L6, Section 9: 26.57
max(abs(dist(Zw) - dist(Xc %*% solve(chol(S)))))   # L5's whitening line

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

th <- 30 * pi / 180                          # L6, Section 10
Q  <- matrix(c(cos(th), sin(th), -sin(th), cos(th)), 2)
Y  <- P2 %*% Q                               # the pair, turned 30 deg
rbind(before = eigen(cov(P2))$values, after = eigen(cov(Y))$values)
round(cov(Y), 2)
all.equal(mahalanobis(Y, c(0, 0), cov(Y)), mahalanobis(P2, c(0, 0), S2))

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

c(largest_random = max(q), lambda_1 = lambda[1])
c(smallest_random = min(q), lambda_4 = lambda[4])
c(at_e1 = t(E[, 1]) %*% S %*% E[, 1],
  at_e4 = t(E[, 4]) %*% S %*% E[, 4])

# --------------------------------------------------------------------------
#  Warm-up
# --------------------------------------------------------------------------

M <- matrix(c(2, 1, 1, 2), 2)
eigen(M)$values
sum(eigen(M)$values); sum(diag(M))
prod(eigen(M)$values); det(M)
eigen(diag(c(5, 2)))
e <- eigen(M)$vectors[, 1]; t(e) %*% M %*% e

# --------------------------------------------------------------------------
#  Problems to try at home - all in R
# --------------------------------------------------------------------------

U <- as.matrix(w[, c("birth_rate", "death_rate", "internet_pct")])
rownames(U) <- w$country
