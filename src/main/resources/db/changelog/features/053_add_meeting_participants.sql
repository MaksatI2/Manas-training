-- changeset Maksat:053 create meeting_participants table

CREATE TABLE meeting_participants
(
    id               SERIAL PRIMARY KEY,
    meeting_id       INTEGER   NOT NULL REFERENCES meetings (id),
    user_id          INTEGER REFERENCES users (id),
    participant_name VARCHAR(100),
    participant_id   VARCHAR(100),
    joined_at        TIMESTAMP NOT NULL,
    left_at          TIMESTAMP,
    duration_seconds INTEGER,
    is_moderator     BOOLEAN   NOT NULL DEFAULT FALSE
);
