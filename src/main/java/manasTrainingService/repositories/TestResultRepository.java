package manasTrainingService.repositories;

import manasTrainingService.entity.TestResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestResultRepository extends JpaRepository<TestResult, Integer> {
    List<TestResult> findAllByStudentId(int studentId);
    List<TestResult> findAllByTestId(int testId);
}
