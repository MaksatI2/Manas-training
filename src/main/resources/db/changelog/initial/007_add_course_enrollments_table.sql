-- changeset Maksat: 007 create course_enrollments table

CREATE TYPE enrollment_status AS ENUM ('enrolled', 'in_progress', 'completed', 'dropped');

CREATE TABLE course_enrollments
(
    id                  SERIAL PRIMARY KEY,
    course_id           INTEGER NOT NULL,
    student_id          INTEGER NOT NULL,
    enrollment_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date     TIMESTAMP,
    status              enrollment_status DEFAULT 'enrolled',
    progress_percentage DECIMAL(5, 2)     DEFAULT 0,
    final_grade         DECIMAL(5, 2),
    FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    UNIQUE (course_id, student_id)
);