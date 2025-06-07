package manasTrainingService.repositories;

import manasTrainingService.entity.CourseApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface CourseApplicationRepository extends JpaRepository<CourseApplication, Integer> {
    List<CourseApplication> findBySubmittedById(Integer userId);
    List<CourseApplication> findByOrganizationId(Integer organizationId);
    List<CourseApplication> findByStatus(CourseApplication.ApplicationStatus status);
    List<CourseApplication> findByPreferredTeacherId(Integer teacherId);
    List<CourseApplication> findBySubmittedAtBetween(LocalDateTime start, LocalDateTime end);
    List<CourseApplication> findByProcessedById(Integer adminId);
    boolean existsBySubmittedByIdAndCourseId(Integer userId, Integer courseId);
    List<CourseApplication> findByCourseId(Integer courseId);
}
