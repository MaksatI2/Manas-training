-- changeset Maksat: 003 create organizations table

CREATE TABLE organizations
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER,
    code        VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id)
);