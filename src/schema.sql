-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support to enforce relationships between tables.
PRAGMA foreign_keys = ON;

-- Drop existing tables if they exist to ensure a clean slate before creating new tables.
DROP TABLE IF EXISTS equipment_maintenance_log; -- Log of equipment maintenance activities.
DROP TABLE IF EXISTS member_health_metrics;     -- Health metrics tracked for members.
DROP TABLE IF EXISTS personal_training_sessions; -- Records of personal training sessions.
DROP TABLE IF EXISTS payments;                  -- Payment transactions made by members.
DROP TABLE IF EXISTS class_attendance;          -- Attendance records for scheduled classes.
DROP TABLE IF EXISTS attendance;                -- General gym attendance records for members.
DROP TABLE IF EXISTS memberships;               -- Membership information for members.
DROP TABLE IF EXISTS class_schedule;            -- Schedule details for classes.
DROP TABLE IF EXISTS classes;                   -- Class offerings at the gym.
DROP TABLE IF EXISTS equipment;                 -- Equipment available at the gym.
DROP TABLE IF EXISTS staff;                     -- Details of staff members.
DROP TABLE IF EXISTS members;                   -- Details of gym members.
DROP TABLE IF EXISTS locations;                 -- Locations of gym branches.

-- Create locations table to store gym branch details.
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each location.
    name TEXT NOT NULL,                            -- Name of the location.
    address TEXT NOT NULL,                         -- Address of the location.
    phone_number TEXT,                             -- Phone number for the location.
    email TEXT,                                    -- Email address for the location.
    opening_hours TEXT                             -- Opening hours of the location.
);

-- Create members table to store details of gym members.
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique identifier for each member.
    first_name TEXT NOT NULL,                      -- First name of the member.
    last_name TEXT NOT NULL,                       -- Last name of the member.
    email TEXT NOT NULL UNIQUE,                    -- Unique email address of the member.
    phone_number TEXT,                             -- Phone number of the member.
    date_of_birth DATE,                            -- Date of birth of the member.
    join_date DATE NOT NULL,                       -- Date when the member joined the gym.
    emergency_contact_name TEXT,                  -- Name of the emergency contact.
    emergency_contact_phone TEXT                  -- Phone number of the emergency contact.
);

-- Create staff table to store details of gym employees.
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,    -- Unique identifier for each staff member.
    first_name TEXT NOT NULL,                      -- First name of the staff member.
    last_name TEXT NOT NULL,                       -- Last name of the staff member.
    email TEXT UNIQUE NOT NULL,                    -- Unique email address of the staff member.
    phone_number TEXT,                             -- Phone number of the staff member.
    position TEXT CHECK(position IN ('Trainer', 'Manager', 'Receptionist','Maintenance')) NOT NULL, -- Role of the staff member.
    hire_date DATE NOT NULL,                       -- Date when the staff member was hired.
    location_id INTEGER,                           -- Location ID linking the staff member to a branch.
    FOREIGN KEY (location_id) REFERENCES locations(location_id) -- Foreign key linking to the locations table.
);

-- Create equipment table to store details of gym equipment.
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each piece of equipment.
    name TEXT NOT NULL,                             -- Name of the equipment.
    type TEXT CHECK(type IN ('Cardio', 'Strength')) NOT NULL, -- Type of equipment (e.g., Cardio, Strength).
    purchase_date DATE,                             -- Date the equipment was purchased.
    last_maintenance_date DATE,                     -- Date the equipment was last maintained.
    next_maintenance_date DATE,                     -- Date for the next scheduled maintenance.
    location_id INTEGER,                            -- Location ID linking the equipment to a branch.
    FOREIGN KEY (location_id) REFERENCES locations(location_id) -- Foreign key linking to the locations table.
);

-- Create classes table to store details of gym classes.
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,     -- Unique identifier for each class.
    name TEXT NOT NULL,                             -- Name of the class (e.g., Yoga, Spin).
    description TEXT,                               -- Description of the class.
    capacity INTEGER NOT NULL,                      -- Maximum capacity for the class.
    duration INTEGER NOT NULL,                      -- Duration of the class in minutes.
    location_id INTEGER,                            -- Location ID linking the class to a branch.
    FOREIGN KEY (location_id) REFERENCES locations(location_id) -- Foreign key linking to the locations table.
);

