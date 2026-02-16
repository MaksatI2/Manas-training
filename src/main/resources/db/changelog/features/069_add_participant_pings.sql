-- changeset Maksat:069 create participant_pings table

CREATE TABLE participant_pings
(
    id                     SERIAL PRIMARY KEY,
    meeting_participant_id INTEGER   NOT NULL,
    ping_time              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active              BOOLEAN   NOT NULL DEFAULT TRUE,
    connection_status      VARCHAR(50)        DEFAULT 'CONNECTED',

    CONSTRAINT fk_participant_pings_meeting_participant
        FOREIGN KEY (meeting_participant_id)
            REFERENCES meeting_participants (id)
            ON DELETE CASCADE
);

CREATE INDEX idx_participant_pings_participant_id ON participant_pings (meeting_participant_id);
CREATE INDEX idx_participant_pings_ping_time ON participant_pings (ping_time);
CREATE INDEX idx_participant_pings_active ON participant_pings (is_active);