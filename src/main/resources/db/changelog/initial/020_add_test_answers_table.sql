-- changeset Maksat: 020 create test_answers table

CREATE TABLE test_answers
(
    id                 SERIAL PRIMARY KEY,
    attempt_id         INTEGER NOT NULL REFERENCES test_results (id),
    question_id        INTEGER NOT NULL REFERENCES test_questions (id),
    selected_option_id INTEGER REFERENCES question_options (id),
    is_correct         BOOLEAN,
    points_earned      DECIMAL(5, 2) DEFAULT 0
);