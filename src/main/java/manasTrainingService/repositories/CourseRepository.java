package manasTrainingService.repositories;

import manasTrainingService.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Integer> {
    List<Course> findAllByTeacherId(Integer teacherId);
    List<Course> findAllByCategoryId(Integer categoryId);
}
