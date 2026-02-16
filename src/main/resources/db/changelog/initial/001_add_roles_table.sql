-- changeset Maksat: 001 create authorities table

CREATE TABLE roles
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE
);