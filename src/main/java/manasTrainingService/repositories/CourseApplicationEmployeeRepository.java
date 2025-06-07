package manasTrainingService.repositories;

import manasTrainingService.entity.CourseApplicationEmployee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseApplicationEmployeeRepository extends JpaRepository<CourseApplicationEmployee, Integer> {
    List<CourseApplicationEmployee> findByApplicationId(Integer applicationId);
    List<CourseApplicationEmployee> findByEmployeeId(Integer employeeId);

}
