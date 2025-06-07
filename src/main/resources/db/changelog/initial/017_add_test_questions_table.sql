-- changeset Maksat: 017 create test_questions table

CREATE TABLE test_questions
(
    id          SERIAL PRIMARY KEY,
    test_id     INTEGER NOT NULL,
    question    TEXT,
    points      DECIMAL(5, 2) DEFAULT 1.00,
    is_required BOOLEAN       DEFAULT TRUE,
    FOREIGN KEY (test_id) REFERENCES tests (id) ON DELETE CASCADE
);