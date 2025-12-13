*i. for CEI_AAA
* Step 2: Normalize the 14 indicators (Min-Max Normalization)
* Define the 14 indicators
local indicators CE_MF CE_RP CE_MG CE_MR CE_ER CE_CR CE_TR CE_PI CE_GV CE_PE CE_PA CE_CF CE_GG CE_MD

* Normalize the indicators using Min-Max scaling
foreach var of local indicators {
    summarize `var', meanonly
    gen normm_`var' = (`var' - r(min)) / (r(max) - r(min))
}
* Step 3: Calculate the proportion matrix (g_ijt)
foreach var of local indicators {
    gen propp_`var' = normm_`var' / sum(normm_`var')
}
* Step 4: Compute entropy for each indicator
* Define constant k = 1 / ln(M)
local M = _N
local k = 1 / log(`M')

foreach var of local indicators {
    gen entropyy_`var' = -`k' * propp_`var' * log(propp_`var')
}

* Handle log(0) by replacing missing entropy values with 0
foreach var of local indicators {
    replace entropyy_`var' = 0 if propp_`var' == 0
}

* Step 5: Calculate the degree of divergence and weights
foreach var of local indicators {
    gen divergencee_`var' = 1 - entropyy_`var'
}

* Compute the total divergence
gen total_divergencee = 0
foreach var of local indicators {
    replace total_divergencee = total_divergencee + divergencee_`var'
}

* Calculate the weight of each indicator
foreach var of local indicators {
    gen weightt_`var' = divergencee_`var' / total_divergencee
}

* Step 6: Compute the Composite CEI_A index
gen CEI_AAA = 0
foreach var of local indicators {
    replace CEI_AAA = CEI_AAA + weightt_`var' * normm_`var'
}


*ii. CEI_CCC
* Step 1
egen z_CE_MF = std(CE_MF)
egen z_CE_RP = std(CE_RP)
egen z_CE_MG = std(CE_MG)
egen z_CE_ER = std(CE_ER)
egen z_CE_TR = std(CE_TR)
egen z_CE_PE = std(CE_PE)
egen z_CE_PA = std(CE_PA)
egen z_CE_CF = std(CE_CF)
egen z_CE_GG = std(CE_GG)

* Step 2: 
pca z_CE_MF z_CE_RP z_CE_MG z_CE_MR z_CE_ER z_CE_CR z_CE_TR z_CE_PI z_CE_GV z_CE_PE z_CE_PA z_CE_CF z_CE_GG z_CE* 

*Step 3: 

predict CEI_CCC, score

sum CEI_CCC
* Step 5: 
histogram CEI_CCC, normal

*Data Processing 
*DATA curation (Hidden)
* PRELIMINARY
*Descriptive analysis
asdoc sum weee_raw  CE_MF CE_MR CE_RP CE_MG CE_MR CE_ER CE_CR CE_TR CE_PI CE_GV CE_PE CE_PA CE_CF CE_GG CE_MD FD gdp_raw pds_raw rec_raw URB, star(all) replace nonum save(DES_01)
*Correlation analysis
asdoc pwcorr weee_raw  CE_MF CE_MF CE_RP CE_MG CE_MR CE_ER CE_CR CE_TR CE_PI CE_GV CE_PE CE_PA CE_CF CE_GG CE_MD FD gdp_raw pds_raw rec_raw URB,sig star(.05) obs bonferroni replace nonum save(CORR_01)
*Cross-dependence test 
xtcdf weee_raw CE_MF CE_RP CE_MG CE_MR CE_ER CE_CR CE_TR CE_PI CE_GV CE_PE CE_PA CE_CF CE_GG CE_MD FD gdp_raw pds_raw rec_raw URB  
*Unit root test 
xtunitroot fisher weee_raw, dfuller drift demean lag(0)
xtunitroot fisher CE_MF, dfuller drift demean lag(0)
xtunitroot fisher CE_MR, dfuller drift demean lag(0)
xtunitroot fisher CE_RP, dfuller drift demean lag(0)
xtunitroot fisher CE_MG, dfuller drift demean lag(0)
xtunitroot fisher CE_ER, dfuller drift demean lag(0)
xtunitroot fisher CE_CR, dfuller drift demean lag(0)
xtunitroot fisher CE_TR, dfuller drift demean lag(0)
xtunitroot fisher CE_PI, dfuller drift demean lag(0)
xtunitroot fisher CE_GV, dfuller drift demean lag(0)
xtunitroot fisher CE_PE, dfuller drift demean lag(0)
xtunitroot fisher CE_PA, dfuller drift demean lag(0)
xtunitroot fisher CE_CF, dfuller drift demean lag(0)
xtunitroot fisher CE_GG, dfuller drift demean lag(0)
xtunitroot fisher CE_MD, dfuller drift demean lag(0)
xtunitroot fisher FD, dfuller drift demean lag(0)
xtunitroot fisher gdp_raw, dfuller drift demean lag(0)
xtunitroot fisher pds_raw, dfuller drift demean lag(0)
xtunitroot fisher rec_raw, dfuller drift demean lag(0)
xtunitroot fisher URB, dfuller drift demean lag(0)

