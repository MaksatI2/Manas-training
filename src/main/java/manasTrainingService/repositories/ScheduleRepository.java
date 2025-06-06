package manasTrainingService.repositories;

import manasTrainingService.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {
    Optional<Schedule> findByCourseId(Integer courseId);
    Optional<Schedule> findByTeacherId(Integer teacherId);
}
