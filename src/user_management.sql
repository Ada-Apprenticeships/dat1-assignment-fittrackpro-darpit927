-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT * 
FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members 
SET phone_number = '555-9876', 
    email = 'emily.jones.updated@email.com' 
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*) 
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT member_id, 
       COUNT(*) AS registrations 
FROM class_attendance 
GROUP BY member_id 
ORDER BY registrations DESC 
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT member_id, 
       COUNT(*) AS registrations 
FROM class_attendance 
GROUP BY member_id 
ORDER BY registrations ASC 
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
SELECT (COUNT(DISTINCT member_id) * 100.0) / (SELECT COUNT(*) 
                                              FROM members) AS percentage 
FROM class_attendance;