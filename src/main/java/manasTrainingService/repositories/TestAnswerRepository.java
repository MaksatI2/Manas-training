package manasTrainingService.repositories;

import manasTrainingService.entity.TestAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestAnswerRepository extends JpaRepository<TestAnswer, Integer> {
    List<TestAnswer> findAllByQuestionId(int questionId);
}
