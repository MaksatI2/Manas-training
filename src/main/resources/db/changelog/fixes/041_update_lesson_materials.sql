-- changeset Maksat: 041 update lesson_materials table
ALTER TABLE lesson_materials
    RENAME COLUMN file_url TO url;