*VARYING EFFECTS
*FGLS 
(1) no balanced 
xtgls WEEE FD GDP PDS REC URB lnCE_MF, panels(heteroskedastic) force
est store gls1
(2)
xtgls WEEE lnCE_RP FD GDP PDS REC URB, panels(correlated) force
est store gls2
(3) no CD 
xtgls WEEE lnCE_MG FD GDP PDS REC URB, panels(heteroskedastic) force
est store gls3
(4) %
xtgls WEEE CE_MR FD GDP PDS REC URB, panels(correlated) force
est store gls4
(5) no CD
xtgls WEEE lnCE_ER FD GDP PDS REC URB ,corr(psar1) force
est store gls5
(6)  ! BỎ LOG 
xtgls WEEE CE_CR FD GDP PDS REC URB, panels(correlated) force
est store gls6
(7) 
xtgls WEEE lnCE_TR FD GDP PDS REC URB, panels(correlated) force
est store gls7
(8)  %
xtgls WEEE CE_PI FD GDP PDS REC URB, panels(correlated) force
est store gls8
(9) %
xtgls WEEE CE_GV FD GDP PDS REC URB, panels(correlated) force
est store gls9
(10)  
xtgls WEEE lnCE_PE FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store gls10
(11) no CD ! ; THAY BIẾN CŨ 
xtgls WEEE  CE_PAi  FD GDP PDS REC URB,   corr(independent) panels(heteroskedastic) force
est store gls11
(12)  
xtgls WEEE  lnCE_CF FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store gls12
(13)
xtgls WEEE lnCE_GG FD GDP PDS REC URB, panels(correlated) force
est store gls13
(14) 
xtgls WEEE CE_MD FD GDP PDS REC URB, panels(correlated) force 
est store gls14
esttab  gls1  gls2  gls3  gls4  gls5  gls6  gls7  gls8 gls9  gls10 gls11 gls12 gls13 gls14, star(* 0.1 ** 0.05 *** 0.01) replace


*PCSE
(1)
xtpcse WEEE FD GDP PDS REC URB  lnCE_MF
est store pcse1
(2)
xtpcse WEEE lnCE_RP FD GDP PDS REC URB 
est store pcse2
(3)
xtpcse WEEE lnCE_MG FD GDP PDS REC URB
est store pcse3
(4) %
xtpcse WEEE CE_MR FD GDP PDS REC URB , correlation(psar1) rhotype(tscorr) 
est store pcse4
(5) 
xtpcse WEEE lnCE_ER FD GDP PDS REC URB , het corr(psar1)
est store pcse5
(6) ! BỎ LOG 
xtpcse WEEE CE_CR FD GDP PDS REC URB 
est store pcse6
(7) 
xtpcse WEEE lnCE_TR FD GDP PDS REC URB
est store pcse7
(8) % 
xtpcse  WEEE CE_PI FD GDP PDS REC URB
est store pcse8
(9) %
xtpcse  WEEE CE_GV FD GDP PDS REC URB
est store pcse9
(10) 
xtpcse WEEE lnCE_PE FD GDP PDS REC URB, het corr(psar1)  
est store pcse10
(11) 
xtpcse WEEE  CE_PAi  FD GDP PDS REC URB
est store pcse11
(12)  THAY BIẾN CŨ 
xtpcse WEEE  lnCE_CF FD GDP PDS REC URB,  het correlation(psar1) rhotype(tscorr) 
est store pcse12
(13)
xtpcse WEEE lnCE_GG FD GDP PDS REC URB
est store pcse13
(14)
xtpcse WEEE CE_MD FD GDP PDS REC URB
est store pcse14
esttab  pcse1  pcse2  pcse3  pcse4  pcse5  pcse6  pcse7 pcse8 pcse9 pcse10 pcse11 pcse12 pcse13 pcse14, star(* 0.1 ** 0.05 *** 0.01) replace

