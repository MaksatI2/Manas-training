-- changeset Maksat: 006 create course_categories table

CREATE TABLE course_categories
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200),
    description TEXT
);