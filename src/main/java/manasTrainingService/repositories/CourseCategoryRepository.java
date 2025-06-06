package manasTrainingService.repositories;

import manasTrainingService.entity.CourseCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CourseCategoryRepository extends JpaRepository<CourseCategory, Integer> {
    Optional<CourseCategory> findByName(String name);
}
