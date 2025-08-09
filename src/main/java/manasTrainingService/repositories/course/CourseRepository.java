package manasTrainingService.repositories.course;

import manasTrainingService.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Integer> {

    boolean existsByCode(String code);

    boolean existsByCodeAndIdNot(String code, Integer id);

    List<Course> findByCategoryId(Integer categoryId);

    boolean existsByTitle(String title);

    boolean existsByTitleAndIdNot(String title, Integer id);
}
