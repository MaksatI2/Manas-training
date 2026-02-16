-- changeset Maksat:071-add-public-certificate-fields

ALTER TABLE certificates
    ADD COLUMN is_public BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE certificates
    ADD COLUMN public_token VARCHAR(36);

CREATE UNIQUE INDEX ux_certificates_public_token
    ON certificates (public_token)
    WHERE public_token IS NOT NULL;
