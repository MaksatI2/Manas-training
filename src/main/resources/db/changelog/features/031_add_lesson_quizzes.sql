-- changeset Maksat: 031 create lesson_quizzes table

CREATE TABLE lesson_quizzes
(
    id                  SERIAL PRIMARY KEY,
    lesson_id           INTEGER      NOT NULL REFERENCES lessons (id),
    question_time_limit INTEGER,
    title               VARCHAR(200) NOT NULL,
    description         TEXT,
    is_active           BOOLEAN DEFAULT TRUE
);