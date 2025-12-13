# AN EXTENDED STIRPAT MODEL TO ADDRESS ELECTRICITY WASTE GENERATION IN EU-27 COUNTRIES

📅 **Duration**: Jan 2024 – Dec 2024  
👥 **Team Size**: 4  
🎯 **Role**: Econometrics Design & Data Analysis  
🛠️ **Tech Stack**: Python, Stata  

---

## 🧠 Overview

This project examines the **electricity waste (E‑WASTE) – financial development nexus** in **EU‑27 countries** using an **extended STIRPAT (Stochastic Impacts by Regression on Population, Affluence, and Technology)** framework. The study integrates **novel circular economy metrics**, nonlinear dynamics, and advanced panel econometric techniques to uncover both **direct and rebound effects** in sustainability transitions.

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

---

## 🧮 Model Specification & Estimation Strategy

An **extended STIRPAT framework** was estimated using a sequential econometric pipeline:

```text
OLS (Initialization)
   → FGLS (Baseline efficiency)
   → PCSE (Robustness to heteroskedasticity & CD)
   → 2SLS (Endogeneity correction)

📈 Key Empirical Findings

Circular Economy Index (CEI) and Financial Development (FD):

Significantly reduce electricity waste through direct and heterogeneous effects

Synergy Effect (CEI × FD):

Positive and significant at 1% level

Indicates rebound effects when financial expansion outpaces circular‑economy policy safeguards

Nonlinear Dynamics:

Validates the Environmental Kuznets Curve (EKC) hypothesis:

GDP initially increases E‑WASTE

Beyond a threshold, economic growth mitigates electricity waste

🔄 Dynamic & Causal Analysis

Applied Dynamic Panel Threshold Model (Seo et al., 2019):

Grid search with bootstrapped confidence intervals

Identified CEI threshold ≈ 0.28–0.38

Beyond this level, consumption‑driven rebound effects emerge

Conducted Dumitrescu–Hurlin (2012) Granger Causality Tests:

FD → E‑WASTE

E‑WASTE → GDP

Bidirectional causality between E‑WASTE and key CE sub‑components

📁 Repository Contents
├── E-Waste.do                   # Stata script for extended STIRPAT estimation
├── RAW-DATA-EWASTE.xlsx         # Raw EU‑27 dataset
├── dataset_with_CEI_CC.dta      # Processed panel with CEI and carbon indicators
├── E-WASTE.pdf                  # Research manuscript / summary report
├── README.md                    # Project documentation

📄 Reference

Nguyen Tran Phuoc Toan, Phung Ngoc Anh Thu, Nguyen Thi Huynh Nhu, Nguyen Phan Bao Tran (2025).
E‑Waste–Financial Development Nexus in EU Countries: Insights from Novel Circular Economy Determinants.
UEH Young Researcher Award 2025

📜 License

This project is released under the MIT License.
Please cite the authors when using this repository for academic or policy research.
