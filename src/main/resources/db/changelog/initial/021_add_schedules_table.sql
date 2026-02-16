-- changeset Maksat: 021 create schedules table

CREATE TABLE schedules
(
    id             SERIAL PRIMARY KEY,
    course_id      INTEGER          NOT NULL REFERENCES courses (id),
    teacher_id     INTEGER          NOT NULL REFERENCES users (id),
    title          VARCHAR(200),
    lesson_type    VARCHAR(50) NOT NULL,
    start_datetime TIMESTAMP        NOT NULL,
    end_datetime   TIMESTAMP        NOT NULL,
    is_online      BOOLEAN DEFAULT FALSE,
    meeting_url    VARCHAR(500),
    notes          TEXT,
    is_active      BOOLEAN DEFAULT TRUE
);