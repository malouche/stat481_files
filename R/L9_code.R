## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 9 - The Population Behind the Table - Sun 20 Sep 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L9STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/09_L9_PopulationBehindTheTable_Sep20.pdf
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
c(n = n, p = p)
X["Qatar", ]                  # one row = one realisation of the vector

x1 <- c(-1, 0, 1); p1 <- c(0.3, 0.3, 0.4)   # J&W Example 2.12
x2 <- c(0, 1);     p2 <- c(0.8, 0.2)
mu_tiny <- c(mu1 = sum(x1 * p1), mu2 = sum(x2 * p2))
mu_tiny

mu <- colMeans(X)             # the mean of ALL 175 rows: the population
round(mu, 3)
all.equal(as.vector(t(X) %*% rep(1, n) / n), as.vector(mu))  # L6 Sec.1
y_sum <- X[, "pop0014"] + X[, "pop65"]
c(mean_of_sum = mean(y_sum), sum_of_means = mu[[1]] + mu[[2]])

set.seed(481)
idx <- sample(n, 30)          # 30 row numbers, without replacement
Xs  <- X[idx, ]               # the sample: 30 countries, 4 columns
sort(rownames(Xs))
xbar <- colMeans(Xs)
round(rbind(mu = mu, xbar = xbar, gap = xbar - mu), 3)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

P12 <- matrix(c(0.24, 0.16, 0.40, 0.06, 0.14, 0.00), 3)  # J&W Ex. 2.13
dimnames(P12) <- list(x1 = c(-1, 0, 1), x2 = c(0, 1))
P12
p1 <- rowSums(P12); p2 <- colSums(P12)            # the marginals
m1 <- sum(x1 * p1); m2 <- sum(x2 * p2)            # the two means again
s11 <- sum((x1 - m1)^2 * p1)
s22 <- sum((x2 - m2)^2 * p2)
s12 <- sum(outer(x1 - m1, x2 - m2) * P12)         # every pair, weighted
Sigma_tiny <- matrix(c(s11, s12, s12, s22), 2)
Sigma_tiny

Xc    <- scale(X, center = TRUE, scale = FALSE)  # subtract mu, L6 Sec.3
Sigma <- crossprod(Xc) / n                       # divisor n: population
round(Sigma, 2)
all.equal(Sigma, cov(X) * (n - 1) / n, check.attributes = FALSE)
S30 <- cov(Xs)                                # the sample twin, 30 rows
round(S30, 2)

V_half <- diag(sqrt(diag(Sigma)))                 # standard deviations
rho    <- solve(V_half) %*% Sigma %*% solve(V_half)
dimnames(rho) <- dimnames(Sigma)
round(rho, 3)
all.equal(V_half %*% rho %*% V_half, Sigma, check.attributes = FALSE)
all.equal(rho, cor(X), check.attributes = FALSE)  # the same sandwich
round(cor(Xs), 3)                                 # R of the 30

Sigma3 <- matrix(c(4, 1, 2, 1, 9, -3, 2, -3, 25), 3)   # J&W Ex. 2.14
V3 <- diag(sqrt(diag(Sigma3))); V3
rho3 <- solve(V3) %*% Sigma3 %*% solve(V3)
round(rho3, 3)
all.equal(rho3, cov2cor(Sigma3))                  # L6, Section 4
all.equal(V3 %*% rho3 %*% V3, Sigma3)

lam_Sigma <- eigen(Sigma)$values
lam_S     <- eigen(cov(X))$values                # Lecture 7, Section 3
rbind(Sigma = lam_Sigma, S_scaled = lam_S * (n - 1) / n)
max(abs(abs(eigen(Sigma)$vectors) - abs(eigen(cov(X))$vectors)))
d2_S     <- mahalanobis(X, center = colMeans(X), cov = cov(X))
d2_Sigma <- mahalanobis(X, center = mu, cov = Sigma)
c(Qatar_S = d2_S[["Qatar"]], Qatar_Sigma = d2_Sigma[["Qatar"]],
  ratio = n / (n - 1))

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

