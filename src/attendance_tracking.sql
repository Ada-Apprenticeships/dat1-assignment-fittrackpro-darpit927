-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES 
    (7,                 -- ID of the member checking in.
     1,                 -- ID of the location (Downtown Fitness).
     DATETIME('now'));  -- Current date and time as the check-in time.

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT 
    DATE(check_in_time) AS visit_date, -- Extract the date from the check-in time.
    check_in_time,      -- Check-in time of the visit.
    check_out_time      -- Check-out time of the visit (if available).
FROM 
    attendance
WHERE 
    member_id = 5;      -- Filter for the attendance history of the member with ID 5.

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT 
    CASE 
        WHEN STRFTIME('%w', check_in_time) = '0' THEN 'Sunday'
        WHEN STRFTIME('%w', check_in_time) = '1' THEN 'Monday'
        WHEN STRFTIME('%w', check_in_time) = '2' THEN 'Tuesday'
        WHEN STRFTIME('%w', check_in_time) = '3' THEN 'Wednesday'
        WHEN STRFTIME('%w', check_in_time) = '4' THEN 'Thursday'
        WHEN STRFTIME('%w', check_in_time) = '5' THEN 'Friday'
        WHEN STRFTIME('%w', check_in_time) = '6' THEN 'Saturday'
    END AS day_of_week,          -- Map day number to day name.
    COUNT(*) AS visit_count      -- Total number of visits for each day.
FROM 
    attendance
GROUP BY 
    STRFTIME('%w', check_in_time) -- Group by the day of the week (0 = Sunday, 6 = Saturday).
ORDER BY 
    visit_count DESC             -- Sort by visit count in descending order.
LIMIT 1;                         -- Return only the busiest day.

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT 
    l.name AS location_name,     -- Name of the location.
    AVG(daily_visits) AS avg_daily_attendance -- Average daily attendance for the location.
FROM (
    SELECT 
        location_id,            -- ID of the location.
        DATE(check_in_time) AS visit_date, -- Extract the visit date.
        COUNT(*) AS daily_visits -- Count the number of visits per day.
    FROM 
        attendance
    GROUP BY 
        location_id, visit_date -- Group by location and visit date.
) subquery
JOIN 
    locations l ON subquery.location_id = l.location_id -- Join with locations to get the location name.
GROUP BY 
    l.name;                     -- Group by location name to calculate the average attendance.