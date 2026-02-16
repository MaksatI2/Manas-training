package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseApplication;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CourseApplicationRepository extends JpaRepository<CourseApplication, Integer> {
    List<CourseApplication> findBySubmittedById(Integer userId);

    List<CourseApplication> findByOrganizationId(Integer organizationId);

    List<CourseApplication> findByStatus(Status status);

    List<CourseApplication> findByPreferredTeacherId(Integer teacherId);

    List<CourseApplication> findBySubmittedAtBetween(LocalDateTime start, LocalDateTime end);

    List<CourseApplication> findByProcessedById(Integer adminId);

    boolean existsBySubmittedByIdAndCourseId(Integer userId, Integer courseId);

    List<CourseApplication> findByCourseId(Integer courseId);

    @Query("""
                SELECT a FROM CourseApplication a
                LEFT JOIN FETCH a.organization
                LEFT JOIN FETCH a.course
                WHERE a.id = :id
            """)
    Optional<CourseApplication> findDetailedById(@Param("id") Integer id);

    boolean existsBySubmittedByAndCourseIdAndStatusIn(
            User submittedBy, Integer courseId, List<Status> statuses
    );

    boolean existsBySubmittedByAndCourseIdAndStatusInAndIdNot(
            User submittedBy, Integer courseId, List<Status> statuses, Integer id
    );

}


