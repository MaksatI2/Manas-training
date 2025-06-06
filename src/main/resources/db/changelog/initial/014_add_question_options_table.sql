-- changeset Maksat: 014 create question_options table

CREATE TABLE question_options
(
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL,
    option_text TEXT,
    is_correct  BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (question_id) REFERENCES test_questions (id) ON DELETE CASCADE
);