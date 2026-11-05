*==============================================================================
* Panel data econometrics in Stata - training session for Master 2 students
* LAREM, University of N'Djamena, 22 June 2026
* Author: NGARNDOLEGOM GOD-FOIS TOG-ASRA
*
* 00_master.do : runs the whole session, file by file
*==============================================================================

clear all
set more off

* --- 1. Path to the folder containing all the files -----------------------------
global root "C:/Users/YOURNAME/Documents/stata-panel-econometrics-training"

* --- 2. Packages (run once) ------------------------------------------------------
foreach pkg in outreg2 xtscc ivreg2 ranktest {
    capture which `pkg'
    if _rc ssc install `pkg', replace
}

* --- 3. Session ------------------------------------------------------------------
do "$root/01_prepare_data.do"
do "$root/02_pooled_ols.do"
do "$root/03_fixed_random_effects.do"
do "$root/04_fgls.do"
do "$root/05_driscoll_kraay.do"
do "$root/06_instrumental_variables.do"
do "$root/07_quantile_regressions.do"
do "$root/08_figure.do"
