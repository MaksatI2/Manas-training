-- changeset Maksat: 017 create schedules table

CREATE TABLE schedules
(
    id             SERIAL PRIMARY KEY,
    course_id      INTEGER   NOT NULL,
    teacher_id     INTEGER   NOT NULL,
    title          VARCHAR(200),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime   TIMESTAMP NOT NULL,
    is_online      BOOLEAN DEFAULT FALSE,
    meeting_url    VARCHAR(500),
    notes          TEXT,
    is_active      BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users (id) ON DELETE RESTRICT
);