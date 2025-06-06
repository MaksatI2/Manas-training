package manasTrainingService.repositories;

import manasTrainingService.entity.CourseModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseModuleRepository extends JpaRepository<CourseModule, Integer> {
    List<CourseModule> findAllByCourseId(Integer courseId);
}
