-- changeset Maksat: 003 create student_profiles table
CREATE TYPE student_status AS ENUM ('active', 'graduated', 'suspended', 'dropped');

CREATE TABLE student_profiles
(
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER UNIQUE     NOT NULL,
    student_id     VARCHAR(20) UNIQUE NOT NULL,
    specialization VARCHAR(100),
    status         student_status     DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);