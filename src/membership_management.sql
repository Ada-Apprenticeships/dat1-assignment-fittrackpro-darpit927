-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT 
    m.member_id,            -- Unique identifier for the member.
    m.first_name,           -- First name of the member.
    m.last_name,            -- Last name of the member.
    mem.type AS membership_type, -- Type of membership (e.g., Monthly, Annual).
    m.join_date             -- Date the member joined.
FROM 
    memberships mem
JOIN 
    members m 
        ON mem.member_id = m.member_id -- Join memberships with members.
WHERE 
    mem.status = 'Active';  -- Filter for active memberships only.

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT 
    mem.type AS membership_type, -- Type of membership (e.g., Monthly, Annual).
    AVG(JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 1440 AS avg_visit_duration_minutes -- Average visit duration in minutes.
-- JULIANDAY calculates the difference in days, which is multiplied by 1440 (minutes in a day) for total visit duration in minutes.
FROM 
    memberships mem
JOIN 
    attendance a 
        ON mem.member_id = a.member_id -- Join memberships with attendance records.
GROUP BY 
    mem.type; -- Group by membership type to calculate average visit duration.

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT 
    m.member_id,          -- Unique identifier for the member.
    m.first_name,         -- First name of the member.
    m.last_name,          -- Last name of the member.
    m.email,              -- Member's email address.
    mem.end_date          -- Membership expiration date.
FROM 
    memberships mem
JOIN 
    members m 
        ON mem.member_id = m.member_id -- Join memberships with members.
WHERE 
    mem.end_date BETWEEN DATE('now') AND DATE('now', '+1 year'); -- Filter for memberships expiring within the next year.