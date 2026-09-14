## ==========================================================================
##  STAT 481 - Multivariate Analysis - Qatar University - Fall 2026
##  Lecture 7 - the script that draws the figures printed in the lecture PDF
##
##  Open STAT481.Rproj first, then run this file top to bottom; it reads
##  data/... and writes its PDF(s) into figures/ of this project.
##
##  GENERATED COPY of the instructor's RProject/R/L7_figures.R (14 Sep 2026):
##  only the output folder was rewritten for this project.  Edit the source,
##  not this copy.
## ==========================================================================

dir.create("figures", showWarnings = FALSE)
# R/L7_figures.R -- the one figure of Lecture 7: the Mahalanobis contour
# on two centred columns of whwide2022 (pop0014, pop65), with the
# eigenvector axes.  Run from the STAT481.Rproj project root:
#   callr::r(function() source("R/L7_figures.R"))
# Writes figures/L7_ellipse.pdf
# Base graphics + car::ellipse() (car is in the package ledger).
options(digits = 4)
w  <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
X  <- as.matrix(w[, c("pop0014", "pop65")]); rownames(X) <- w$country
P2 <- scale(X, center = TRUE, scale = FALSE)   # centred, both in %
S2 <- cov(P2)
ev <- eigen(S2); lam <- ev$values; E2 <- ev$vectors
for (j in 1:2)
  if (E2[which.max(abs(E2[, j])), j] < 0) E2[, j] <- -E2[, j]
three <- c("Niger", "Japan", "Qatar")

pdf("figures/L7_ellipse.pdf",
    width = 6.6, height = 5.2)
par(mar = c(4.2, 4.4, 1, 1), family = "sans")
plot(P2, asp = 1, pch = 16, cex = 0.55, col = "grey55",
     xlab = "pop0014, centred (percentage points)",
     ylab = "pop65, centred (percentage points)",
     xlim = c(-30, 30), ylim = c(-16, 30))
abline(h = 0, v = 0, col = "grey80", lty = 3)
car::ellipse(center = c(0, 0), shape = S2, radius = 1, add = TRUE,
             center.pch = FALSE, col = "black", lwd = 2, lty = 1)
car::ellipse(center = c(0, 0), shape = S2, radius = 2, add = TRUE,
             center.pch = FALSE, col = "black", lwd = 2, lty = 2)
for (i in 1:2) {
  arrows(0, 0,  sqrt(lam[i]) * E2[1, i],  sqrt(lam[i]) * E2[2, i],
         length = 0.10, lwd = 2.5)
  arrows(0, 0, -sqrt(lam[i]) * E2[1, i], -sqrt(lam[i]) * E2[2, i],
         length = 0.10, lwd = 2.5)
}
text(sqrt(lam[1]) * E2[1, 1] + 1.5, sqrt(lam[1]) * E2[2, 1] - 1.2,
     expression(sqrt(lambda[1]) * bold(e)[1]), cex = 0.95)
segments(sqrt(lam[2]) * E2[1, 2], sqrt(lam[2]) * E2[2, 2], 5.2, 6.3,
         col = "grey40", lwd = 0.8)                 # leader to the label
text(6.2, 7.3, expression(sqrt(lambda[2]) * bold(e)[2]), cex = 0.95)
points(P2[three, ], pch = 21, bg = "white", col = "black", cex = 1.4, lwd = 1.5)
text(P2[three, 1], P2[three, 2], labels = three, pos = c(4, 4, 1),
     offset = 0.6, font = 2, cex = 0.9)
legend("topright", bty = "n", cex = 0.85,
       legend = c("one country (centred)", expression(d[M] == 1),
                  expression(d[M] == 2),
                  expression("axes: " %+-% sqrt(lambda[i]) * bold(e)[i]),
                  "the three countries of the table"),
       pch = c(16, NA, NA, NA, 21), pt.bg = c(NA, NA, NA, NA, "white"),
       col = c("grey55", "black", "black", "black", "black"),
       lty = c(NA, 1, 2, 1, NA), lwd = c(NA, 2, 2, 2.5, 1.5))
dev.off()
cat("wrote figures/L7_ellipse.pdf\n")
