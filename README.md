# AN EXTENDED STIRPAT MODEL TO ADDRESS ELECTRICITY WASTE GENERATION IN EU-27 COUNTRIES

📅 **Duration**: Jan 2024 – Dec 2024  
👥 **Team Size**: 4  
🎯 **Role**: Econometrics Design & Data Analysis  
🛠️ **Tech Stack**: Python, Stata

---

## (i). Overview

This study evaluates the **electricity waste–financial development nexus** across EU‑27 countries using an **extended STIRPAT (Stochastic Impacts by Regression on Population, Affluence, and Technology)** framework enriched by **novel circular economy metrics** and **dynamic panel econometrics**.

---

## (ii). Data Construction

- Developed a **balanced panel** for EU‑27 over **2010–2020**  
  - Total observations: **N = 297**
  - Balanced via **interpolation** and **mean imputation**
- Combined indicators from economic, environmental, energy, and circular economy domains
- All data sourced from official EU and international statistical portals

---

## (iii). Circular Economy Index (CEI)

- Engineered a **composite CEI** using:
  - **20 sub-indicators**
  - Weighted via the **Entropy Weight Method (EWM)**
- Robustness checked with:
  - **Principal Component Analysis (PCA)** to verify weighting stability and component structure

---

## (iv). Econometric Diagnostics

All variables underwent comprehensive diagnostic testing to ensure valid inference:

- **Cross-sectional dependence**: Pesaran’s CD test
- **Stationarity**: Fisher-type panel unit root tests
- **Multicollinearity**: VIF scores
- **Heteroskedasticity & Serial correlation**: Breusch–Pagan and Wooldridge tests

---

## (v). Modeling Pipeline

A robust multi-stage estimation sequence was employed:

```text
OLS (initial model)
→ FGLS (baseline estimator)
→ PCSE (correcting for heteroskedasticity & CD)
→ 2SLS (addressing potential endogeneity)
```
---

## (vi). Key Findings

- **Both CEI and Financial Development (FD)** reduce E-WASTE directly and interactively
- **CEI × FD interaction** shows a **positive synergy effect**: risk of **rebound effects** if circular strategies are scaled without financial policy alignment
- **EKC hypothesis confirmed**: GDP first increases, then reduces E-WASTE over time
- **Dynamic Threshold Analysis** (Seo et al., 2019):
  - Reveals critical CEI zone of **0.28–0.38** where rebound consumption risk emerges
- **Granger Causality Tests** (Dumitrescu–Hurlin, 2012):
  - FD → E-WASTE  
  - E-WASTE → GDP  
  - Bidirectional causality with select CEI sub-components

---

## (vii). Repository Contents
- `E-Waste.do`: Stata script for extended STIRPAT estimation
- `RAW-DATA-EWASTE.xlsx`: Raw EU‑27 dataset
- `dataset_with_CEI_CC.dta`: Processed panel with CEI and carbon indicators
- `E-WASTE.pdf`: Research manuscript / summary report
- `README.md`: Project documentation

## (viii). Citation

> Toan N.T.P., et al. (2025).  
> *E-Waste, Financial Development Nexus in EU Countries: Insights from Novel Circular Economy Determinants.*  
> **UEH Young Researcher Award 2025**

>  Based study: Nguyen, P.H., Le, T.N., Pham, M.T. et al. Circular economy, economic growth, and e-waste generation in EU27 countries: Further evidence from the novel circular economy index and threshold effect. Environ Sci Pollut Res 31, 55361–55387 (2024). https://doi.org/10.1007/s11356-024-34855-w

## (ix). License
📜 *MIT License* | 📁 *Stata & Excel-based repository*

## (x). Acknowledgements

This work was conducted under the **UEH Young Researcher Award 2025**.  


