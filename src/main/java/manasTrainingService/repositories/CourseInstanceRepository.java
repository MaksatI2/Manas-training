package manasTrainingService.repositories;

import manasTrainingService.entity.CourseInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseInstanceRepository extends JpaRepository<CourseInstance, Integer> {
    List<CourseInstance> findByCourseId(Integer courseId);
}