*DIRECT EFFECTS
/ Base FGLS model for CEI_AAA
xtgls WEEE CEI_AAA FD GDP PDS REC URB
est store glsaaa1

// Heteroskedastic panels
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsaaa2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsaaa3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsaaa4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsaaa5

// Cross-sectionally correlated panels
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(correlated) force
est store glsaaa6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsaaa7

// Correlated panels with PSAR(1) correlation  ( TAKEN) 
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsaaa8

// Correlated panels with independent correlations
xtgls WEEE CEI_AAA FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsaaa9

// AR(1) correlation only
xtgls WEEE CEI_AAA FD GDP PDS REC URB, corr(ar1)
est store glsaaa10

// PSAR(1) correlation only
xtgls WEEE CEI_AAA FD GDP PDS REC URB, corr(psar1)
est store glsaaa11

// Independent correlations only
xtgls WEEE CEI_AAA FD GDP PDS REC URB, corr(independent)
est store glsaaa12

// Combine results from all models for CEI_AAA
esttab glsaaa1 glsaaa2 glsaaa3 glsaaa4 glsaaa5 glsaaa6 glsaaa7 glsaaa8 glsaaa9 glsaaa10 glsaaa11 glsaaa12, star(* 0.1 ** 0.05 *** 0.01) replace

1. // Base PCSE model
xtpcse WEEE CEI_AAA FD GDP PDS REC URB
est store pcse_base_robust

2. // PCSE with AR(1) correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_robust

3. // PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_robust

4. // PCSE with PSAR(1) correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_robust

5. // PCSE with PSAR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_robust

6. // PCSE with independent correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(independent)
est store pcse_independent_robust

7. // PCSE with independent correlation and nmk
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_robust

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_robust

// PCSE with AR(1) correlation and dw rhotype  ( TAKEN) 
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_robust

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_robust

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, hetonly
est store pcse_hetonly_robust

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hetonly_ppr

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, het corr(ar1)
est store pcse_het_ar1_robust

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, het corr(psar1)
est store pcse_het_psar1_robust

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_het_ptr

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_robust

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr

// PCSE with casewise handling
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, casewise
est store pcse_casewise_robust

// PCSE with pairwise handling
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, pairwise
est store pcse_pairwise_robust

// PCSE with nmk option
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, nmk
est store pcse_nmk_robust

// PCSE with detailed results
xtpcse WEEE CEI_AAA FD GDP PDS REC URB, detail
est store pcse_detail_robust


// Base FGLS model for CEI_CCC
xtgls WEEE CEI_CCC FD GDP PDS REC URB
est store glsccc1

// Heteroskedastic panels
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsccc2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsccc3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsccc4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsccc5

// Cross-sectionally correlated panels
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(correlated) force
est store glsccc6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsccc7

// Correlated panels with PSAR(1) correlation ( TAKEN) 
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsccc8

// Correlated panels with independent correlations
xtgls WEEE CEI_CCC FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsccc9

// AR(1) correlation only
xtgls WEEE CEI_CCC FD GDP PDS REC URB, corr(ar1)
est store glsccc10

// PSAR(1) correlation only
xtgls WEEE CEI_CCC FD GDP PDS REC URB, corr(psar1)
est store glsccc11

// Independent correlations only
xtgls WEEE CEI_CCC FD GDP PDS REC URB, corr(independent)
est store glsccc12

// Combine results from all models for CEI_CCC
esttab glsccc1 glsccc2 glsccc3 glsccc4 glsccc5 glsccc6 glsccc7 glsccc8 glsccc9 glsccc10 glsccc11 glsccc12, star(* 0.1 ** 0.05 *** 0.01) replace

1. // Base PCSE model
xtpcse WEEE CEI_CCC FD GDP PDS REC URB
est store pcse_base_ccc

