*==============================================================================
* 07_quantile_regressions.do : quantile regressions
* Does the effect of resource rents differ between low-debt and high-debt
* country-years? Compare the coefficient of lnRN across quantiles.
*==============================================================================

use "$root/training_data.dta", clear
estimates clear

qreg lnDettesExt lnRN $controls, quantile(0.10)
est store q10

qreg lnDettesExt lnRN $controls, quantile(0.25)
est store q25

qreg lnDettesExt lnRN $controls, quantile(0.50)
est store q50

qreg lnDettesExt lnRN $controls, quantile(0.75)
est store q75

qreg lnDettesExt lnRN $controls, quantile(0.90)
est store q90

* How to read the results: if the coefficient of lnRN rises with the quantile,
* resource rents matter more where debt is already high.

outreg2 [q*] using "$root/table_quantile", dec(3) replace excel
