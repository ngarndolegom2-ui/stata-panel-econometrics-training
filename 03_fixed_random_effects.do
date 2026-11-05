*==============================================================================
* 03_fixed_random_effects.do : fixed effects, random effects and Hausman test
* Fixed effects remove everything that is constant within a country (geology, history,
* slowly changing institutions). Random effects assume these country effects are
* uncorrelated with the regressors; the Hausman test checks this assumption.
*==============================================================================

use "$root/training_data.dta", clear
xtset id Time
estimates clear

* Fixed effects (within estimator)
xtreg lnDettesExt lnRN $controls, fe
est store fe

* Random effects (GLS)
xtreg lnDettesExt lnRN $controls, re
est store re

* Hausman test. H0: country effects are uncorrelated with the regressors,
* so random effects are consistent and efficient.
* Reading rule: if Prob>chi2 < 0.05, H0 is rejected and fixed effects are preferred.
hausman fe re

* Preferred specification: fixed effects with year dummies, which absorb shocks
* common to all countries (e.g. commodity price cycles), and standard errors
* clustered by country.
xtreg lnDettesExt lnRN $controls i.Time, fe vce(cluster id)
est store fe_year

outreg2 [fe re fe_year] using "$root/table_fe_re", dec(3) keep(lnRN $controls) replace excel
