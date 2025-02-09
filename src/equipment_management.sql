-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
SELECT 
    equipment_id,          -- Unique identifier for the equipment.
    name,                  -- Name of the equipment (e.g., Treadmill, Bench Press).
    next_maintenance_date  -- Date when maintenance is scheduled.
FROM 
    equipment
WHERE 
    next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days'); -- Filter for maintenance dates in the next 30 days.

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
SELECT 
    type AS equipment_type, -- Equipment type (e.g., Cardio, Strength).
    COUNT(*) AS count       -- Total number of equipment items for each type.
FROM 
    equipment
GROUP BY 
    type;                   -- Group results by equipment type.

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)
SELECT 
    type AS equipment_type, -- Equipment type (e.g., Cardio, Strength).
    AVG(JULIANDAY('now') - JULIANDAY(purchase_date)) AS avg_age_days -- Average age in days.
-- JULIANDAY('now'): Current date in Julian format.
-- JULIANDAY(purchase_date): Purchase date of the equipment in Julian format.
FROM 
    equipment
GROUP BY 
    type;                   -- Group results by equipment type.