package manasTrainingService.repositories;

import manasTrainingService.entity.Course;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Integer> {
    List<Course> findAllByCategoryId(Integer categoryId);
    Page<Course> findByCategoryId(Integer categoryId, Pageable pageable);
    Page<Course> findByTitleContainingIgnoreCaseOrCodeContainingIgnoreCaseAndCategoryId(
            String title, String code, Integer categoryId, Pageable pageable);
}
