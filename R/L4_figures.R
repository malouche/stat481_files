## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  Lecture 4 - the script that draws the figures printed in the lecture PDF
##
##  Open STAT481.Rproj first, then run this file top to bottom; it reads
##  data/... and writes its PDF(s) into figures/ of this project.
##
##  GENERATED COPY of the instructor's RProject/R/L4_figures.R (14 Sep 2026):
##  only the output folder was rewritten for this project.  Edit the source,
##  not this copy.
## ==========================================================================

dir.create("figures", showWarnings = FALSE)
# ═══════════════════════════════════════════════════════════════════════════
#  STAT 481 — Fall 2026 — Lecture 4, "Seeing Multivariate Data"
#  Builds every figure printed in L4STAT481Fall2026.tex.
#  Run from the course project root (RProject/), R 4.6.1.
#  Written 29 Aug 2026 for the depth upgrade (prompt D1).  Deterministic:
#  the simulation is seeded, so the figures regenerate byte-for-byte.
# ═══════════════════════════════════════════════════════════════════════════

library(GGally); library(ggplot2); library(corrplot); library(palmerpenguins)

FIG <- "figures"

## ---- data ---------------------------------------------------------------
wh <- read.csv("data/worldhealth2022.csv", row.names = 1)   # 176 x 8 spine
w  <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)  # 176 x 52
X  <- w[, 5:56]
n  <- nrow(X); p <- ncol(X)

## ---- FIGURE 1 : ggpairs on four of the eight spine indicators -----------
v4 <- c("life_exp", "infant_mort", "gdp_pc", "health_exp_pct")
g1 <- ggpairs(wh[, v4],
              lower = list(continuous = wrap("points", size = 0.55,
                                             alpha = 0.75)),
              upper = list(continuous = wrap("cor", stars = FALSE,
                                             size = 3.2))) +
      theme(axis.text = element_text(size = 5.4),
            axis.text.x = element_text(angle = 45, hjust = 1),
            strip.text = element_text(size = 7))
ggsave(file.path(FIG, "L4_ggpairs4.pdf"), g1, width = 6.4, height = 5.2)

## ---- FIGURE 1b : the SAME display at p = 52, so the room sees it fail ----
# base pairs(), not ggpairs(): ggpairs on 52 columns takes minutes and the
# point is legibility, not styling.  2704 cells, 1326 distinct pairs.
pdf(file.path(FIG, "L4_pairs52.pdf"), width = 7.0, height = 7.0)
par(cex = 0.25)
pairs(X, pch = ".", gap = 0, cex.labels = 0.30, oma = c(1.2, 1.2, 1.2, 1.2))
dev.off()

## ---- FIGURE 2 : the grouped display, penguins ---------------------------
pg <- na.omit(penguins[, c("species", "bill_length_mm", "bill_depth_mm",
                           "flipper_length_mm", "body_mass_g")])
# 2a — the SAME four columns with no group information at all: the diagonal is
#      the only warning the display gives you.
g2a <- ggpairs(pg, columns = 2:5,
               lower = list(continuous = wrap("points", size = 0.55,
                                              alpha = 0.75)),
               upper = list(continuous = wrap("cor", stars = FALSE,
                                              size = 3.2))) +
       theme(axis.text = element_text(size = 5.4), strip.text = element_text(size = 7))
ggsave(file.path(FIG, "L4_penguins_plain.pdf"), g2a, width = 5.6, height = 4.4)

# 2b — the same call with the labels switched on
# legend = c(2, 1): take the guide from the panel in row 2, column 1 (a scatter
# panel, so it carries BOTH the shade and the shape) and show it once, at the
# bottom.  ggpairs draws no legend at all unless you ask for one.
g2 <- ggpairs(pg, columns = 2:5,
              mapping = aes(colour = species, shape = species),
              upper = list(continuous = wrap("cor", stars = FALSE,
                                             colour = "black", size = 2.6)),
              legend = c(2, 1)) +
      scale_colour_manual(values = c("grey15", "grey45", "grey70")) +
      scale_fill_manual(values   = c("grey15", "grey45", "grey70")) +
      theme(text = element_text(size = 7.5),
            legend.position = "bottom", legend.title = element_blank(),
            legend.key.size = unit(3.4, "mm"))
ggsave(file.path(FIG, "L4_penguins_ggpairs.pdf"), g2, width = 6.4, height = 5.3)

## ---- FIGURE 3 : the noise floor, and the real panel against it ----------
set.seed(481)
maxr <- replicate(500, {
  Z <- matrix(rnorm(n * p), nrow = n)
  max(abs(cor(Z)[upper.tri(diag(p))]))
})
R  <- cor(X, use = "pairwise.complete.obs")
rv <- abs(R[upper.tri(R)])
floor_r <- median(maxr)

pdf(file.path(FIG, "L4_noisefloor.pdf"), width = 7.2, height = 3.1)
op <- par(mfrow = c(1, 2), mar = c(4.0, 4.0, 2.4, 0.8), cex = 0.72)
hist(maxr, breaks = 22, col = "grey80", border = "grey35",
     main = paste(n, "rows of pure noise, 52 columns"),
     xlab = expression(paste("largest ", group("|", r, "|"),
                             " among the 1326 pairs")), ylab = "repeats")
