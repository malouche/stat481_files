## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  LECTURE 4 - Seeing Multivariate Data - Tue 1 Sep 2026
##
##  Every line below is printed on the lecture PDF, in the same order.
##  Open STAT481.Rproj first, then run this file top to bottom; the
##  relative paths (data/...) resolve from the project root.
##
##  GENERATED FILE - extracted from L4STAT481Fall2026.tex by
##  make_lecture_scripts.py.  Edit the lecture, not this copy.
##  Mirrors 01_lectures/04_L4_SeeingMultivariateData_Sep01.pdf
## ==========================================================================

source("R/setup.R")   # reports any package this lecture needs

# --------------------------------------------------------------------------
#  The data today
# --------------------------------------------------------------------------

wh <- read.csv("data/worldhealth2022.csv", row.names = 1)  # 176 x 8
w  <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
dim(w)                       # 176 countries, 4 labels + 52 indicators

# --------------------------------------------------------------------------
#  Drawing one, and what it shows that R does not
# --------------------------------------------------------------------------

library(GGally)
ggpairs(wh[, c("life_exp", "infant_mort", "gdp_pc", "health_exp_pct")],
        upper = list(continuous = wrap("cor", stars = FALSE)))

cor(wh$life_exp, wh$gdp_pc)
cor(wh$life_exp, log(wh$gdp_pc))

wh[order(wh$life_exp)[1:2], c("country", "life_exp", "infant_mort")]
wh[order(-wh$gdp_pc)[1:2],  c("country", "life_exp", "gdp_pc")]

# --------------------------------------------------------------------------
#  The second thing: when the groups are labelled
# --------------------------------------------------------------------------

library(palmerpenguins)
pg <- na.omit(penguins[, c("species", "bill_length_mm", "bill_depth_mm",
                           "flipper_length_mm", "body_mass_g")])
ggpairs(pg, columns = 2:5,
        upper = list(continuous = wrap("cor", stars = FALSE)))

ggpairs(pg, columns = 2:5,
        mapping = aes(colour = species, shape = species),
        upper = list(continuous = wrap("cor", stars = FALSE)))

cor(pg$bill_depth_mm, pg$flipper_length_mm)          # all 342 pooled
sapply(split(pg, pg$species),                        # one per species
       function(d) cor(d$bill_depth_mm, d$flipper_length_mm))

# --------------------------------------------------------------------------
#  The same plot on 52 indicators
# --------------------------------------------------------------------------

X <- w[, 5:56]                    # the 52 indicators
pairs(X, pch = ".", gap = 0)      # the same display, 52 columns wide

p <- ncol(w) - 4
p * (p - 1) / 2              # distinct panels in the grid
p * (p - 1) / 2 * 10 / 60    # minutes, at ten seconds a panel

# --------------------------------------------------------------------------
#    What the biggest correlation would be if nothing were related
# --------------------------------------------------------------------------

set.seed(481)
maxr <- replicate(500, {
  Z <- matrix(rnorm(176 * 52), nrow = 176)   # 52 unrelated columns
  max(abs(cor(Z)[upper.tri(diag(52))]))      # the biggest of the 1326
})
summary(maxr)

# --------------------------------------------------------------------------
#    What the biggest correlations actually are
# --------------------------------------------------------------------------

R  <- cor(w[, 5:56], use = "pairwise.complete.obs")
rv <- abs(R[upper.tri(R)])
mean(rv <= median(maxr))     # share inside the noise floor
sum(rv > median(maxr))       # and how many survive it

idx <- which(upper.tri(R), arr.ind = TRUE)   # arr.ind: row and column
top <- data.frame(v1 = rownames(R)[idx[, 1]],
                  v2 = colnames(R)[idx[, 2]],
                  r  = R[upper.tri(R)])
head(top[order(-abs(top$r)), ], 8)

# --------------------------------------------------------------------------
#    What to draw instead
# --------------------------------------------------------------------------

library(corrplot)
fam <- c(  # the codebook's nine indicator families, in codebook order
 "life_exp","infant_mort","health_exp_pct","death_rate","birth_rate",
 "fertility","pop0014","pop1564","pop65","dep_ratio","dep_old",
 "dep_young","pop_tot","pop_grow","net_migr","urban_pct","rural_pct",
 "urb_grow","lgst_city","pop_dens","land_area","agri_land","arable",
 "forest","prim_enr","sec_enr","ter_enr","prim_compl","educ_exp",
 "internet_pct","mobile","broadband","fixedline","gdp_pc","gni_pc",
 "gdp_growth","inflation","agri_va","ind_va","manuf_va","serv_va",
 "capform","cons_hh","cons_gov","tax_rev","exports","imports","trade",
 "credit_priv","fdi","air_pax","air_dep")
