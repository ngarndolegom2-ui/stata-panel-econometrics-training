*==============================================================================
* 08_figure.do : country averages of debt and resource rents
* collapse destroys the panel, so it is used inside preserve/restore,
* after all the estimations.
*==============================================================================

use "$root/training_data.dta", clear

preserve
collapse (mean) lnDettesExt lnRN, by(CountryName CountryCode)
twoway (lfit lnDettesExt lnRN) (scatter lnDettesExt lnRN, mlabel(CountryCode) mlabsize(vsmall)), ///
    xtitle("Log natural resource rents (% of GDP), country mean 1990-2021") ///
    ytitle("Log external debt (% of GNI), country mean") legend(off)
graph export "$root/figure_rents_debt.png", replace width(2000)
restore