2. // PCSE with AR(1) correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_ccc

3. // PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_ccc

4. // PCSE with PSAR(1) correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_ccc

5. // PCSE with PSAR(1) correlation and independent nmk ( TAKEN) 
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_ccc 

// PCSE with independent correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(independent)
est store pcse_independent_ccc

// PCSE with independent correlation and nmk
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_ccc

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_ccc

// PCSE with AR(1) correlation and dw rhotype
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_ccc

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_ccc

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, hetonly
est store pcse_hetonly_ccc

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hetonly_ppr_ccc

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, het corr(ar1)
est store pcse_het_ar1_ccc

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, het corr(psar1)
est store pcse_het_psar1_ccc

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_het_ptr_ccc

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_ccc

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr_ccc

// PCSE with casewise handling
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, casewise
est store pcse_casewise_ccc

// PCSE with pairwise handling
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, pairwise
est store pcse_pairwise_ccc

// PCSE with nmk option
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, nmk
est store pcse_nmk_ccc

// PCSE with detailed results
xtpcse WEEE CEI_CCC FD GDP PDS REC URB, detail
est store pcse_detail_ccc

*NON-LINEAR EFFECTS
gen CEI_AAAii = CEI_AAA^2
// Base FGLS model for CEI_AAA and CEI_AAAii
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB
est store glsaaii1

// Heteroskedastic panels
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsaaii2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsaaii3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsaaii4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsaaii5

// Cross-sectionally correlated panels
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(correlated) force
est store glsaaii6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsaaii7

// Correlated panels with PSAR(1) correlation
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsaaii8

// Correlated panels with independent correlations (TAKEN)
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsaaii9

// AR(1) correlation only
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(ar1)
est store glsaaii10

// PSAR(1) correlation only
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(psar1)
est store glsaaii11

// Independent correlations only
xtgls WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(independent)
est store glsaaii12

// Combine results from all models for CEI_AAA and CEI_AAAii
 esttab glsaaii1 glsaaii2 glsaaii3 glsaaii4 glsaaii5 glsaaii6 glsaaii7 glsaaii8 glsaaii9 glsaaii10 glsaaii11 glsaaii12, star(* 0.1 ** 0.05 *** 0.01) replace

1. // Base PCSE model
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB
est store pcse_base_aaa_ii

2. // PCSE with AR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_aaa_ii

3. // PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_aaa_ii

4. // PCSE with PSAR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_aaa_ii

5. // PCSE with PSAR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_aaa_ii

6. // PCSE with independent correlation (TAKEN)
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(independent)
est store pcse_independent_aaa_ii

7. // PCSE with independent correlation and nmk
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_aaa_ii

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_aaa_ii

// PCSE with AR(1) correlation and dw rhotype
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_aaa_ii

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_aaa_ii

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, hetonly
est store pcse_hetonly_aaa_ii

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hetonly_ppr_aaa_ii

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, het corr(ar1)
est store pcse_het_ar1_aaa_ii

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, het corr(psar1)
est store pcse_het_psar1_aaa_ii

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_het_ptr_aaa_ii

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_aaa_ii

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr_aaa_ii

// PCSE with casewise handling
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, casewise
est store pcse_casewise_aaa_ii

// PCSE with pairwise handling
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, pairwise
est store pcse_pairwise_aaa_ii

// PCSE with nmk option
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, nmk
est store pcse_nmk_aaa_ii

// PCSE with detailed results
xtpcse WEEE CEI_AAA CEI_AAAii FD GDP PDS REC URB, detail
est store pcse_detail_aaa_ii


// Generate the squared variable
gen CEI_CCCii = CEI_CCC^2

// Base FGLS model for CEI_CCC and CEI_CCCii
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB
est store glsccii1

// Heteroskedastic panels
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsccii2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsccii3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsccii4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsccii5

// Cross-sectionally correlated panels (TAKEN)
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(correlated) force
est store glsccii6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsccii7

// Correlated panels with PSAR(1) correlation
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsccii8

// Correlated panels with independent correlations
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsccii9

// AR(1) correlation only
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(ar1)
est store glsccii10

// PSAR(1) correlation only
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(psar1)
est store glsccii11

// Independent correlations only
xtgls WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(independent)
est store glsccii12

