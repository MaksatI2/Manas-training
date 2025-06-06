-- changeset Maksat: 015 create test_attempts table
CREATE TYPE attempt_status AS ENUM ('in_progress', 'submitted', 'graded');

CREATE TABLE test_attempts
(
    id                 SERIAL PRIMARY KEY,
    test_id            INTEGER NOT NULL,
    student_id         INTEGER NOT NULL,
    attempt_number     INTEGER NOT NULL,
    started_at         TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    submitted_at       TIMESTAMP,
    score              DECIMAL(5, 2),
    max_score          DECIMAL(5, 2),
    percentage         DECIMAL(5, 2),
    is_passed          BOOLEAN        DEFAULT FALSE,
    time_spent_minutes INTEGER,
    status             attempt_status DEFAULT 'in_progress',
    FOREIGN KEY (test_id) REFERENCES tests (id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE
);