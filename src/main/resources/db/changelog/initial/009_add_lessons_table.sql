-- changeset Maksat: 009 create lessons table

CREATE TABLE lessons
(
    id               SERIAL PRIMARY KEY,
    module_id        INTEGER      NOT NULL,
    title            VARCHAR(200),
    content          TEXT,
    duration_minutes INTEGER DEFAULT 0,
    FOREIGN KEY (module_id) REFERENCES course_modules (id) ON DELETE CASCADE
);