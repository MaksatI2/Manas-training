-- changeset Maksat: 008 create course_applications table
CREATE TYPE application_status AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE course_applications
(
    id                   SERIAL PRIMARY KEY,
    course_id            INTEGER NOT NULL,
    organization_id      INTEGER,
    submitted_by         INTEGER NOT NULL,
    preferred_teacher_id INTEGER,
    preferred_start_date DATE,
    preferred_end_date   DATE,
    status               application_status DEFAULT 'pending',
    submitted_at         TIMESTAMP          DEFAULT CURRENT_TIMESTAMP,
    processed_by         INTEGER,
    processed_at         TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses (id),
    FOREIGN KEY (organization_id) REFERENCES organizations (id),
    FOREIGN KEY (submitted_by) REFERENCES users (id),
    FOREIGN KEY (preferred_teacher_id) REFERENCES users (id),
    FOREIGN KEY (processed_by) REFERENCES users (id)
);