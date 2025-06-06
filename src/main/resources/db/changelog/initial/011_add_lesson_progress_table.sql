-- changeset Maksat: 011 create lessons_progress table

CREATE TABLE lesson_progress
(
    id                 SERIAL PRIMARY KEY,
    lesson_id          INTEGER NOT NULL,
    student_id         INTEGER NOT NULL,
    started_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at       TIMESTAMP,
    time_spent_minutes INTEGER   DEFAULT 0,
    is_completed       BOOLEAN   DEFAULT FALSE,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE
);