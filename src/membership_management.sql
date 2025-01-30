-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT * 
FROM memberships 
WHERE status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT type AS membership_type, 
       AVG(julianday(check_out_time) - julianday(check_in_time)) AS avg_visit_duration_minutes
FROM attendance a 
JOIN memberships m
ON a.member_id = m.member_id 
GROUP BY type;

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT * 
FROM memberships 
WHERE end_date BETWEEN DATE('now') AND DATE('now', 'end of year');