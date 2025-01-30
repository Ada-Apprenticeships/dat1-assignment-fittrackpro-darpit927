-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type) 
VALUES (11, 50.00, '2025-01-30 15:05:00', 'Credit Card', 'Monthly membership fee');

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
SELECT strftime('%Y-%m', payment_date) AS month, 
       SUM(amount) AS total_revenue 
FROM payments 
WHERE payment_type = 'Monthly membership fee' 
GROUP BY month;

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
SELECT * 
FROM payments 
WHERE payment_type = 'Day pass';