-- changeset Maksat: 002 create users table

CREATE TABLE users
(
    id             SERIAL PRIMARY KEY,
    email          VARCHAR(255) UNIQUE                  NOT NULL,
    password_hash  VARCHAR(255)                         NOT NULL,
    first_name     VARCHAR(100)                         NOT NULL,
    last_name      VARCHAR(100)                         NOT NULL,
    phone          VARCHAR(20),
    avatar_url     VARCHAR(500),
    role_id           INT,
    is_active      BOOLEAN   DEFAULT TRUE,
    email_verified BOOLEAN   DEFAULT FALSE,
    FOREIGN KEY (role_id) REFERENCES roles (id)
);