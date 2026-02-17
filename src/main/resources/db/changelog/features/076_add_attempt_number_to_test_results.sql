-- changeset Maksat: 076 add attempt_number column to test_results table

ALTER TABLE test_results
ADD COLUMN attempt_number INTEGER NOT NULL DEFAULT 1;