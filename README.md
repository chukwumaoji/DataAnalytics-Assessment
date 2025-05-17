# DataAnalytics-Assessment

## Overview
This assessment evaluates SQL proficiency with real-world data challenges such as customer segmentation, account activity tracking, and lifetime value estimation.

---

## Q1: High-Value Customers with Multiple Products

**Approach**: Joined customers, savings, and investment tables with filtering on funded amounts. Grouped by customer, and calculated savings/investment count and total deposits.

---

## Q2: Transaction Frequency Analysis

**Approach**: Calculated transaction counts per customer, normalized by months active. Used conditional logic to categorize customers.

**Challenge**: Handling division by zero. Used `NULLIF` to prevent errors.

---

## Q3: Account Inactivity Alert

**Approach**: Merged savings and investment tables into a single set. Filtered accounts with no inflow in past 365 days.

---

## Q4: Customer Lifetime Value (CLV)

**Approach**: Estimated CLV using total transaction count and tenure in months. Applied simplified CLV formula and profit percentage.

**Challenge**: Ensured date arithmetic used PostgreSQL functions like `AGE()` and `DATE_PART()` correctly.

---

## Notes
All queries were tested for performance and logic. Comments are included in each SQL file for clarity.
