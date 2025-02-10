-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
SELECT 
    staff_id,             -- Unique identifier for the staff member.
    first_name,           -- First name of the staff member.
    last_name,            -- Last name of the staff member.
    position AS role      -- Position or role of the staff member (e.g., Trainer, Manager).
FROM 
    staff;

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days
SELECT 
    s.staff_id AS trainer_id,          -- Unique identifier for the trainer.
    s.first_name || ' ' || s.last_name AS trainer_name, -- Full name of the trainer.
    COUNT(pt.session_id) AS session_count -- Total number of sessions.
FROM 
    personal_training_sessions pt
JOIN 
    staff s 
        ON pt.staff_id = s.staff_id -- Join personal training sessions with staff.
WHERE 
    pt.session_date BETWEEN DATE('now') AND DATE('now', '+30 days') -- Filter sessions in the next 30 days.
GROUP BY 
    s.staff_id;             -- Group by trainer to count their sessions.