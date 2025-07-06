-- changeset Maksat:056 create remember_me_tokens table

CREATE TABLE remember_me_tokens
(
    id           SERIAL PRIMARY KEY,
    token        VARCHAR(255) UNIQUE               NOT NULL,
    email        VARCHAR(255)                      NOT NULL,
    user_agent   VARCHAR(500),
    ip_address   VARCHAR(45),
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at   TIMESTAMP                         NOT NULL,
    last_used_at TIMESTAMP,
    is_active    BOOLEAN      DEFAULT TRUE         NOT NULL,
    user_id      BIGINT                           NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id)
);