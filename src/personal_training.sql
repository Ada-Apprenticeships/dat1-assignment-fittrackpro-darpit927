-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT 
    pt.session_id,          -- Unique identifier for the session.
    m.first_name || ' ' || m.last_name AS member_name, -- Full name of the member attending the session.
    pt.session_date,        -- Date of the session.
    pt.start_time,          -- Start time of the session.
    pt.end_time             -- End time of the session.
FROM 
    personal_training_sessions pt
JOIN 
    members m 
        ON pt.member_id = m.member_id -- Join sessions with members.
JOIN 
    staff s 
        ON pt.staff_id = s.staff_id -- Join sessions with staff.
WHERE 
    s.first_name = 'Ivy' AND s.last_name = 'Irwin'; -- Filter for sessions conducted by Ivy Irwin.