// Combine results from all models for CEI_CCC and CEI_CCCii
esttab glsccii1 glsccii2 glsccii3 glsccii4 glsccii5 glsccii6 glsccii7 glsccii8 glsccii9 glsccii10 glsccii11 glsccii12, star(* 0.1 ** 0.05 *** 0.01) replace

// Base PCSE model
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB
est store pcse_base_ccc_ii

// PCSE with AR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_ccc_ii

// PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_ccc_ii

// PCSE with PSAR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_ccc_ii

// PCSE with PSAR(1) correlation and independent nmk
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_ccc_ii

// PCSE with independent correlation (TAKEN)
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(independent)
est store pcse_independent_ccc_ii 

// PCSE with independent correlation and nmk
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_ccc_ii

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_ccc_ii

// PCSE with AR(1) correlation and dw rhotype
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_ccc_ii

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_ccc_ii

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, hetonly
est store pcse_hetonly_ccc_ii

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hetonly_ppr_ccc_ii

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, het corr(ar1)
est store pcse_het_ar1_ccc_ii

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, het corr(psar1)
est store pcse_het_psar1_ccc_ii

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_het_ptr_ccc_ii

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_ccc_ii

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr_ccc_ii

// PCSE with casewise handling
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, casewise
est store pcse_casewise_ccc_ii

// PCSE with pairwise handling
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, pairwise
est store pcse_pairwise_ccc_ii

// PCSE with nmk option
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, nmk
est store pcse_nmk_ccc_ii

// PCSE with detailed results
xtpcse WEEE CEI_CCC CEI_CCCii FD GDP PDS REC URB, detail
est store pcse_detail_ccc_ii

**NON-LINEAR EFFECTS OF FD
xtgls WEEE CEI_AAA FD FDii GDP PDS REC URB, panels(corr) force
est store nonfd1


xtpcse  WEEE CEI_AAA FD FDii GDP PDS REC URB
est store nonfd2
xtgls WEEE CEI_CCC FD FDii GDP PDS REC URB, panels(corr) force
est store nonfd3

xtpcse WEEE CEI_CCC FD FDii GDP PDS REC URB
est store nonfd4

esttab nonfd1 nonfd2 nonfd3 nonfd4 , star(* 0.1 ** 0.05 *** 0.01) replace

*SYNERGY EFFECTS
gen CEI_AAA_FD = CEI_AAA*FD

// Base FGLS model for CEI_AAA, FD, and their interaction CEI_AAA_FD
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB
est store glsaaa_fd1

// Heteroskedastic panels
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsaaa_fd2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsaaa_fd3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsaaa_fd4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsaaa_fd5

// Cross-sectionally correlated panels (TAKEN)
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(correlated) force
est store glsaaa_fd6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsaaa_fd7

// Correlated panels with PSAR(1) correlation
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsaaa_fd8

// Correlated panels with independent correlations
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsaaa_fd9

// AR(1) correlation only
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(ar1)
est store glsaaa_fd10

// PSAR(1) correlation only
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(psar1)
est store glsaaa_fd11

// Independent correlations only
xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(independent)
est store glsaaa_fd12

// Combine results from all models for CEI_AAA, FD, and CEI_AAA_FD
esttab glsaaa_fd1 glsaaa_fd2 glsaaa_fd3 glsaaa_fd4 glsaaa_fd5 glsaaa_fd6 glsaaa_fd7 glsaaa_fd8 glsaaa_fd9 glsaaa_fd10 glsaaa_fd11 glsaaa_fd12, star(* 0.1 ** 0.05 *** 0.01) replace

// Base PCSE model
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB
est store pcse_base_aaa_fd

// PCSE with AR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_aaa_fd

// PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_aaa_fd

// PCSE with PSAR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_aaa_fd

// PCSE with PSAR(1) correlation and independent nmk
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_aaa_fd

// PCSE with independent correlation (TAKEN)
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(independent)
est store pcse_independent_aaa_fd 

// PCSE with independent correlation and nmk
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_aaa_fd

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_aaa_fd

// PCSE with AR(1) correlation and dw rhotype
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_aaa_fd

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_aaa_fd

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, hetonly
est store pcse_hetonly_aaa_fd

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hpadf

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, het corr(ar1)
est store pcse_haafd

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, het corr(psar1)
est store pcse_hpafd

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_hppafd 

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_aaa_fd

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr_aaa_fd

