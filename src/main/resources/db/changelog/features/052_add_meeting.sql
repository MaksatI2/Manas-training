-- changeset Maksat:052 create meetings table

CREATE TABLE meetings
(
    id          SERIAL PRIMARY KEY,
    schedule_id INTEGER      NOT NULL UNIQUE REFERENCES schedules (id),
    meeting_id  VARCHAR(100) NOT NULL UNIQUE,
    room_name   VARCHAR(100) NOT NULL,
    meeting_url VARCHAR(500) NOT NULL,
    started_at  TIMESTAMP,
    ended_at    TIMESTAMP,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
