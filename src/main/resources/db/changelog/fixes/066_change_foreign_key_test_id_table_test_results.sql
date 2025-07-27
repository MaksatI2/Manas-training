ALTER TABLE test_results
DROP CONSTRAINT test_results_test_id_fkey;

ALTER TABLE test_results
RENAME COLUMN test_id to test_instance_id;

ALTER TABLE test_results
ADD CONSTRAINT fk_test_result_test_instance_id_fkey FOREIGN KEY (test_instance_id) REFERENCES test_instances(id);