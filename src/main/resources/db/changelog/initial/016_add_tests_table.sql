-- changeset Maksat: 016 create tests table

CREATE TABLE tests
(
    id              SERIAL PRIMARY KEY,
    course_id       INTEGER REFERENCES courses (id),
    lesson_id       INTEGER REFERENCES lessons (id),
    title           VARCHAR(200),
    description     TEXT,
    passing_score   DECIMAL(5, 2) DEFAULT 70.00,
    scheduled_start TIMESTAMP,
    scheduled_end   TIMESTAMP,
    is_active       BOOLEAN       DEFAULT TRUE
);