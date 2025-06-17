package manasTrainingService.repositories;

import manasTrainingService.entity.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Integer> {
    List<Lesson> findAllByModuleId(Integer moduleId);
    List<Lesson> findByModuleId(Integer moduleId);
    @Query("SELECT SUM(l.durationMinutes) FROM Lesson l WHERE l.module.id = :moduleId")
    Integer sumDurationMinutesByModuleId(Integer moduleId);
}
