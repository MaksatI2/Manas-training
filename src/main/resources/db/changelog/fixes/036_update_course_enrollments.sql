-- changeset Maksat:036 update course enrollments table

CREATE TEMPORARY TABLE temp_course_instances AS
SELECT MIN(id) as instance_id, course_id
FROM course_instances
GROUP BY course_id;

ALTER TABLE course_enrollments
    ADD COLUMN course_instance_id INTEGER;

UPDATE course_enrollments ce
SET course_instance_id = tci.instance_id
    FROM temp_course_instances tci
WHERE tci.course_id = ce.course_id;

DROP TABLE temp_course_instances;

INSERT INTO course_instances (course_id, title, start_date, end_date)
SELECT DISTINCT ce.course_id,
                c.title || ' - Default Instance',
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP + interval '30 days'
FROM course_enrollments ce
         JOIN courses c ON ce.course_id = c.id
WHERE ce.course_instance_id IS NULL;

UPDATE course_enrollments ce
SET course_instance_id = ci.id
    FROM course_instances ci
WHERE ci.course_id = ce.course_id AND ce.course_instance_id IS NULL;

ALTER TABLE course_enrollments
    ALTER COLUMN course_instance_id SET NOT NULL;

ALTER TABLE course_enrollments
    DROP CONSTRAINT IF EXISTS course_enrollments_course_id_fkey;

ALTER TABLE course_enrollments
    DROP CONSTRAINT IF EXISTS course_enrollments_course_id_student_id_key;

ALTER TABLE course_enrollments
    DROP COLUMN course_id;

ALTER TABLE course_enrollments
    ADD CONSTRAINT course_enrollments_course_instance_id_fkey
        FOREIGN KEY (course_instance_id) REFERENCES course_instances(id) ON DELETE CASCADE;

ALTER TABLE course_enrollments
    ADD CONSTRAINT course_enrollments_course_instance_id_student_id_key
        UNIQUE (course_instance_id, student_id);