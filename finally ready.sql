use microfinance;
SHOW COLUMNS FROM loans;

-- 2. Top 10 Borrowers by Total Loan Amount
SELECT borrower_id,
       SUM(loan_amount) AS total_loan_amount
FROM loans
GROUP BY borrower_id
ORDER BY total_loan_amount DESC
LIMIT 10;

-- 3. Default Rate by Loan Status
SELECT status,
       COUNT(*) AS total_loans,
       SUM(default_label) AS total_defaults,
       ROUND(SUM(default_label) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM loans
GROUP BY status
ORDER BY default_rate_percent DESC;

-- 4. Average Interest Rate by Loan Status
SELECT status,
       ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans
GROUP BY status
ORDER BY avg_interest_rate DESC;

-- 5. Loan Distribution by Tenure Range with Default Rate
SELECT 
    CASE 
        WHEN tenure_months <= 6 THEN '0–6 months'
        WHEN tenure_months <= 12 THEN '7–12 months'
        WHEN tenure_months <= 24 THEN '13–24 months'
        ELSE '25+ months'
    END AS tenure_range,
    COUNT(*) AS total_loans,
    SUM(default_label) AS defaults,
    ROUND(SUM(default_label) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM loans
GROUP BY tenure_range
ORDER BY tenure_range;

-- 6. Average Loan Amount by Interest Rate Band
SELECT 
    CASE 
        WHEN interest_rate < 10 THEN '<10%'
        WHEN interest_rate BETWEEN 10 AND 15 THEN '10–15%'
        WHEN interest_rate BETWEEN 15 AND 20 THEN '15–20%'
        ELSE '>20%'
    END AS interest_band,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loans
GROUP BY interest_band
ORDER BY interest_band;

-- 7. Default Rate by Loan Amount Range
SELECT 
    CASE 
        WHEN loan_amount < 10000 THEN '< 10K'
        WHEN loan_amount BETWEEN 10000 AND 50000 THEN '10K–50K'
        WHEN loan_amount BETWEEN 50001 AND 100000 THEN '50K–100K'
        ELSE '> 100K'
    END AS loan_amount_range,
    COUNT(*) AS total_loans,
    SUM(default_label) AS defaulted_loans,
    ROUND(SUM(default_label) * 100.0 / COUNT(*), 2) AS default_rate_percent
FROM loans
GROUP BY loan_amount_range
ORDER BY loan_amount_range;

-- 8. Loan Count & Avg Amount by Loan Status
SELECT 
    status,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    COUNT(*) AS total_loans
FROM loans
GROUP BY status
ORDER BY avg_loan_amount DESC;

-- 9. Borrowers with More Than One Loan (Top 10 by Loan Volume)
SELECT 
    borrower_id,
    COUNT(loan_id) AS num_loans,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    SUM(default_label) AS defaults
FROM loans
GROUP BY borrower_id
HAVING COUNT(loan_id) > 1
ORDER BY total_loan_amount DESC
LIMIT 10;
SELECT 
    t.borrower_id,
    t.topup_freq,
    t.data_usage_mb,
    t.sim_count,
    b.income,
    b.location
FROM telecom_data t
JOIN borrowers b ON t.borrower_id = b.borrower_id
ORDER BY t.topup_freq DESC
LIMIT 6;
SELECT 
    g.district,
    g.rural_urban_flag,
    ROUND(AVG(l.loan_amount), 2) AS avg_loan_amount,
    SUM(l.default_label) AS total_defaults,
    COUNT(l.loan_id) AS total_loans,
    ROUND((SUM(l.default_label) * 100.0 / COUNT(l.loan_id)), 2) AS default_rate_percent
FROM loans l
JOIN geolocation g ON l.borrower_id = g.district
GROUP BY g.district, g.rural_urban_flag
ORDER BY default_rate_percent DESC
LIMIT 6;
SELECT 
    l.borrower_id,
    COUNT(t.amount) AS total_transactions,
    ROUND(AVG(t.amount), 2) AS avg_transaction_value,
    l.status AS loan_status
FROM transactions t
JOIN loans l ON t.borrower_id = l.borrower_id
GROUP BY l.borrower_id, l.status
HAVING COUNT(t.amount) > 5
ORDER BY total_transactions DESC
LIMIT 6;