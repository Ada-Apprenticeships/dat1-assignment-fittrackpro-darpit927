-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES 
    (11,                    -- ID of the member making the payment.
     50.00,                 -- Amount of the payment.
     DATETIME('now'),       -- Current date and time as the payment date.
     'Credit Card',         -- Payment method used.
     'Monthly membership fee'); -- Payment type indicating a membership fee.

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
SELECT 
    STRFTIME('%Y-%m', payment_date) AS month, -- Extract year and month from payment date.
    SUM(amount) AS total_revenue              -- Calculate the total revenue for each month.
FROM 
    payments
WHERE 
    payment_type = 'Monthly membership fee'   -- Include only payments for membership fees.
    AND payment_date >= DATE('now', '-1 year') -- Filter payments made in the last year.
GROUP BY 
    month                                     -- Group results by month.
ORDER BY 
    month;                                    -- Sort the results chronologically.

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
SELECT 
    payment_id,            -- Unique identifier for the payment.
    amount,                -- Amount paid.
    payment_date,          -- Date of the payment.
    payment_method         -- Payment method used (e.g., Credit Card, Cash).
FROM 
    payments
WHERE 
    payment_type = 'Day pass'; -- Filter for payments related to day passes.