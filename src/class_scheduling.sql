-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT 
    c.class_id,            -- Unique identifier for the class.
    c.name AS class_name,  -- Name of the class (e.g., Yoga, Spin).
    s.first_name || ' ' || s.last_name AS instructor_name -- Full name of the instructor.
FROM 
    class_schedule cs
JOIN 
    classes c ON cs.class_id = c.class_id  -- Join class schedules with classes.
JOIN 
    staff s ON cs.staff_id = s.staff_id;  -- Join class schedules with staff to get instructor details.

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT 
    cs.class_id,            -- Unique identifier for the class schedule.
    c.name,                 -- Name of the class.
    cs.start_time,          -- Start time of the class.
    cs.end_time,            -- End time of the class.
    (c.capacity - COUNT(ca.class_attendance_id)) AS available_spots -- Calculate available spots.
FROM 
    class_schedule cs
JOIN 
    classes c ON cs.class_id = c.class_id -- Join class schedules with class details.
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id -- Join with attendance to count registrations.
WHERE 
    DATE(cs.start_time) = '2025-02-01' -- Filter for the specific date.
GROUP BY 
    cs.schedule_id;         -- Group results by class schedule.

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES 
    (3,                -- ID of the schedule for the class.
     11,               -- ID of the member being registered.
     'Registered');    -- Attendance status indicating the member is registered.

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance
WHERE 
    schedule_id = 7 -- ID of the class schedule.
    AND member_id = 2; -- ID of the member whose registration is being canceled.

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
SELECT 
    c.class_id,                  -- Unique identifier for the class.
    c.name AS class_name,        -- Name of the class.
    COUNT(ca.class_attendance_id) AS registration_count -- Total number of registrations.
FROM 
    classes c
JOIN 
    class_schedule cs ON c.class_id = cs.class_id -- Join classes with their schedules.
JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id -- Join schedules with attendance records.
GROUP BY 
    c.class_id                  -- Group by class to count registrations.
ORDER BY 
    registration_count DESC     -- Sort by registration count in descending order.
LIMIT 3;                        -- Return the top 3 results.

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT 
    AVG(class_count) AS avg_classes_per_member -- Average classes per member.
FROM (
    SELECT 
        COUNT(ca.class_attendance_id) AS class_count -- Count of classes attended per member.
    FROM 
        members m
    LEFT JOIN 
        class_attendance ca ON m.member_id = ca.member_id -- Include members without any attendance.
    GROUP BY 
        m.member_id -- Group by member to calculate attendance counts.
) subquery;