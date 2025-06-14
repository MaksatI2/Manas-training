-- changeset Maksat: 035 update course_application_employees table

ALTER TABLE course_application_employees
    ADD COLUMN application_status VARCHAR(50) DEFAULT 'pending';