-- changeset Maksat:059 alter activity_logs user_id FK to add ON DELETE CASCADE
ALTER TABLE activity_logs
    DROP CONSTRAINT activity_logs_user_id_fkey;
ALTER TABLE activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;