// PCSE with casewise handling
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, casewise
est store pcse_casewise_aaa_fd

// PCSE with pairwise handling
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, pairwise
est store pcse_pairwise_aaa_fd

// PCSE with nmk option
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, nmk
est store pcse_nmk_aaa_fd

// PCSE with detailed results
xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP PDS REC URB, detail
est store pcse_detail_aaa_fd


gen CEI_CCC_FD = CEI_CCC*FD
// Base FGLS model for CEI_CCC, FD, and their interaction CEI_CCC_FD
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB
est store glsccc_fd1

// Heteroskedastic panels
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(heteroskedastic) force
est store glsccc_fd2

// Heteroskedastic panels with AR(1) serial correlation
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(ar1) force
est store glsccc_fd3

// Heteroskedastic panels with PSAR(1) correlation
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(psar1) force
est store glsccc_fd4

// Heteroskedastic panels with independent correlations
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(heteroskedastic) corr(independent) force
est store glsccc_fd5

// Cross-sectionally correlated panels  (TAKEN)
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(correlated) force
est store glsccc_fd6

// Correlated panels with AR(1) serial correlation
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(correlated) corr(ar1) force
est store glsccc_fd7

// Correlated panels with PSAR(1) correlation
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(correlated) corr(psar1) force
est store glsccc_fd8

// Correlated panels with independent correlations
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, panels(correlated) corr(independent) force
est store glsccc_fd9

// AR(1) correlation only
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(ar1)
est store glsccc_fd10

// PSAR(1) correlation only
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(psar1)
est store glsccc_fd11

// Independent correlations only
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(independent)
est store glsccc_fd12

// Combine results from all models for CEI_CCC, FD, and CEI_CCC_FD
esttab glsccc_fd1 glsccc_fd2 glsccc_fd3 glsccc_fd4 glsccc_fd5 glsccc_fd6 glsccc_fd7 glsccc_fd8 glsccc_fd9 glsccc_fd10 glsccc_fd11 glsccc_fd12, star(* 0.1 ** 0.05 *** 0.01) replace

// Base PCSE model
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB
est store pcse_base_ccc_fd

// PCSE with AR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(ar1)
est store pcse_ar1_ccc_fd

// PCSE with AR(1) correlation and independent nmk
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(ar1) independent nmk
est store pcse_ar1_nmk_ccc_fd

// PCSE with PSAR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(psar1)
est store pcse_psar1_ccc_fd

// PCSE with PSAR(1) correlation and independent nmk
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(psar1) independent nmk
est store pcse_psar1_nmk_ccc_fd

// PCSE with independent correlation (TAKEN)
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(independent)
est store pcse_independent_ccc_fd

// PCSE with independent correlation and nmk
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(independent) nmk
est store pcse_independent_nmk_ccc_fd

// PCSE with PSAR(1) correlation and tscorr rhotype
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(psar1) rhotype(tscorr)
est store pcse_psar1_tscorr_ccc_fd

// PCSE with AR(1) correlation and dw rhotype
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(ar1) rhotype(dw)
est store pcse_ar1_dw_ccc_fd

// PCSE with AR(1) correlation and np1
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, corr(ar1) np1
est store pcse_ar1_np1_ccc_fd

// PCSE with heteroskedasticity only
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, hetonly
est store pcse_hetonly_ccc_fd

// PCSE with heteroskedasticity only and PSAR(1) correlation (pairwise)
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, hetonly correlation(psar1) pairwise
est store pcse_hpadf_ccc_fd

// PCSE with heteroskedasticity and AR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, het corr(ar1)
est store pcse_haafd_ccc_fd

// PCSE with heteroskedasticity and PSAR(1) correlation
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, het corr(psar1)
est store pcse_hpafd_ccc_fd

// PCSE with heteroskedasticity and PSAR(1) correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, het corr(psar1) rhotype(tscorr)
est store pcse_hppafd_ccc_fd 

// PCSE with heteroskedasticity and independent correlation
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, het corr(independent)
est store pcse_het_independent_ccc_fd

// PCSE with heteroskedasticity and independent correlation (tscorr rhotype)
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, het corr(independent) rhotype(tscorr)
est store pcse_het_itr_ccc_fd

