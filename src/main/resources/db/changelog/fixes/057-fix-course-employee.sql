
ALTER TABLE course_application_employees
    ALTER COLUMN application_status SET DEFAULT 'PENDING';

UPDATE course_application_employees
SET application_status = 'PENDING'
WHERE application_status = 'pending';

