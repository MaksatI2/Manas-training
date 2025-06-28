package manasTrainingService.repositories.quiz;

import manasTrainingService.entity.LessonQuiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LessonQuizRepository extends JpaRepository<LessonQuiz, Integer> {

    Optional<LessonQuiz> findByLessonId(Integer lessonId);
}