// PCSE with casewise handling
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, casewise
est store pcse_casewise_ccc_fd

// PCSE with pairwise handling
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, pairwise
est store pcse_pairwise_ccc_fd

// PCSE with nmk option
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, nmk
est store pcse_nmk_ccc_fd

// PCSE with detailed results
xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP PDS REC URB, detail
est store pcse_detail_ccc_fd

*EKC TESTING
DIRECT 
SYNERGY
NON-LINEAR of CEI
NON-LINEAR of FD
*FOR CEI_AAA
xtgls WEEE CEI_AAA FD GDP GDPii PDS REC URB, panels(correlated) corr(ar1) force
est store ekc1

xtpcse WEEE CEI_AAA FD GDP GDPii PDS REC URB, het corr(psar1)
est store ekc2


xtgls WEEE CEI_AAA CEI_AAA_FD FD GDP GDPii PDS REC URB, panels(correlated) corr(independent) force
est store ekc5

xtpcse WEEE CEI_AAA CEI_AAA_FD FD GDP GDPii PDS REC URB, corr(independent)
est store ekc6
xtgls WEEE CEI_AAA CEI_AAAii FD GDP GDPii PDS REC URB, panels(correlated) corr(independent) force
est store ekc9

xtpcse WEEE CEI_AAA CEI_AAAii FD GDP GDPii PDS REC URB, corr(independent)
est store ekc10


xtgls WEEE CEI_AAA FD FDii GDP GDPii  PDS REC URB, panels(corr)  corr(psar1) force
est store ekc13


xtpcse  WEEE CEI_AAA FD FDii GDP GDPii PDS REC URB, corr(psar1)
est store ekc14
*FOR CEI_CCC
xtgls WEEE CEI_CCC FD GDP GDPii PDS REC URB,panels(correlated) force
est store ekc3

 xtpcse WEEE CEI_CCC FD GDP GDPii PDS REC URB, corr(independent)
est store ekc4
xtgls WEEE CEI_CCC CEI_CCC_FD FD GDP GDPii PDS REC URB, panels(correlated)
est store ekc7

xtpcse WEEE CEI_CCC CEI_CCC_FD FD GDP GDPii PDS REC URB, corr(independent)
est store ekc8
xtgls WEEE CEI_CCC CEI_CCCii FD GDP GDPii PDS REC URB, panels(correlated) corr(independent) force
est store ekc11

xtpcse WEEE CEI_CCC CEI_CCCii FD GDP GDPii PDS REC URB, corr(independent)
est store ekc12
xtgls WEEE CEI_CCC FD FDii GDP GDPii PDS REC URB, panels(corr) corr(psar1) force
est store ekc15

xtpcse WEEE CEI_CCC FD FDii GDP GDPii PDS REC URB, rhotype(dw) np1
est store ekc16

*THRESHOLD EFFECTS
ivregress 2sls WEEE (CEI_AAA = l.CEI_AAA) CEI_AAA_FD FD GDP URB REC PDS, vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA (CEI_AAA_FD = l.CEI_AAA_FD) FD GDP URB REC PDS, vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA CEI_AAA_FD (FD = l.FD) GDP URB REC PDS, vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA CEI_AAA_FD FD (GDP = l.GDP) URB REC PDS, vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA CEI_AAA_FD FD GDP (REC = l.REC) URB PDS, vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA CEI_AAA_FD FD GDP REC (URB = l.URB) PDS , vce(robust) 
estat endogenous
estat firststage
ivregress 2sls WEEE CEI_AAA CEI_AAA_FD FD GDP REC URB (PDS =l.PDS) , vce(robust) 
estat endogenous
estat firststage

xthenreg WEEE CEI_AAA CEI_AAA, inst(l.WEEE l.CEI_AAA l.CEI_AAA_FD l.GDP l.REC l.URB)grid_num(400) boost(1000)

xthenreg WEEE CEI_AAA CEI_AAA_FD, inst(l.WEEE l.CEI_AAA l.FD l.GDP l.REC l.URB) grid_num(400) boost(1000)

xthenreg WEEE CEI_AAA GDP, inst(l.WEEE l.CEI_AAA_FD l.FD l.REC l.URB) grid_num(400) boost(1000)

