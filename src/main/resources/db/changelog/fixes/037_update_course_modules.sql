-- changeset Maksat: 037 update course_modules table

ALTER TABLE course_modules
    DROP CONSTRAINT IF EXISTS course_modules_course_id_fkey;

ALTER TABLE course_modules
    DROP COLUMN course_id;

ALTER TABLE course_modules
    ADD COLUMN course_instance_id INTEGER NOT NULL;

ALTER TABLE course_modules
    ADD COLUMN duration_hours INTEGER;

ALTER TABLE course_modules
    ADD CONSTRAINT course_modules_course_instance_id_fkey
        FOREIGN KEY (course_instance_id) REFERENCES course_instances(id) ON DELETE CASCADE;