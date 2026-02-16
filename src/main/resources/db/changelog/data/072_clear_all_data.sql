-- changeset Maksat:072-clear-all-data
DO $$
DECLARE
    record_row RECORD;
BEGIN
    FOR record_row IN (
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public'
          AND tablename NOT IN ('databasechangelog', 'databasechangeloglock')
    ) LOOP
        EXECUTE 'TRUNCATE TABLE ' || quote_ident(record_row.tablename) || ' RESTART IDENTITY CASCADE';
    END LOOP;
END $$;
