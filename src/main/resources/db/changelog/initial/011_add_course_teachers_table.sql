-- changeset Maksat: 011 create course_teachers table

CREATE TABLE course_teachers
(
    id         SERIAL PRIMARY KEY,
    course_id  INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses (id),
    FOREIGN KEY (teacher_id) REFERENCES users (id),
    UNIQUE (course_id, teacher_id)
);