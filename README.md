# DataAnalytics-Assessment

This repository contains my solutions to the SQL proficiency assessment. The questions cover key areas in data analysis such as identifying customer behavior, analyzing transaction patterns, tracking inactivity, and estimating customer value. For each question, I’ve explained the challenges I faced, the approach I took, and why I believe the solution works.

---

## Question 1: High-Value Customers with Multiple Products

**Challenges:**
The main challenge here was distinguishing between savings and investment products using the given flags: `is_regular_savings` for savings and `is_a_fund` for investments. Another point to consider was filtering only funded accounts to meet the requirement of "at least one funded" product.

**Approach:**
I joined the `users_customuser` table with both the savings and investment tables. Then I filtered for only those entries where savings accounts had a positive `confirmed_amount` and investments also had a funded plan. I grouped the results by customer and calculated the total number of each product as well as the sum of confirmed deposits (converted from kobo to Naira).

**Why this works:**
This approach ensures that only customers with at least one of each funded product are selected. Using `COUNT(DISTINCT ...)` avoids overcounting, and grouping by customer gives us the required aggregates for savings, investments, and total deposits.

---

## Question 2: Transaction Frequency Analysis

**Challenges:**
I had to determine how to calculate the average number of transactions per customer per month accurately. Since the table didn’t directly provide month-level breakdowns, I had to derive it from the timestamps. Another tricky part was making sure that customers who had very short or very long activity periods weren’t misrepresented in the averages.

**Approach:**
I calculated the time range (in months) between the first and last transaction for each customer, assuming one row equals one transaction. Then I divided the total number of transactions by the number of months active. I categorized each customer based on the provided frequency rules and then aggregated by category to get the average and count.

**Why this works:**
By deriving the transaction frequency from actual activity periods instead of assuming a fixed timeframe, this method reflects customer behavior more accurately. Grouping by these categories helps answer the original business question around segmentation.

---

## Question 3: Account Inactivity Alert

**Challenges:**
There were two main challenges here: combining two different types of accounts (savings and investments) and correctly identifying the last transaction date for each. I also had to make sure I didn't miss active accounts that just hadn’t had recent activity.

**Approach:**
I created a union of savings and investment plans where the `confirmed_amount` was greater than zero, assuming that indicates an inflow. I took the `updated_at` field as the last transaction date, calculated the number of days since that date, and filtered for accounts with no transactions in the last 365 days.

**Why this works:**
This solution captures any account that was previously active but has gone quiet for over a year. By treating savings and investment accounts equally in a combined query, it allows the operations team to see all inactive accounts in one place.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Challenges:**
The key challenge was interpreting and calculating the CLV based on the formula provided. I needed to estimate account tenure in months and ensure the formula was applied correctly. Also, since the transaction value was in kobo, I had to be careful with unit conversion.

**Approach:**
I calculated tenure by finding the number of months between the signup date (earliest transaction) and today. I then summed up the total number of transactions and total transaction value per customer. Using the formula `(total_transactions / tenure) * 12 * avg_profit_per_transaction`, I derived the estimated CLV and ordered the results by value.

**Why this works:**
The solution sticks closely to the definition provided, including the assumption that profit is 0.1% of transaction value. Calculating tenure and CLV per customer gives the marketing team a simple way to identify high-value users and how long they’ve been active.

---

## Notes

- All monetary values were converted from kobo to Naira by dividing by 100.
- I used `ROUND()` in some queries to make outputs easier to read and match expected formats.
- `NULLIF()` was used in divisions to avoid errors where tenure or transaction counts might be zero.
- I assumed that each row in the savings or investment table represents a transaction (based on the structure).

Let me know if you'd like me to adjust the queries based on additional business logic or new assumptions.

