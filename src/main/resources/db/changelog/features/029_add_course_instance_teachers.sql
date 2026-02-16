-- changeset Maksat: 029 create course_instance_teachers table

CREATE TABLE course_instance_teachers
(
    id                 SERIAL PRIMARY KEY,
    course_instance_id INTEGER NOT NULL REFERENCES course_instances (id),
    teacher_id         INTEGER NOT NULL REFERENCES users (id),
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_primary         BOOLEAN,
    UNIQUE (course_instance_id, teacher_id)
);