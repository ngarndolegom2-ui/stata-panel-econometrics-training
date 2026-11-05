*==============================================================================
* 04_fgls.do : feasible generalised least squares (FGLS)
* Corrects for heteroskedasticity across countries and, in the second model,
* for country-specific first-order autocorrelation.
*==============================================================================

use "$root/training_data.dta", clear
xtset id Time
estimates clear

* Heteroskedastic panels
xtgls lnDettesExt lnRN $controls, panels(heteroskedastic)
est store eq1

* Heteroskedastic panels and panel-specific AR(1) autocorrelation
* (force: the panel is unbalanced, with gaps in some series)
xtgls lnDettesExt lnRN $controls, panels(heteroskedastic) corr(psar1) force
est store eq2

outreg2 [eq*] using "$root/table_fgls", dec(3) replace excel
