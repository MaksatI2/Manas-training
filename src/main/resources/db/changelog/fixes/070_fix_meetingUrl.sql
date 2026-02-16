-- changeset Maksat:070 delete column meeting_url to meetings and schedules tables

-- 1. Remove meeting_url column from meetings table
ALTER TABLE meetings DROP COLUMN IF EXISTS meeting_url;

-- 2. Remove meeting_url column from schedules table
ALTER TABLE schedules DROP COLUMN IF EXISTS meeting_url;
