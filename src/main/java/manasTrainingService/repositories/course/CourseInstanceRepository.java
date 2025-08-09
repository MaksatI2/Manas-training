package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseInstance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseInstanceRepository extends JpaRepository<CourseInstance, Integer> {
    List<CourseInstance> findByCourseId(Integer courseId);

    List<CourseInstance> findAllByIsActiveTrue();

    @Query("""
                SELECT DISTINCT ci
                FROM CourseInstance ci
                JOIN ci.enrollments ce
                WHERE ce.student.id IN (
                    SELECT sp.user.id
                    FROM StudentProfile sp
                    WHERE sp.organization.id = :organizationId
                )
            """)
    List<CourseInstance> findAllByOrganizationId(@Param("organizationId") Integer organizationId);

    long countByIsActiveFalse();

    List<CourseInstance> findAllByOrderByIsActiveDesc();

    boolean existsByTitle(String title);

    boolean existsByTitleAndIdNot(String title, Integer id);

}
