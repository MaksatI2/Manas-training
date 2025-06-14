-- changeset Maksat: 028 create course_instances table

CREATE TABLE course_instances
(
    id         SERIAL PRIMARY KEY,
    course_id  INTEGER   NOT NULL REFERENCES courses (id),
    title      VARCHAR(200),
    start_date TIMESTAMP NOT NULL,
    end_date   TIMESTAMP NOT NULL,
    is_active  BOOLEAN   DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);