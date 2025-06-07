-- changeset Maksat: 004 create student_profiles table

CREATE TABLE student_profiles
(
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER UNIQUE NOT NULL,
    organization_id INTEGER,
    specialization  VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (organization_id) REFERENCES organizations (id)
);