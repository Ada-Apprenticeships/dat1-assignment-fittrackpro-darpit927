-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT 
    member_id,          -- Member's unique identifier.
    first_name,         -- First name of the member.
    last_name,          -- Last name of the member.
    email,              -- Member's email address.
    join_date           -- Date the member joined.
FROM 
    members;            -- Table containing member information.

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET 
    phone_number = '555-9876',  -- Update phone number.
    email = 'emily.jones.updated@email.com'  -- Update email address.
WHERE 
    member_id = 5;              -- Update the record for member with ID 5.

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT 
    COUNT(*) AS total_members   -- Calculate the total number of rows in the members table.
FROM 
    members;                    -- Table containing member information.


-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT 
    m.member_id,                -- Member's unique identifier.
    m.first_name,               -- First name of the member.
    m.last_name,                -- Last name of the member.
    COUNT(ca.class_attendance_id) AS registration_count -- Total number of class registrations.
FROM 
    members m
JOIN 
    class_attendance ca 
        ON m.member_id = ca.member_id -- Join members with their attendance records.
GROUP BY 
    m.member_id                 -- Group by each member to calculate their registration count.
ORDER BY 
    registration_count DESC     -- Sort by registration count in descending order.
LIMIT 1;                        -- Return only the member with the highest count.

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT 
    m.member_id,                -- Member's unique identifier.
    m.first_name,               -- First name of the member.
    m.last_name,                -- Last name of the member.
    COUNT(ca.class_attendance_id) AS registration_count -- Total number of class registrations.
FROM 
    members m
LEFT JOIN 
    class_attendance ca 
        ON m.member_id = ca.member_id -- Left join to include members without registrations.
GROUP BY 
    m.member_id                 -- Group by each member to calculate their registration count.
ORDER BY 
    registration_count ASC      -- Sort by registration count in ascending order.
LIMIT 1;                        -- Return only the member with the lowest count.

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
SELECT 
    (COUNT(DISTINCT ca.member_id) * 100.0 / COUNT(DISTINCT m.member_id)) AS percentage
-- COUNT(DISTINCT ca.member_id): Counts the number of members who attended at least one class.
-- COUNT(DISTINCT m.member_id): Counts the total number of members in the system.
FROM 
    members m
LEFT JOIN 
    class_attendance ca 
        ON m.member_id = ca.member_id; -- Join members with their attendance records.