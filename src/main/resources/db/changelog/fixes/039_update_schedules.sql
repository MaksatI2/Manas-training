-- changeset Maksat: 039 update schedules table

ALTER TABLE schedules
    DROP CONSTRAINT IF EXISTS schedules_course_id_fkey;

ALTER TABLE schedules
    DROP COLUMN course_id;

ALTER TABLE schedules
    DROP COLUMN start_datetime;

ALTER TABLE schedules
    DROP COLUMN end_datetime;

ALTER TABLE schedules
    ADD COLUMN course_instance_id INTEGER NOT NULL;

ALTER TABLE schedules
    ADD COLUMN lesson_id INTEGER NOT NULL;

ALTER TABLE schedules
    ADD COLUMN lesson_date DATE NOT NULL;

ALTER TABLE schedules
    ADD COLUMN duration_hours INTEGER NOT NULL DEFAULT 1;

ALTER TABLE schedules
    ADD CONSTRAINT schedules_course_instance_id_fkey
        FOREIGN KEY (course_instance_id) REFERENCES course_instances(id);

ALTER TABLE schedules
    ADD CONSTRAINT schedules_lesson_id_fkey
        FOREIGN KEY (lesson_id) REFERENCES lessons(id);