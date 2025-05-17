-- Assessment_Q4.sql

-- Estimate Customer Lifetime Value (CLV) using average profit per transaction,
-- transaction volume, and account tenure in months.

-- Step 1: Get total transactions and value per customer
WITH transactions_per_customer AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_value  -- In kobo
    FROM savings_savingsaccount
    GROUP BY owner_id
),

-- Step 2: Get tenure (in months) and customer name
tenure AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),

-- Step 3: Calculate CLV using simplified formula:
-- CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
-- avg_profit_per_transaction = 0.1% of average transaction value
clv_calc AS (
    SELECT
        te.customer_id,
        te.name,
        te.tenure_months,
        tc.total_transactions,
        
        -- estimated_clv is calculated in Naira, hence the final division by 100
        ROUND(
            (
                (tc.total_transactions / NULLIF(te.tenure_months, 0)) * 12 *
                ((tc.total_value / tc.total_transactions) * 0.001)  -- 0.1% profit
            ) / 100,
            2
        ) AS estimated_clv
    FROM tenure te
    JOIN transactions_per_customer tc ON te.customer_id = tc.owner_id
)

-- Step 4: Return the results ordered by highest CLV
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
