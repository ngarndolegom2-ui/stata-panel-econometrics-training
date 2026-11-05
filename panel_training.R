# ==============================================================================
# Panel data econometrics - R version of the training session
# LAREM, University of N'Djamena (training session of 22 June 2026)
# Author: NGARNDOLEGOM GOD-FOIS TOG-ASRA
#
# Same models as the Stata do-files, estimated with free software.
# Running example: do natural resource rents raise external debt in
# Sub-Saharan Africa? (48 countries, 1990-2021, World Bank WDI)
# ==============================================================================

# --- 1. Path to the folder containing the files (change this line) ------------
root <- "C:/Users/YOURNAME/Documents/stata-panel-econometrics-training"
setwd(root)

# --- 2. Packages (installed automatically the first time) ---------------------
pkgs <- c("haven", "plm", "lmtest", "sandwich", "AER", "nlme", "quantreg")
for (p in pkgs) if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
invisible(lapply(pkgs, library, character.only = TRUE))

# All results are written to a text file
sink("results_R.txt", split = TRUE)

# --- 3. Data preparation -------------------------------------------------------
raw <- as.data.frame(read_dta("ssa_panel_1990_2021_raw.dta"))

safe_log <- function(x) ifelse(!is.na(x) & x > 0, log(x), NA)  # log(0) -> NA, as in Stata

df <- data.frame(
  country     = raw$CountryName,
  code        = raw$CountryCode,
  Time        = as.numeric(raw$Time),
  lnDettesExt = safe_log(raw$ExternaldebtstocksofGNI),     # external debt (% of GNI)
  lnRN        = safe_log(raw$Totalnaturalresourcesrents),  # resource rents (% of GDP)
  lnPIB       = safe_log(raw$GDPpercapitaconstant2015US),  # GDP per capita
  OuvertureC  = raw$TradeofGDPNETRDGNFSZS,                 # trade openness (% of GDP)
  IDE         = raw$Foreigndirectinvestmentneti            # FDI net inflows (% of GDP)
)

# Declare the panel (equivalent of xtset) before any panel command
pdf_ <- pdata.frame(df, index = c("country", "Time"))

# Lags of resource rents, respecting gaps in the time index (equivalent of L. and L2.)
pdf_$L1_lnRN <- plm::lag(pdf_$lnRN, 1)
pdf_$L2_lnRN <- plm::lag(pdf_$lnRN, 2)

f <- lnDettesExt ~ lnRN + lnPIB + OuvertureC + IDE

# --- 4. Pooled OLS (benchmark) ---------------------------------------------------
cat("\n===== 1. Pooled OLS, robust standard errors =====\n")
ols1 <- lm(lnDettesExt ~ lnRN, data = df)
ols2 <- lm(f, data = df)
print(coeftest(ols1, vcov = vcovHC(ols1, type = "HC1")))
print(coeftest(ols2, vcov = vcovHC(ols2, type = "HC1")))

# --- 5. Fixed effects, random effects, Hausman test ------------------------------
cat("\n===== 2. Fixed effects, random effects and Hausman test =====\n")
fe <- plm(f, data = pdf_, model = "within")
re <- plm(f, data = pdf_, model = "random")
print(summary(fe))
print(summary(re))

# H0: country effects uncorrelated with regressors (random effects consistent).
# If p < 0.05, H0 is rejected and fixed effects are preferred.
print(phtest(fe, re))

# Two-way fixed effects (country and year), standard errors clustered by country
fe2 <- plm(f, data = pdf_, model = "within", effect = "twoways")
print(coeftest(fe2, vcov = vcovHC(fe2, cluster = "group", type = "HC1")))

# --- 6. Feasible GLS: heteroskedastic panels ------------------------------------
cat("\n===== 3. FGLS =====\n")
df_gls <- na.omit(df[, c("country", "Time", all.vars(f))])
# Heteroskedasticity across countries
gls1 <- gls(f, data = df_gls, weights = varIdent(form = ~ 1 | country), method = "ML")
print(summary(gls1)$tTable)
# Heteroskedasticity across countries and AR(1) autocorrelation within countries
gls2 <- gls(f, data = df_gls, weights = varIdent(form = ~ 1 | country),
            correlation = corAR1(form = ~ Time | country), method = "ML")
print(summary(gls2)$tTable)

# --- 7. Driscoll-Kraay standard errors -------------------------------------------
cat("\n===== 4. Driscoll-Kraay standard errors (4 lags) =====\n")
pool <- plm(f, data = pdf_, model = "pooling")
print(coeftest(pool, vcov = vcovSCC(pool, maxlag = 4)))
print(coeftest(fe,   vcov = vcovSCC(fe,   maxlag = 4)))

# --- 8. Instrumental variables ----------------------------------------------------
cat("\n===== 5. IV-2SLS: lnRN instrumented by its first and second lags =====\n")
df_iv <- as.data.frame(pdf_)
df_iv[] <- lapply(df_iv, function(x) if (is.numeric(x)) as.numeric(x) else x)
iv <- ivreg(lnDettesExt ~ lnRN + lnPIB + OuvertureC + IDE |
              L1_lnRN + L2_lnRN + lnPIB + OuvertureC + IDE, data = df_iv)
# diagnostics: weak instruments (first-stage F), Wu-Hausman, Sargan
print(summary(iv, vcov = sandwich, diagnostics = TRUE))

# --- 9. Quantile regressions ------------------------------------------------------
cat("\n===== 6. Quantile regressions =====\n")
qr <- rq(f, data = df, tau = c(0.10, 0.25, 0.50, 0.75, 0.90))
print(summary(qr, se = "nid"))
# If the coefficient of lnRN rises with the quantile, rents matter more
# where debt is already high.

sink()

# --- 10. Figure: country means ------------------------------------------------------
means <- aggregate(cbind(lnDettesExt, lnRN) ~ country + code, data = df, FUN = mean)
png("figure_rents_debt_R.png", width = 2000, height = 1400, res = 200)
plot(means$lnRN, means$lnDettesExt, pch = 19, col = "grey40",
     xlab = "Log natural resource rents (% of GDP), country mean 1990-2021",
     ylab = "Log external debt (% of GNI), country mean")
abline(lm(lnDettesExt ~ lnRN, data = means), col = "steelblue", lwd = 2)
text(means$lnRN, means$lnDettesExt, labels = means$code, pos = 3, cex = 0.6)
dev.off()

cat("Done: results in results_R.txt, figure in figure_rents_debt_R.png\n")
