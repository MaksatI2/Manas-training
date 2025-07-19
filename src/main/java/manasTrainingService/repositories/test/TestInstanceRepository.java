package manasTrainingService.repositories.test;

import manasTrainingService.entity.TestInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TestInstanceRepository extends JpaRepository<TestInstance, Integer> {

    @Query(value = "Select ti from TestInstance ti where ti.instance.id = :courseInstanceId")
    Optional<TestInstance> findByCourseInstanceId(@Param("courseInstanceId") Integer courseInstanceId);
}
