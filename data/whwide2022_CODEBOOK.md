# `whwide2022` — codebook

The **wide companion** to the spine. `data/whwide2022.csv`, the *same* 176
countries in the *same row order*, measured on **52** indicators instead of 8.
Introduced in Lecture 4.

```r
w <- read.csv("data/whwide2022.csv", stringsAsFactors = FALSE)
dim(w)            # 176  56   (4 label columns + 52 indicators)
X <- w[, 5:56]    # the 52 indicators
```

Columns 1-4 are `iso3`, `country`, `region`, `income`. **Columns 5-12 are the
eight spine indicators, unchanged** — so anything that differs between this file
and `worldhealth2022` is a fact about the method you used, not about the sample.

## Provenance

World Bank Open Data, reference year **2022**, built 27 Aug 2026 and **frozen**.
Same rule as the spine: never re-pull it.

## The nine indicator families

| family | n | examples |
|---|---|---|
| health and mortality | 6 | `life_exp`, `infant_mort`, `birth_rate` |
| population structure | 9 | `pop0014`, `pop65`, `dep_ratio` |
| settlement and land | 9 | `urban_pct`, `pop_dens`, `forest` |
| education | 5 | `prim_enr`, `ter_enr`, `educ_exp` |
| communications | 4 | `internet_pct`, `mobile`, `broadband` |
| economy | 4 | `gdp_pc`, `gni_pc`, `inflation` |
| sectors of the economy | 8 | `agri_va`, `serv_va`, `tax_rev` |
| trade and finance | 5 | `exports`, `imports`, `fdi` |
| transport | 2 | `air_pax`, `air_dep` |

The full list of World Bank indicator codes is in the file's header row; every
name follows the spine's naming style.

## Two properties that are there on purpose

**1. Missing values: 6.5% of cells, and they are not filled in.**

```r
mean(is.na(X))                 # 0.0648
sum(complete.cases(X))         # 41 countries are complete on all 52
```

The more indicators you insist on, the fewer countries you may use. That
trade-off is a teaching object, not a flaw. It is also why `cor()` on this
table needs `use = "pairwise.complete.obs"` — without it, every entry involving
a column that has a missing value comes back `NA`.

**2. Four exact linear dependencies.**

| identity | columns |
|---|---|
| age bands sum to 100 | `pop0014 + pop1564 + pop65` |
| settlement shares sum to 100 | `rural_pct + urban_pct` |
| trade is a definition | `exports + imports = trade` |
| the dependency ratio is a sum | `dep_old + dep_young = dep_ratio` |

These are deliberate. A panel in which some columns are exactly determined by
others lets you see rank deficiency happen **for a reason you can name**,
rather than as a numerical accident. A fifth relation nearly holds:
`agri_va + ind_va + serv_va` lands between 80.6 and 111.0 rather than exactly
100, because value added excludes taxes less subsidies and the three shares are
published independently. An identity that *nearly* holds is worse than one that
holds exactly — it leaves the matrix invertible and the inverse meaningless.
