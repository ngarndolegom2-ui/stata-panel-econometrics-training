*==============================================================================
* 06_instrumental_variables.do : instrumental variables
* Resource rents may be endogenous (reverse causality, omitted variables).
* Instruments: first and second lags of lnRN.
*==============================================================================

use "$root/training_data.dta", clear
xtset id Time
estimates clear

* IV-2SLS, robust standard errors, full first-stage diagnostics
ivreg2 lnDettesExt $controls (lnRN = L.lnRN L2.lnRN), robust ffirst
est store eq1

* Two-step efficient GMM
ivreg2 lnDettesExt $controls (lnRN = L.lnRN L2.lnRN), gmm2s robust ffirst
est store eq2

* How to read the diagnostics:
* - Instrument strength: Kleibergen-Paap rk Wald F statistic. Above about 10
*   (Stock-Yogo rule of thumb), the instruments are not weak.
* - Hansen J test (two instruments, one endogenous variable): H0 = instruments
*   are valid. A p-value below 0.05 rejects H0: at least one instrument is
*   correlated with the error term, and the IV estimates must be read with caution.
* - Lagged regressors are valid instruments only if the shocks to debt are not
*   serially correlated; this is the main weakness of internal instruments.

outreg2 [eq*] using "$root/table_iv", dec(3) replace excel
