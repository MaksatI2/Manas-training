package manasTrainingService.repositories;

import manasTrainingService.entity.LessonProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonProgressRepository extends JpaRepository<LessonProgress, Integer> {
    List<LessonProgress> findAllByLessonId(Integer lessonId);
    List<LessonProgress> findAllByStudentId(Integer studentId);
}
