-- changeset Maksat: 038 update tests table

ALTER TABLE tests
    DROP CONSTRAINT IF EXISTS tests_course_id_fkey;

ALTER TABLE tests
    DROP CONSTRAINT IF EXISTS tests_lesson_id_fkey;

ALTER TABLE tests
    DROP COLUMN IF EXISTS course_id;

ALTER TABLE tests
    DROP COLUMN IF EXISTS lesson_id;

ALTER TABLE tests
    ADD COLUMN course_instance_id INTEGER NOT NULL;

ALTER TABLE tests
    ADD CONSTRAINT tests_course_instance_id_fkey
        FOREIGN KEY (course_instance_id) REFERENCES course_instances(id);