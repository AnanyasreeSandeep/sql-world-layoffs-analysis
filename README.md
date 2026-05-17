# World Layoffs SQL Analysis

## Overview
This project analyzes global layoff trends using SQL and MySQL-based exploratory data analysis techniques.

The project demonstrates a complete SQL analytics workflow:
- Data cleaning
- Duplicate removal
- NULL handling
- Data standardization
- Exploratory data analysis (EDA)
- Rolling totals
- Company and industry ranking analysis

The dataset contains layoff information across companies, industries, countries, and years.

---

# Project Structure

```bash
sql-world-layoffs-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_exploratory_data_analysis.sql
│
└── dataset/
    └── layoffs.csv
```

---

# SQL Concepts Demonstrated

## Data Cleaning
- Staging tables
- Duplicate removal using ROW_NUMBER()
- NULL and blank value handling
- Data standardization
- Date conversion
- Column removal

## Exploratory Data Analysis
- Aggregations
- GROUP BY analysis
- Time-series analysis
- Window functions
- CTEs (Common Table Expressions)
- DENSE_RANK()
- Rolling totals

---

# Key Business Insights
- Identified companies with the highest layoffs globally
- Analyzed layoff trends by country and industry
- Examined yearly and monthly layoff patterns
- Ranked top companies by layoffs across different years
- Evaluated industries most affected by workforce reductions

---

# Tools Used
- MySQL
- SQL
- MySQL Workbench

---

# Skills Demonstrated
- Data Cleaning
- Exploratory Data Analysis
- SQL Query Optimization
- Data Transformation
- Window Functions
- Analytical Thinking
- Business Data Analysis

---

# Files

## SQL Scripts
- `01_data_cleaning.sql`
- `02_exploratory_data_analysis.sql`

## Dataset
- `layoffs.csv`

---

# Conclusion
This project demonstrates the use of SQL for transforming raw layoff data into meaningful analytical insights through structured data cleaning and exploratory analysis workflows.
