-- changeset Maksat: 032 create lesson_quiz_questions table

CREATE TABLE lesson_quiz_questions
(
    id       SERIAL PRIMARY KEY,
    quiz_id  INTEGER NOT NULL REFERENCES lesson_quizzes (id),
    question TEXT    NOT NULL,
    points   DECIMAL(5, 2) DEFAULT 1.00
);