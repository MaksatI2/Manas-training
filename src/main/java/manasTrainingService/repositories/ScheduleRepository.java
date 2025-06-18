package manasTrainingService.repositories;

import manasTrainingService.entity.LessonType;
import manasTrainingService.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {
    Optional<Schedule> findByTeacherId(Integer teacherId);
    List<Schedule> findAllByLessonType(LessonType lessonType);
    Optional<Schedule> findByLessonId(Integer lessonId);
}
