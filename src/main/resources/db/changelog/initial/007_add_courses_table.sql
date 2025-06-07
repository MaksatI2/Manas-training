-- changeset Maksat: 007 create courses table

CREATE TABLE courses
(
    id             SERIAL PRIMARY KEY,
    category_id    INTEGER,
    is_individual  BOOLEAN,
    code           VARCHAR(20) UNIQUE NOT NULL,
    title          VARCHAR(200),
    description    TEXT,
    duration_hours INTEGER            NOT NULL,
    is_active      BOOLEAN   DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES course_categories (id) ON DELETE SET NULL
);