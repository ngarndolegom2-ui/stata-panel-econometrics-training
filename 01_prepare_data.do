*==============================================================================
* 01_prepare_data.do : builds the training dataset
* Data: World Bank WDI, 48 Sub-Saharan African countries, 1990-2021
* Question used as running example: do natural resource rents raise external debt?
*==============================================================================

use "$root/ssa_panel_1990_2021_raw.dta", clear

capture drop id
egen id = group(CountryName)
xtset id Time        // declare the panel BEFORE any panel command

gen lnDettesExt = log(ExternaldebtstocksofGNI)       // external debt (% of GNI)
gen lnRN        = log(Totalnaturalresourcesrents)    // natural resource rents (% of GDP)
gen lnPIB       = log(GDPpercapitaconstant2015US)    // GDP per capita
gen OuvertureC  = TradeofGDPNETRDGNFSZS              // trade openness (% of GDP)
gen IDE         = Foreigndirectinvestmentneti        // FDI net inflows (% of GDP)

global controls "lnPIB OuvertureC IDE"

save "$root/training_data.dta", replace
