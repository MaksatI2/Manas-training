package manasTrainingService.repositories.test;

import manasTrainingService.entity.TestResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TestResultRepository extends JpaRepository<TestResult, Integer> {
    List<TestResult> findAllByStudentId(int studentId);

    List<TestResult> findAllByTestId(int testId);

    Optional<TestResult> findByStudentId(int studentId);

    Boolean existsByStudentIdAndTestId(int studentId, int testId);

    @Query("SELECT ROUND(AVG(tr.score), 2) FROM TestResult tr")

    BigDecimal findAverageScore();

    long countByIsPassedTrueAndSubmittedAtBetween(LocalDateTime start, LocalDateTime end);
}
