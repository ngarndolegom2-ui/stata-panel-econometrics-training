*==============================================================================
* 02_pooled_ols.do : pooled OLS, the benchmark
* Ignores the panel structure: every country-year is treated as independent.
* Robust (heteroskedasticity-consistent) standard errors.
*==============================================================================

use "$root/training_data.dta", clear
xtset id Time
estimates clear

* Bivariate model
reg lnDettesExt lnRN, vce(robust)
est store eq1

* With controls
reg lnDettesExt lnRN $controls, vce(robust)
est store eq2

outreg2 [eq*] using "$root/table_ols", dec(3) replace excel
