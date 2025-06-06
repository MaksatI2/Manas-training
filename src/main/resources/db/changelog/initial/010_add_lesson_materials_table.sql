-- changeset Maksat: 010 create lessons_materials table

CREATE TABLE lesson_materials
(
    id        SERIAL PRIMARY KEY,
    lesson_id INTEGER      NOT NULL,
    title     VARCHAR(200) NOT NULL,
    file_url  VARCHAR(500) NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE
);