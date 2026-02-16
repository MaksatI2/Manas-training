ALTER TABLE tests
DROP CONSTRAINT IF EXISTS tests_course_instance_id_fkey,
    DROP COLUMN IF EXISTS course_instance_id,
    DROP COLUMN IF EXISTS scheduled_start,
    DROP COLUMN IF EXISTS scheduled_end,
    ADD COLUMN course_id INTEGER NOT NULL,
    ADD CONSTRAINT fk_tests_course FOREIGN KEY (course_id) REFERENCES courses(id);
