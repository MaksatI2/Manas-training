package manasTrainingService.repositories.course;

import manasTrainingService.entity.CourseModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseModuleRepository extends JpaRepository<CourseModule, Integer> {
    List<CourseModule> findAllByCourseInstanceId(Integer courseId);
    List<CourseModule> findByCourseInstanceId(Integer courseInstanceId);
    @Query("SELECT SUM(cm.durationHours) FROM CourseModule cm WHERE cm.courseInstance.id = :courseInstanceId")
    Integer sumDurationHoursByCourseInstanceId(Integer courseInstanceId);

    List<CourseModule> findByCourseInstanceIdOrderByOrderIndexAsc(Integer courseInstanceId);
}
