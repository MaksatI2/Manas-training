-- changeset Maksat: 024 create activity_logs table

CREATE TABLE activity_logs
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL,
    action      VARCHAR(100) NOT NULL,
    target_type VARCHAR(50),
    target_id   INTEGER,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);