-- changeset Maksat: 004 create teacher_profiles table

CREATE TABLE teacher_profiles
(
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER UNIQUE     NOT NULL,
    employee_id    VARCHAR(20) UNIQUE NOT NULL,
    department     VARCHAR(100),
    qualifications TEXT,
    bio            TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);