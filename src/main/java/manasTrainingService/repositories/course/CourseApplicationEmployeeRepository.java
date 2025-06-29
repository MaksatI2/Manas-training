package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.Status;
import manasTrainingService.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseApplicationEmployeeRepository extends JpaRepository<CourseApplicationEmployee, Integer> {
    List<CourseApplicationEmployee> findByApplicationId(Integer applicationId);

    List<CourseApplicationEmployee> findByEmployeeId(Integer employeeId);

    Optional<CourseApplicationEmployee> findByApplicationIdAndEmployeeId(Integer applicationId, Integer employeeId);

    List<CourseApplicationEmployee> findByApplicationCourseIdAndApplicationStatus(Integer courseId, Status status);

    List<CourseApplicationEmployee> findByApplication_Course_IdAndApplicationStatus(Integer courseId, Status status);

    @Query("""
                SELECT cae.employee FROM CourseApplicationEmployee cae
                WHERE cae.application.id = :applicationId
            """)
    List<User> findEmployeesByApplicationId(@Param("applicationId") Integer applicationId);


}
