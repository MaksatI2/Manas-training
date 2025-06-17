package manasTrainingService.repositories;

import manasTrainingService.entity.CourseApplicationEmployee;
import manasTrainingService.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseApplicationEmployeeRepository extends JpaRepository<CourseApplicationEmployee, Integer> {
    List<CourseApplicationEmployee> findByApplicationId(Integer applicationId);
    List<CourseApplicationEmployee> findByEmployeeId(Integer employeeId);

    Optional<CourseApplicationEmployee> findByApplicationIdAndEmployeeId(Integer applicationId, Integer employeeId);
    List<CourseApplicationEmployee> findByApplicationCourseIdAndApplicationStatus(Integer courseId, Status status);
}
