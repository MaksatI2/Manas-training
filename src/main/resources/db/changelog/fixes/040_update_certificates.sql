-- changeset Maksat: 040 update certificates table
ALTER TABLE certificates
    ADD COLUMN mark INTEGER;

ALTER TABLE certificates
    ADD CONSTRAINT certificates_issued_by_fkey
        FOREIGN KEY (issued_by) REFERENCES users(id);