# Scatterplot Demo in Tableau and Power BI

A hands-on tutorial project showing how to build **a scatter plot using one variable and jitter** using real-world PEPFAR data from Mozambique. Useful for finding outliers across countries, provinces and districts.

---

## Project Overview

This project is designed for data visualization developers who wants to create scatter plots to look at distribution across provinces and districts. It uses **PEPFAR's Enhanced Geographical Analysis (EGA)** dataset and focuses on:

- Creating scatterplots to look at distribution.  Uses one value and a jitter to see all provinces/districts.
- Implementing this behavior in both **Tableau** and **Power BI**
- Structuring data in R for consistent use across both platforms

---

##  Data Source

- **Source**: [PEPFAR Enhanced Geographical Analysis](https://data.pepfar.gov/ - downloaded on January 2025. Website no longer available.)
- **Focus Country**: SADC Countries (when available)
- **Raw Format**: TXT from PEPFAR portal
- **Processed in**: R (using `tidyverse`, `janitor`)

---

##  Data Processing (R)

All data prep is handled in R, ensuring a clean and consistent format for input into either visualization tool.

**Steps:**
1. Filter SADC Country data
2. Clean and standardize indicator names (TB_STAT_POS)
3. Pivot or reshape data for parameter compatibility
4. Export a unified CSV for use in both Tableau and Power BI



---

## What You'll Learn

- How to create **dynamic calculations** based on user selection
- How to build **parameter-driven dashboards**
- How to handle **multi-indicator logic** from a single dropdown or slicer
- How to structure and process raw data for maximum flexibility

---






