CREATE TABLE test_instances
(
    id  SERIAL PRIMARY KEY,
    course_instance_id INTEGER REFERENCES course_instances (id),
    test_id INTEGER REFERENCES tests (id),
    scheduled_start TIMESTAMP,
    scheduled_end TIMESTAMP
);
