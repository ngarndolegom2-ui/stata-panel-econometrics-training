*==============================================================================
* 05_driscoll_kraay.do : Driscoll-Kraay standard errors
* Robust to heteroskedasticity, autocorrelation up to 4 lags and cross-sectional
* dependence: common shocks, such as commodity price cycles, hit all countries at once.
*==============================================================================

use "$root/training_data.dta", clear
xtset id Time
estimates clear

* Pooled OLS with Driscoll-Kraay standard errors
xtscc lnDettesExt lnRN $controls, lag(4)
est store eq1

* Fixed effects with Driscoll-Kraay standard errors
xtscc lnDettesExt lnRN $controls, fe lag(4)
est store eq2

outreg2 [eq*] using "$root/table_driscoll_kraay", dec(3) replace excel
