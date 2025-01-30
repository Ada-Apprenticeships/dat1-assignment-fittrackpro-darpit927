-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT c.name AS class_name, 
       s.first_name || ' ' || s.last_name AS instructor
FROM classes c 
JOIN class_schedule cs 
ON c.class_id = cs.class_id 
JOIN staff s 
ON cs.staff_id = s.staff_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT * 
FROM class_schedule 
WHERE DATE(start_time) BETWEEN '2025-02-01 00:00:00' AND '2025-02-02 00:00:00';

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status) 
VALUES (3, 11, 'Registered');

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance 
WHERE schedule_id = 7 AND member_id = 2;

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
SELECT c.name, 
       COUNT(ca.member_id) AS registrations 
FROM class_attendance ca 
JOIN class_schedule cs 
ON ca.schedule_id = cs.schedule_id 
JOIN classes c 
ON cs.class_id = c.class_id 
GROUP BY c.name 
ORDER BY registrations DESC 
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT COUNT(*) / (SELECT COUNT(*) 
                   FROM members) AS avg_classes_per_member 
FROM class_attendance;