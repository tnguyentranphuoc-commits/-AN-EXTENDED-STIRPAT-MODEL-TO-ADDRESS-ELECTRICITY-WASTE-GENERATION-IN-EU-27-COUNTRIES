# AN EXTENDED STIRPAT MODEL TO ADDRESS ELECTRICITY WASTE GENERATION IN EU-27 COUNTRIES

📅 **Duration**: Jan 2024 – Dec 2024  
👥 **Team Size**: 4  
🎯 **Role**: Econometrics Design & Data Analysis  
🛠️ **Tech Stack**: Python, Stata

---

This study evaluates the **electricity waste–financial development nexus** across EU‑27 countries using an **extended STIRPAT framework** with novel circular economy metrics and dynamic econometric tools.

---

## 📊 Data Construction

- Curated a **balanced EU‑27 panel dataset** covering **2010–2020**  
  - Observations: **N = 297**
  - Achieved balance via **interpolation and mean imputation**
- Compiled economic, environmental, financial, and circular‑economy indicators from official EU sources

---

## ♻️ Circular Economy Index (CEI)

- Constructed a **novel Circular Economy Index (CEI)** using:
  - **20 sub‑indicators**
  - **Entropy Weight Method (EWM)** for objective weighting
- Conducted robustness validation using:
  - **Principal Component Analysis (PCA)** to confirm weighting stability and index consistency

---

## 🔬 Econometric Diagnostics

All variables were pre‑tested to ensure estimator efficiency and inference validity:

- **Cross‑sectional dependence** (CD test)
- **Fisher‑type panel unit root tests**
- **Multicollinearity diagnostics**
- **Heteroskedasticity and serial correlation tests**

The model was estimated through a pipeline:  
**OLS (init) → FGLS (baseline) → PCSE (robustness) → 2SLS (endogeneity correction)**
---

### 🔍 Key Findings
- **CEI** and **Financial Development (FD)** reduce electricity waste via direct and interacting effects.
- A **positive synergy effect (CEI × FD)** at 1% significance suggests **amplified rebound risks** without coordinated policies.
- Confirmed the **Environmental Kuznets Curve (EKC)**: GDP first increases, then decreases E-WASTE.
- **Dynamic threshold analysis** (Seo et al., 2019): rebound effects emerge when CEI crosses **≈ 0.28–0.38**.
- **Granger causality** (Dumitrescu–Hurlin, 2012) reveals:
  - FD → E-WASTE  
  - E-WASTE → GDP  
  - Bidirectional links with key CE sub-indicators

### 📁 Repository Contents
├── E-Waste.do                   # Stata script for extended STIRPAT estimation
├── RAW-DATA-EWASTE.xlsx         # Raw EU‑27 dataset
├── dataset_with_CEI_CC.dta      # Processed panel with CEI and carbon indicators
├── E-WASTE.pdf                  # Research manuscript / summary report
├── README.md                    # Project documentation


### 📄 Citation

> Toan N.T.P., et al. (2025).  
> *E-Waste, Financial Development Nexus in EU Countries: Insights from Novel Circular Economy Determinants.*  
> **UEH Young Researcher Award 2025**

---
📜 *MIT License* | 📁 *Stata & Excel-based repository*


