-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
SELECT * 
FROM equipment 
WHERE next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days');

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
SELECT type, 
       COUNT(*) 
FROM equipment 
GROUP BY type;

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)
SELECT type, 
       AVG(julianday('now') - julianday(purchase_date)) AS avg_age 
FROM equipment 
GROUP BY type;