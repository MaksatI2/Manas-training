-- changeset Maksat: 033 create lesson_quiz_options table

CREATE TABLE lesson_quiz_options
(
    id          SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES lesson_quiz_questions (id),
    option_text TEXT    NOT NULL,
    is_correct  BOOLEAN DEFAULT FALSE
);