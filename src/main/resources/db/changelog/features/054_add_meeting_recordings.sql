-- changeset Maksat:054 create meeting_recordings table

CREATE TABLE meeting_recordings
(
    id               SERIAL PRIMARY KEY,
    meeting_id       INTEGER      NOT NULL REFERENCES meetings (id),
    recording_id     VARCHAR(100) NOT NULL UNIQUE,
    file_name        VARCHAR(255) NOT NULL,
    file_path        VARCHAR(500) NOT NULL,
    file_url         VARCHAR(500),
    file_size        BIGINT,
    duration_seconds INTEGER,
    started_at       TIMESTAMP    NOT NULL,
    completed_at     TIMESTAMP,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_available     BOOLEAN      NOT NULL DEFAULT FALSE
);
