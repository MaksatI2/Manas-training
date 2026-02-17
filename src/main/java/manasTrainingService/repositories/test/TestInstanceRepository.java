package manasTrainingService.repositories.test;

import manasTrainingService.entity.TestInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TestInstanceRepository extends JpaRepository<TestInstance, Integer> {

    Optional<TestInstance> findByInstanceId(Integer instanceId);
    Boolean existsByInstanceId(Integer instanceId);

    @Query("""
            SELECT ti FROM TestInstance ti
            JOIN FETCH ti.instance i
            JOIN FETCH ti.test t
            JOIN FETCH t.course c
            WHERE i.id = :instanceId
            """)
    Optional<TestInstance> findByInstanceIdWithDetails(@Param("instanceId") Integer instanceId);
}
