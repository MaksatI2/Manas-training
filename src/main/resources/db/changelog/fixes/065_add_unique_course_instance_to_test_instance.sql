ALTER TABLE test_instances
    ADD CONSTRAINT uq_test_instances_course_instance UNIQUE (course_instance_id);