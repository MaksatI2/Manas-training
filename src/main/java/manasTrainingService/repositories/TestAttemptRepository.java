package manasTrainingService.repositories;

import manasTrainingService.entity.TestAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestAttemptRepository extends JpaRepository<TestAttempt, Integer> {
    List<TestAttempt> findAllByStudentId(int studentId);
    List<TestAttempt> findAllByTestId(int testId);
}
