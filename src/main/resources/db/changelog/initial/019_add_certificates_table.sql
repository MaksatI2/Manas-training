-- changeset Maksat: 019 create certificates table

CREATE TABLE certificates
(
    id                 SERIAL PRIMARY KEY,
    student_id         INTEGER            NOT NULL,
    course_id          INTEGER            NOT NULL,
    certificate_number VARCHAR(50) UNIQUE NOT NULL,
    issue_date         DATE               NOT NULL,
    expiry_date        DATE,
    template_name      VARCHAR(100),
    certificate_url    VARCHAR(500),
    is_active          BOOLEAN   DEFAULT TRUE,
    issued_by          INTEGER            NOT NULL,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE

);