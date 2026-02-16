-- changeset Maksat: 030 create application_comments table

CREATE TABLE application_comments
(
    id             SERIAL PRIMARY KEY,
    admin_id       INTEGER NOT NULL REFERENCES users (id),
    comment        TEXT,
    application_id INTEGER NOT NULL REFERENCES course_applications (id),
    created_at     TIMESTAMP
);