x  <- c(-1, 0, 1); px <- c(1, 1, 1) / 3          # symmetric around 0
y  <- x^2                                        # y is a FUNCTION of x
c(E_x = sum(x * px), E_y = sum(y * px), E_xy = sum(x * y * px))
cov_xy <- sum(x * y * px) - sum(x * px) * sum(y * px)
cov_xy
c(P_x1_and_y1 = 1 / 3, P_x1_times_P_y1 = (1 / 3) * (2 / 3))

set.seed(481)
u <- runif(10000, -1, 1)      # 10 000 draws, symmetric around 0
c(cor_u_u2 = cor(u, u^2), cor_absu_u2 = cor(abs(u), u^2))

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

Sig2 <- matrix(c(4, 1, 1, 4), 2)                 # J&W Example 2.15
C2   <- rbind(diff = c(1, -1), sum = c(1, 1))
C2 %*% Sig2 %*% t(C2)

cvec <- c(1, 1, 0, 0)                            # young + old, L7 Sec.1
y <- X %*% cvec                                  # one number per row
c(c_mu = sum(cvec * mu), mean_y = mean(y))
c(c_Sigma_c = t(cvec) %*% Sigma %*% cvec,
  var_n = sum((y - mean(y))^2) / n)
b <- c(1, -1, 0, 0)                              # young - old
yb <- X %*% b
c(c_Sigma_c = t(b) %*% Sigma %*% b, var_n = sum((yb - mean(yb))^2) / n)

C <- rbind(sum = c(1, 1, 0, 0), diff = c(1, -1, 0, 0))   # 2 x 4
Z <- X %*% t(C)                                  # 175 x 2: both at once
rbind(C_mu = as.vector(C %*% mu), mean_Z = colMeans(Z))
C %*% Sigma %*% t(C)
crossprod(scale(Z, scale = FALSE)) / n           # Cov(Z), divisor n
all.equal(C %*% S30 %*% t(C), cov(Xs %*% t(C)))  # the sample twin
C %*% S30 %*% t(C)

E <- eigen(Sigma)$vectors                        # C = E', L7 Section 3
round(t(E) %*% Sigma %*% E, 2)                   # diagonal: Cov(Z)
round(lam_Sigma, 3)

# --------------------------------------------------------------------------
#    3. In R
# --------------------------------------------------------------------------

Sigma11 <- Sigma[1:2, 1:2]; Sigma12 <- Sigma[1:2, 3:4]
Sigma21 <- Sigma[3:4, 1:2]; Sigma22 <- Sigma[3:4, 3:4]
round(Sigma11, 2); round(Sigma12, 2)
round(Sigma22, 2)
all.equal(t(Sigma12), Sigma21)
all.equal(crossprod(Xc[, 1:2], Xc[, 3:4]) / n, Sigma12)   # definition
mu1 <- mu[1:2]; mu2 <- mu[3:4]
c(mu1, mu2)

Sigma_back <- rbind(cbind(Sigma11, Sigma12), cbind(Sigma21, Sigma22))
all.equal(Sigma_back, Sigma)
round(S30[1:2, 3:4], 2)                          # S_12 of the sample
round(cov2cor(Sigma)[1:2, 3:4], 3)               # rho_12

# --------------------------------------------------------------------------
#  The sample population table
# --------------------------------------------------------------------------

c(tr_Sigma = sum(diag(Sigma)), tr_S30 = sum(diag(S30)))
c(det_Sigma = det(Sigma), det_S30 = det(S30))
c(det_rho = det(rho), det_R30 = det(cor(Xs)))

# --------------------------------------------------------------------------
#  Warm-up
# --------------------------------------------------------------------------

mu_w <- c(1, 3); Sigma_w <- matrix(c(4, 2, 2, 9), 2)
cw <- c(1, -1)
sum(cw * mu_w); t(cw) %*% Sigma_w %*% cw
cov2cor(Sigma_w)
Cw <- rbind(c(1, 1), c(1, -1)); Cw %*% Sigma_w %*% t(Cw)
Vw <- diag(sqrt(diag(Sigma_w))); Vw %*% cov2cor(Sigma_w) %*% Vw

# --------------------------------------------------------------------------
#  Problems to try at home - all in R
# --------------------------------------------------------------------------

U <- as.matrix(w[, c("fertility", "infant_mort", "urban_pct")])
rownames(U) <- w$country
