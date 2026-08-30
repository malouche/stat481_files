# `worldhealth2022` — codebook

The **course spine** data set. `data/worldhealth2022.csv`, 176 countries by 8
numeric indicators plus 4 labels. Used from Lecture 1 onward.

```r
wh <- read.csv("data/worldhealth2022.csv", row.names = 1)
dim(wh)          # 176  11   -- row.names = 1 consumes iso3, so 11 columns
W  <- wh[, 4:11] # the 8 numeric indicators (1-3 are country, region, income)
```

## Provenance

World Bank Open Data, indicator API v2 (`https://api.worldbank.org/v2`),
reference year **2022**, pulled 18 Aug 2026. Rows are the World Bank's
*countries* only — regional and income aggregates ("Arab World", "OECD
members", ...) are dropped. Only countries complete on all eight indicators are
kept, which is why n = 176 and not 217.

**The CSV is frozen and you should never replace it with a fresh API pull.** The
World Bank revises past years, so a re-pull would silently change numbers that
the lecture notes print.

## The columns

| column | World Bank code | meaning | units |
|---|---|---|---|
| `life_exp` | `SP.DYN.LE00.IN` | Life expectancy at birth | years |
| `infant_mort` | `SP.DYN.IMRT.IN` | Infant mortality rate | per 1,000 live births |
| `fertility` | `SP.DYN.TFRT.IN` | Total fertility rate | births per woman |
| `pop65` | `SP.POP.65UP.TO.ZS` | Population aged 65 and over | % of total |
| `urban_pct` | `SP.URB.TOTL.IN.ZS` | Urban population | % of total |
| `gdp_pc` | `NY.GDP.PCAP.CD` | GDP per capita | current US$ |
| `health_exp_pct` | `SH.XPD.CHEX.GD.ZS` | Current health expenditure | % of GDP |
| `internet_pct` | `IT.NET.USER.ZS` | Individuals using the Internet | % of population |

Label columns: `iso3` (also the row names), `country`, `region`, `income` (the
World Bank income group).

## Two things to know before you compute anything

- **The units are deliberately mixed.** Years, dollars, births per woman and
  percentages sit in the same table. `gdp_pc` alone carries essentially all of
  the total variance, so a covariance analysis of all eight columns at once is
  meaningless. That is not a defect in the data; it is the reason Lecture 2
  spends its time on the difference between **S** and **R**.
- **One row is extreme and it is not an error.** The Central African Republic
  is reported with `life_exp` 18.8 years and `infant_mort` 206.8. Both are the
  World Bank's own published 2022 values. **Do not "clean" them.** What to do
  with a row like that is a question the course returns to.

## Missing values

None. Every one of the 176 countries has all eight indicators; that is the
selection rule that produced the file.