-- Create class_schedule table to store schedule details for classes.
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique identifier for each schedule.
    class_id INTEGER,                               -- ID of the class being scheduled.
    staff_id INTEGER,                               -- ID of the instructor leading the class.
    start_time DATETIME NOT NULL,                   -- Start time of the class.
    end_time DATETIME NOT NULL,                     -- End time of the class.
    FOREIGN KEY (class_id) REFERENCES classes(class_id), -- Foreign key linking to the classes table.
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) -- Foreign key linking to the staff table.
);

-- Create memberships table to store details of memberships held by members.
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each membership.
    member_id INTEGER,                              -- ID of the member holding the membership.
    type TEXT NOT NULL,                             -- Type of membership (e.g., Monthly, Annual).
    start_date DATE NOT NULL,                       -- Start date of the membership.
    end_date DATE,                                  -- End date of the membership.
    status TEXT CHECK(status IN ('Active', 'Inactive')) NOT NULL, -- Status of the membership.
    FOREIGN KEY (member_id) REFERENCES members(member_id) -- Foreign key linking to the members table.
);

-- Create attendance table to store check-in and check-out times for members.
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each attendance record.
    member_id INTEGER,                               -- ID of the member attending.
    location_id INTEGER,                             -- ID of the location where the member checked in.
    check_in_time DATETIME NOT NULL,                 -- Time the member checked in.
    check_out_time DATETIME,                         -- Time the member checked out.
    FOREIGN KEY (member_id) REFERENCES members(member_id), -- Foreign key linking to the members table.
    FOREIGN KEY (location_id) REFERENCES locations(location_id) -- Foreign key linking to the locations table.
);

-- Create class_attendance table to store attendance records for classes.
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each class attendance record.
    schedule_id INTEGER,                               -- ID of the class schedule.
    member_id INTEGER,                                 -- ID of the member attending the class.
    attendance_status TEXT CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')) NOT NULL, -- Attendance status.
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id), -- Foreign key linking to the class_schedule table.
    FOREIGN KEY (member_id) REFERENCES members(member_id) -- Foreign key linking to the members table.
);

-- Create payments table to store payment records made by members.
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,     -- Unique identifier for each payment record.
    member_id INTEGER,                                -- ID of the member making the payment.
    amount REAL NOT NULL,                             -- Amount of the payment.
    payment_date DATE NOT NULL,                       -- Date of the payment.
    payment_method TEXT CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal','Cash')) NOT NULL, -- Payment method.
    payment_type TEXT CHECK(payment_type IN ('Monthly membership fee', 'Day pass')) NOT NULL, -- Type of payment.
    FOREIGN KEY (member_id) REFERENCES members(member_id) -- Foreign key linking to the members table.
);

-- Create personal_training_sessions table to store personal training session records.
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,     -- Unique identifier for each session.
    member_id INTEGER,                                -- ID of the member attending the session.
    staff_id INTEGER,                                 -- ID of the trainer leading the session.
    session_date DATE NOT NULL,                       -- Date of the session.
    start_time DATETIME NOT NULL,                     -- Start time of the session.
    end_time DATETIME NOT NULL,                       -- End time of the session.
    notes TEXT,                                       -- Additional notes for the session.
    FOREIGN KEY (member_id) REFERENCES members(member_id), -- Foreign key linking to the members table.
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) -- Foreign key linking to the staff table.
);

-- Create member_health_metrics table to track health metrics for members.
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,      -- Unique identifier for each health metric record.
    member_id INTEGER,                                -- ID of the member whose metrics are being tracked.
    measurement_date DATE NOT NULL,                   -- Date of the measurement.
    weight REAL,                                      -- Member's weight in kilograms.
    body_fat_percentage REAL,                         -- Member's body fat percentage.
    muscle_mass REAL,                                 -- Member's muscle mass in kilograms.
    bmi REAL,                                         -- Member's Body Mass Index (BMI).
    FOREIGN KEY (member_id) REFERENCES members(member_id) -- Foreign key linking to the members table.
);

-- Create equipment_maintenance_log table to track maintenance records for equipment.
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,         -- Unique identifier for each maintenance log.
    equipment_id INTEGER,                             -- ID of the equipment being maintained.
    maintenance_date DATE NOT NULL,                   -- Date of the maintenance.
    description TEXT,                                 -- Description of the maintenance performed.
    staff_id INTEGER,                                 -- ID of the staff member performing the maintenance.
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id), -- Foreign key linking to the equipment table.
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) -- Foreign key linking to the staff table.
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal