# Panel data econometrics in Stata and R – training session

Teaching material based on a training session I gave to Master 2 students in Economics at the Laboratoire d'Analyse et de Recherche en Économie Mathématique (LAREM), University of N'Djamena, Chad, on 22 June 2026, as part of their thesis preparation. Every model is provided in **Stata** (do-files) and in **R** (`panel_training.R`, free software).

**Author:** NGARNDOLEGOM GOD-FOIS TOG-ASRA · [ORCID 0009-0002-8884-6109](https://orcid.org/0009-0002-8884-6109)

## Running example

All methods are applied to one question: **do natural resource rents raise external debt in Sub-Saharan Africa?** The data are a panel of 48 countries over 1990–2021 from the World Bank's World Development Indicators (CC BY 4.0), the same data as my Master's thesis ([replication repository](https://github.com/ngarndolegom2-ui/resource-dependence-debt-ssa)).

| Variable | Definition |
|---|---|
| `lnDettesExt` | Log of external debt stocks (% of GNI) |
| `lnRN` | Log of total natural resource rents (% of GDP) |
| `lnPIB` | Log of GDP per capita (constant 2015 US$) |
| `OuvertureC` | Trade openness (% of GDP) |
| `IDE` | Foreign direct investment, net inflows (% of GDP) |

## Contents of the session

| File | Method | What students learn |
|---|---|---|
| `01_prepare_data.do` | Data preparation | Declaring a panel (`xtset`) before any panel command |
| `02_pooled_ols.do` | Pooled OLS | The benchmark, and why it ignores the panel structure |
| `03_fixed_random_effects.do` | Fixed and random effects, Hausman test | Controlling for unobserved country characteristics |
| `04_fgls.do` | Feasible GLS | Heteroskedasticity and autocorrelation across panels |
| `05_driscoll_kraay.do` | Driscoll-Kraay standard errors | Common shocks across countries (cross-sectional dependence) |
| `06_instrumental_variables.do` | IV-2SLS and IV-GMM | Endogeneity, instrument strength and the Hansen test |
| `07_quantile_regressions.do` | Quantile regressions | Effects that differ across the distribution |
| `08_figure.do` | Scatter plot of country means | Using `collapse` safely, inside `preserve`/`restore` |

## How to run

**Stata**
1. Download this repository (green **Code** button, then **Download ZIP**) and unzip it.
2. Open `00_master.do` and set `global root` to the unzipped folder.
3. Run `00_master.do`. It installs the SSC packages (`outreg2`, `xtscc`, `ivreg2`, `ranktest`) and writes all tables to the same folder.

**R** (free: [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/))
1. Open `panel_training.R` and set `root` to the unzipped folder.
2. Run the whole script. It installs the packages (`plm`, `lmtest`, `sandwich`, `AER`, `nlme`, `quantreg`, `haven`), writes all results to `results_R.txt` and the figure to `figure_rents_debt_R.png`.

| Method | Stata | R |
|---|---|---|
| Fixed / random effects, Hausman | `xtreg, fe` / `xtreg, re` / `hausman` | `plm()` / `phtest()` |
| FGLS | `xtgls` | `nlme::gls()` with `varIdent` and `corAR1` |
| Driscoll-Kraay | `xtscc` | `plm::vcovSCC()` |
| IV | `ivreg2` | `AER::ivreg()` |
| Quantile regressions | `qreg` | `quantreg::rq()` |

## Licence

Code: MIT licence (see `LICENSE`). Data: World Bank, CC BY 4.0.
