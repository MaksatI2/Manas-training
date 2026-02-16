ALTER TABLE certificates
    ADD COLUMN course_instance_id INT NOT NULL;

UPDATE certificates AS c
SET course_instance_id = sub.id
    FROM (
             SELECT DISTINCT ON (ci.course_id)
                 ci.course_id,
                 ci.id
             FROM course_instances ci
             WHERE ci.is_active = TRUE
             ORDER BY ci.course_id, ci.start_date DESC
         ) AS sub
WHERE c.course_id = sub.course_id;

ALTER TABLE certificates
    ADD CONSTRAINT fk_certificate_course_instance
        FOREIGN KEY (course_instance_id)
            REFERENCES course_instances (id);

ALTER TABLE certificates
    DROP COLUMN course_id;