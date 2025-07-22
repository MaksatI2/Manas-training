CREATE TABLE notifications
(
    id                SERIAL PRIMARY KEY,
    user_id           INT          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    target_type       VARCHAR(100) NOT NULL,
    target_id         INT          NOT NULL,
    notification_type VARCHAR(100) NOT NULL,
    title             VARCHAR(255) NOT NULL,
    body              TEXT,
    is_read           BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);