xthenreg WEEE CEI_AAA, endogenous(URB) inst(l.CEI_AAA l.URB) grid_num(400) boost(1000)
 
xthenreg WEEE CEI_AAA FD,  inst(l.CEI_AAA l.FD) grid_num(400) boost(1000)

xthenreg WEEE CEI_AAA, endogenous(PDS) grid_num(400) boost(1000)

xthenreg WEEE CEI_AAA REC,  grid_num(400) boost(1000)
*CLASSIFICATION 
gen CEI_regime = cond(CEI_AAA <= 0.2249, "Low CEI", "High CEI")
.levelsof year, local(years)
.foreach y of local years {
    gen CEI_regime_`y' = cond(CEI_AAA <= 0.2249 & year == `y', "Low CEI", "High CEI")
}
encode CEI_regime, gen(CEIregime)
tab year CEIregime

*Bi/Unidirectional EFFECTS: Granger causality test 
*1.CE_MF
xtgcause     weee_raw  CE_MF, lags(1)
xtgcause CE_MF weee_raw, lags(1)
*2. CE_MR
xtgcause weee_raw CE_MR, lags(1)  
xtgcause CE_MR weee_raw, lags(1)
*3. CE_RP
xtgcause weee_raw CE_RP , lags(1)  
xtgcause CE_RP weee_raw, lags(1)
*4. CE_MG
xtgcause weee_raw CE_MG , lags(1)  
xtgcause CE_MG weee_raw, lags(1)
*5. CE_ER
xtgcause weee_raw CE_ER , lags(1)  
xtgcause CE_ER weee_raw, lags(1)
*6. CE_CR
xtgcause weee_raw CE_CR , lags(1) 
xtgcause CE_CR weee_raw, lags(1)
*7. CE_TR
xtgcause weee_raw CE_TR , lags(1)  
xtgcause CE_TR weee_raw, lags(1)
*8. CE_PI
xtgcause weee_raw CE_PI , lags(1)  
xtgcause CE_PI weee_raw, lags(1)
*9. CE_GV
xtgcause weee_raw CE_GV, lags(1)  
xtgcause CE_GV weee_raw, lags(1)
*10. CE_PE
xtgcause weee_raw CE_PE , lags(1)  
xtgcause CE_PE weee_raw, lags(1)
*11. CE_PA
xtgcause weee_raw CE_PA , lags(1)  
xtgcause CE_PA weee_raw, lags(1)
*12. CE_CF
xtgcause weee_raw CE_CF , lags(1)  
xtgcause CE_CF weee_raw, lags(1)
*13. CE_GG
xtgcause weee_raw CE_GG , lags(1)  
xtgcause CE_GG weee_raw, lags(1)
*14. CE_MD
xtgcause weee_raw CE_MD , lags(1)  
xtgcause CE_MD weee_raw, lags(1)
*15. 
xtgcause weee_raw CEI_AAA , lags(1) 
xtgcause CEI_AAA weee_raw, lags(1) 
*16. 
xtgcause weee_raw CEI_AAA_FD, lags(1)  
xtgcause CEI_AAA_FD weee_raw, lags(1)
*17. 
xtgcause weee_raw CEI_AAAii , lags(1)
xtgcause CEI_AAAii weee_raw, lags(1)  
*18. 
xtgcause weee_raw gdp_raw , lags(1)
xtgcause gdp_raw weee_raw, lags(1)   
*19. 
xtgcause weee_raw gdp_raw_i,  lags(1)
xtgcause gdp_raw_i weee_raw, lags(1)
*20. 
xtgcause weee_raw FD, lags(1)  
xtgcause FD weee_raw, lags(1) 
*21.  FDi ( = FDii) 
xtgcause weee_raw FDi , lags(1)  
xtgcause FDi weee_raw,lags(1)
*===Robustness check 
*22. 
xtgcause weee_raw CEI_CCC , lags(1) 
xtgcause CEI_CCC weee_raw, lags(1) 
*23. 
xtgcause weee_raw CEI_CCC_FD, lags(1)  
xtgcause CEI_CCC_FD weee_raw, lags(1)
*24. 
xtgcause weee_raw CEI_CCCii , lags(1)
xtgcause CEI_CCCii weee_raw, lags(1)  

