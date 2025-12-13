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
