CREATE TABLE lesson_contents (
                                id SERIAL PRIMARY KEY,
                                lesson_id INT NOT NULL UNIQUE,
                                title VARCHAR(200) NOT NULL,
                                content TEXT NOT NULL,
                                CONSTRAINT fk_lesson_content_lesson FOREIGN KEY (lesson_id)
                                    REFERENCES lessons(id)
                                    ON DELETE CASCADE
);
