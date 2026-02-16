-- changeset Maksat: 012 create course_modules table

CREATE TABLE course_modules
(
    id          SERIAL PRIMARY KEY,
    course_id   INTEGER NOT NULL,
    title       VARCHAR(200),
    description TEXT,
    order_index INTEGER NOT NULL,
    is_active   BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
);