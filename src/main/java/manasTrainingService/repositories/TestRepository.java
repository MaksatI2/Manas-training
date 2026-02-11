package manasTrainingService.repositories;

import manasTrainingService.entity.Test;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TestRepository extends JpaRepository<Test, Integer> {
    List<Test> findAllByCourseId(Integer courseId);
    Optional<Test> findByCourseId(Integer courseId);
    Boolean existsById(int id);
}
