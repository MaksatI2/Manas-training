-- changeset Maksat: 022 create attendance table

CREATE TABLE attendance
(
    id            SERIAL PRIMARY KEY,
    schedule_id   INTEGER           NOT NULL,
    student_id    INTEGER           NOT NULL,
    status        VARCHAR(50) NOT NULL,
    check_in_time TIMESTAMP,
    marked_by     INTEGER           NOT NULL,
    marked_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES schedules (id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES users (id) ON DELETE RESTRICT
);