-- changeset Maksat: 012 create tests table

CREATE TABLE tests
(
    id                 SERIAL PRIMARY KEY,
    course_id          INTEGER,
    lesson_id          INTEGER,
    title              VARCHAR(200),
    description        TEXT,
    time_limit_minutes INTEGER       DEFAULT 60,
    max_attempts       INTEGER       DEFAULT 3,
    passing_score      DECIMAL(5, 2) DEFAULT 70.00,
    FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE
);