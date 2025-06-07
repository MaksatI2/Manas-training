-- changeset Maksat: 019 create test_attempts table

CREATE TABLE test_results
(
    id                 SERIAL PRIMARY KEY,
    test_id            INTEGER NOT NULL REFERENCES tests (id),
    student_id         INTEGER NOT NULL REFERENCES users (id),
    started_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submitted_at       TIMESTAMP,
    score              DECIMAL(5, 2),
    percentage         DECIMAL(5, 2),
    is_passed          BOOLEAN   DEFAULT FALSE,
    time_spent_minutes INTEGER
);