-- changeset Maksat: 016 create test_answers table

CREATE TABLE test_answers
(
    id               SERIAL PRIMARY KEY,
    attempt_id       INTEGER NOT NULL,
    question_id      INTEGER NOT NULL,
    selected_options JSONB,
    text_answer      TEXT,
    is_correct       BOOLEAN,
    points_earned    DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (attempt_id) REFERENCES test_attempts (id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES test_questions (id) ON DELETE CASCADE
);