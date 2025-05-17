-- Assessment_Q3.sql

-- Find active plans (savings or investment) with no transactions in the last 365 days
SELECT
    p.id AS plan_id,
    p.owner_id,
    
    -- Determine plan type based on flags
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    
    MAX(sa.transaction_date) AS last_transaction_date,
    
    -- Calculate inactivity period in days
    DATEDIFF(CURRENT_DATE(), MAX(sa.transaction_date)) AS inactivity_days

FROM plans_plan p

-- Link plans to transactions in savings_savingsaccount
LEFT JOIN savings_savingsaccount sa ON sa.plan_id = p.id

-- Consider only relevant plan types
WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1

GROUP BY p.id, p.owner_id, type

-- Filter for plans with no transactions or last transaction older than 365 days
HAVING MAX(sa.transaction_date) IS NULL 
   OR DATEDIFF(CURRENT_DATE(), MAX(sa.transaction_date)) > 365;
