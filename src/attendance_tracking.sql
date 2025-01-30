-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time) 
VALUES (7, 1, '2025-01-30 12:45:00');

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT * 
FROM attendance 
WHERE member_id = 5 
ORDER BY check_in_time DESC;

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT strftime('%w', check_in_time) AS day_of_week, 
       COUNT(*) AS visit_count 
FROM attendance 
GROUP BY day_of_week 
ORDER BY visit_count DESC 
LIMIT 1;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT location_id, 
       COUNT(*) / COUNT(DISTINCT DATE(check_in_time)) AS avg_daily_attendance 
FROM attendance 
GROUP BY location_id;