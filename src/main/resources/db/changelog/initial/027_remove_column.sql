-- changeset Maksat: 027 remove column email_verification_token

ALTER TABLE users
    DROP COLUMN IF EXISTS email_verification_token;