abline(v = floor_r, lwd = 2, lty = 2)
text(floor_r, par("usr")[4] * 0.92, sprintf(" median %.3f", floor_r),
     adj = 0, cex = 0.95)
hist(rv, breaks = seq(0, 1, by = 0.025), col = "grey80", border = "grey35",
     main = "the real panel: 1326 correlations",
     xlab = expression(paste(group("|", r, "|"), " in whwide2022")),
     ylab = "pairs")
abline(v = floor_r, lwd = 2, lty = 2)
text(floor_r, par("usr")[4] * 0.92,
     sprintf(" %.0f%% of pairs to the left", 100 * mean(rv <= floor_r)),
     adj = 0, cex = 0.95)
par(op); dev.off()

## ---- FIGURE 4 : the 52 x 52 heat map, ordered by indicator family -------
fam <- list(
  "health"     = c("life_exp","infant_mort","health_exp_pct","death_rate",
                   "birth_rate","fertility"),
  "population" = c("pop0014","pop1564","pop65","dep_ratio","dep_old",
                   "dep_young","pop_tot","pop_grow","net_migr"),
  "settlement" = c("urban_pct","rural_pct","urb_grow","lgst_city","pop_dens",
                   "land_area","agri_land","arable","forest"),
  "education"  = c("prim_enr","sec_enr","ter_enr","prim_compl","educ_exp"),
  "ICT"        = c("internet_pct","mobile","broadband","fixedline"),
  "economy"    = c("gdp_pc","gni_pc","gdp_growth","inflation"),
  "sectors"    = c("agri_va","ind_va","manuf_va","serv_va","capform",
                   "cons_hh","cons_gov","tax_rev"),
  "trade/fin"  = c("exports","imports","trade","credit_priv","fdi"),
  "transport"  = c("air_pax","air_dep"))
ord <- unlist(fam, use.names = FALSE)
stopifnot(setequal(ord, names(X)), length(ord) == 52)
Rf  <- R[ord, ord]

grey_ramp <- colorRampPalette(c("black","grey45","grey85","white",
                                "grey85","grey45","black"))(200)
# THE KEY (added 30 Aug 2026 — the instructor asked why there was no legend).
# corrplot's own colour bar (cl.pos = "b") is useless here because the ramp is
# SYMMETRIC: r = -0.9 and r = +0.9 are the same shade, and the sign is carried
# by the tilt, which a colour bar cannot show.  So the key is drawn by hand in
# a second layout panel, in two halves: a shade ramp for |r|, and two ellipse
# icons for the sign.  The icons are drawn BY corrplot on a 2 x 2 matrix, so
# their tilt is guaranteed to match the tilt in the picture above.
# NB corrplot's own `mar` argument calls par(mar = ...) itself, so the icon is
# shrunk by padding it here, not by setting par(mar) before the call.
icon <- function(r) {
  m <- matrix(c(1, r, r, 1), 2); dimnames(m) <- list(c("a","b"), c("a","b"))
  corrplot(m, method = "ellipse", type = "upper", diag = FALSE, tl.pos = "n",
           cl.pos = "n", col = grey_ramp, addgrid.col = NA,
           mar = c(2.0, 3.0, 0.4, 3.0))
}
pdf(file.path(FIG, "L4_corrheat.pdf"), width = 7.0, height = 7.9)
layout(matrix(c(1,1,1,1, 2,2,3,4), 2, 4, byrow = TRUE), heights = c(1, 0.175))
corrplot(Rf, method = "ellipse", type = "full", col = grey_ramp,
         tl.col = "black", tl.cex = 0.42, tl.srt = 90,
         cl.pos = "n",
         addgrid.col = "grey88", outline = FALSE, mar = c(0, 0, 0, 0))
# family separators: corrplot's full layout runs x = 1..p left to right and
# y = p..1 top to bottom, so block [a, b] is the rectangle below.
cuts <- cumsum(sapply(fam, length))
starts <- c(1, head(cuts, -1) + 1)
for (i in seq_along(fam))
  rect(starts[i] - 0.5, p - cuts[i] + 0.5, cuts[i] + 0.5, p - starts[i] + 1.5,
       border = "black", lwd = 1.3)

# --- panel 2 of the layout: the shade half of the key ---
par(mar = c(1.4, 3.2, 0.6, 1.0))
plot.new(); plot.window(xlim = c(0, 100), ylim = c(0, 10))
gr <- colorRampPalette(c("white", "grey85", "grey45", "black"))(120)
for (i in seq_len(120)) rect((i-1)/1.2, 5, i/1.2, 9.4, col = gr[i], border = NA)
rect(0, 5, 100, 9.4, border = "grey40", lwd = 0.7)
text(0,   3.2, "|r| = 0", adj = 0, cex = 0.8)
text(100, 3.2, "|r| = 1", adj = 1, cex = 0.8)
text(50,  0.8, "SHADE  =  strength", cex = 0.95, font = 2)
# --- panels 3 and 4: the tilt half ---
icon( 0.88); mtext("TILT = positive", side = 1, line = 0.6, cex = 0.72, font = 2)
icon(-0.88); mtext("TILT = negative", side = 1, line = 0.6, cex = 0.72, font = 2)
dev.off()

cat("figures written to", normalizePath(FIG), "\n")