corrplot(R[fam, fam], method = "ellipse", tl.cex = 0.42)

# --------------------------------------------------------------------------
#  The other margin: one picture per country
# --------------------------------------------------------------------------

spine8 <- c("life_exp", "infant_mort", "fertility", "pop65",
            "urban_pct", "gdp_pc", "health_exp_pct", "internet_pct")
mena <- w$region == "Middle East, North Africa, Afghanistan & Pakistan"
M <- w[mena, spine8]
rownames(M) <- w$country[mena]
stars(M[order(rownames(M)), ], nrow = 4, ncol = 5,
      draw.segments = FALSE)   # one star per country, eight rays

# --------------------------------------------------------------------------
#    The arrangement is not part of the data
# --------------------------------------------------------------------------

stars(M[order(M$gdp_pc), ], nrow = 4, ncol = 5, draw.segments = FALSE)
round(M[order(M$gdp_pc), c("gdp_pc", "pop65")][12:19, ], 1)

# --------------------------------------------------------------------------
#  Appendix - four more displays (required reading, not optional)
# --------------------------------------------------------------------------

library(GGally); library(seriation); library(aplpack)
w  <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
wh <- read.csv("data/worldhealth2022.csv", row.names = 1)
spine8 <- c("life_exp", "infant_mort", "fertility", "pop65",
            "urban_pct", "gdp_pc", "health_exp_pct", "internet_pct")
mena <- w$region == "Middle East, North Africa, Afghanistan & Pakistan"
M <- w[mena, spine8]; rownames(M) <- w$country[mena]
short <- c("Egypt, Arab Rep." = "Egypt", "Iran, Islamic Rep." = "Iran",
           "United Arab Emirates" = "UAE", "West Bank and Gaza" = "Palestine")
j <- rownames(M) %in% names(short)          # so the printed names and the
rownames(M)[j] <- short[rownames(M)[j]]     # figure labels are the same
c(countries = nrow(M), indicators = ncol(M))

# --------------------------------------------------------------------------
#    Parallel coordinates - the rows, at any n
# --------------------------------------------------------------------------

ggparcoord(data.frame(wh[, spine8], income = wh$income),
           columns = 1:8, groupColumn = "income",
           scale = "std", alphaLines = 0.5)

# --------------------------------------------------------------------------
#    Andrews curves - the glyph that carries a meaning
# --------------------------------------------------------------------------

andrews_curves <- function(X, t = seq(-pi, pi, length.out = 721)) {
  Z <- scale(X)                       # unitless, or gdp_pc owns the curve
  p <- ncol(Z)
  B <- matrix(0, length(t), p)        # the Fourier basis, column by column
  B[, 1] <- 1 / sqrt(2)
  for (j in 2:p)
    B[, j] <- if (j %% 2 == 0) sin((j %/% 2) * t) else cos((j %/% 2) * t)
  list(t = t, f = Z %*% t(B), Z = Z)  # one ROW of f per country
}
ac <- andrews_curves(wh[, spine8])
dim(ac$f)

i <- which(rownames(wh) == "QAT"); k <- which(rownames(wh) == "CAF")
h <- diff(ac$t)[1]
wts <- c(0.5, rep(1, length(ac$t) - 2), 0.5)          # trapezoid rule
c(curve_L2   = sum(wts * (ac$f[i, ] - ac$f[k, ])^2) * h,
  pi_times_d = pi * sum((ac$Z[i, ] - ac$Z[k, ])^2))

# --------------------------------------------------------------------------
#    Glyphs in a computed order
# --------------------------------------------------------------------------

set.seed(481)                       # method = "TSP" is randomised
o <- get_order(seriate(dist(scale(M)), method = "TSP",
                       control = list(rep = 20)))
if (M$gdp_pc[o[1]] > M$gdp_pc[o[length(o)]]) o <- rev(o)   # poorest first
rownames(M)[o]

stars(M[o, ], nrow = 4, ncol = 5, draw.segments = FALSE)
faces(M[o, ], face.type = 0, nrow.plot = 2, ncol.plot = 10)

# --------------------------------------------------------------------------
#    The data heat map - both margins at once
# --------------------------------------------------------------------------

X52  <- w[, 5:56]
keep <- complete.cases(X52)      # 41 countries are complete on all 52
Z52  <- scale(X52[keep, fam])    # fam: the codebook order of L4 5.3
rownames(Z52) <- w$country[keep]
Z52[Z52 > 2.5] <- 2.5; Z52[Z52 < -2.5] <- -2.5     # clip the two extremes
dim(Z52)
heatmap(Z52, Rowv = NA, Colv = NA, scale = "none")   # NA = do not cluster
