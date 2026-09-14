## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  Lecture 5 - the script that draws the figures printed in the lecture PDF
##
##  Open STAT481.Rproj first, then run this file top to bottom; it reads
##  data/... and writes its PDF(s) into figures/ of this project.
##
##  GENERATED COPY of the instructor's RProject/R/L5_figures.R (14 Sep 2026):
##  only the output folder was rewritten for this project.  Edit the source,
##  not this copy.
## ==========================================================================

dir.create("figures", showWarnings = FALSE)
# ═══════════════════════════════════════════════════════════════════════════
#  STAT 481 — Fall 2026 — Lecture 5, "Distance"
#  Builds the six-panel heat-map figure printed in L5STAT481Fall2026.tex.
#  Run from the course project root (RProject/).  Deterministic, no seed.
#
#  v3, 2 Sep 2026: the ellipse figure and its build block were REMOVED with
#  L5's ellipse section (second instructor pass).  If a later lecture wants
#  the d^2 ellipse picture, rebuild it there — the 31 Aug version survives
#  in git history.
#
#  figures/L5_heatmaps6.pdf — one fixed 15-country order (Qatar first) in
#  EVERY panel; one colour scale PER panel (the six distances have different
#  units, so colours are comparable only within a panel, never across).
#  pheatmap is told cluster_rows = FALSE, cluster_cols = FALSE: by default it
#  would reorder each panel separately and destroy the comparison.
#  The one-panel snippet printed in the .tex is the `sub` + pheatmap() call
#  below, without the size cosmetics.
# ═══════════════════════════════════════════════════════════════════════════

library(pheatmap)

FIG <- "figures"

wh <- read.csv("data/worldhealth2022.csv", row.names = 1)   # 175 x 11
X  <- as.matrix(wh[, 4:11])
rownames(X) <- wh$country

sub <- c("Qatar", "United Arab Emirates", "Kuwait", "Bahrain", "Oman",
         "Saudi Arabia", "Singapore", "Switzerland", "Luxembourg",
         "Norway", "Japan", "Italy", "Croatia", "Afghanistan",
         "Somalia, Fed. Rep.")   # one fixed order, used by every panel

shrt <- c("Qatar", "UAE", "Kuwait", "Bahrain", "Oman", "Saudi Ar.",
          "Singapore", "Switzerl.", "Luxemb.", "Norway", "Japan",
          "Italy", "Croatia", "Afghan.", "Somalia")

D_euc  <- dist(X)
D_city <- dist(X, method = "manhattan")
D_cheb <- dist(X, method = "maximum")
D_std  <- dist(scale(X))
D_cor  <- as.dist(1 - cor(t(X)))
D_mah  <- dist(X %*% solve(chol(cov(X))))

panel <- function(D, title) {
  m <- as.matrix(D)[sub, sub]         # SAME order in every panel
  rownames(m) <- colnames(m) <- shrt
  pheatmap(m, cluster_rows = FALSE, cluster_cols = FALSE,
           main = title, fontsize = 7, fontsize_row = 7,
           fontsize_col = 7, angle_col = 45, border_color = NA,
           legend = TRUE, silent = TRUE)$gtable
}

ps <- list(panel(D_euc,  "Euclidean (straight-line)"),
           panel(D_city, "City-block (Manhattan)"),
           panel(D_cheb, "Chebyshev (largest gap)"),
           panel(D_std,  "Standardised Euclidean"),
           panel(D_cor,  "Correlation distance"),
           panel(D_mah,  "Mahalanobis (statistical)"))

pdf(file.path(FIG, "L5_heatmaps6.pdf"), width = 12.0, height = 7.6)
gridExtra::grid.arrange(grobs = ps, ncol = 3)
dev.off()

cat("wrote", file.path(FIG, "L5_heatmaps6.pdf"), "\n")
cat("panel order:", paste(shrt, collapse = " | "), "\n")
