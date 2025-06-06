-- changeset Maksat: 006 create courses table

CREATE TABLE courses
(
    id             SERIAL PRIMARY KEY,
    category_id    INTEGER,
    code           VARCHAR(20) UNIQUE NOT NULL,
    title          VARCHAR(200),
    description    TEXT,
    teacher_id     INTEGER            NOT NULL,
    duration_hours INTEGER            NOT NULL,
    is_active      BOOLEAN   DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES course_categories (id) ON DELETE SET NULL,
    FOREIGN KEY (teacher_id) REFERENCES users (id) ON DELETE RESTRICT
);