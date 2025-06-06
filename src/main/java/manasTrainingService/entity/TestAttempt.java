package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "test_attempts")
public class TestAttempt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_id", nullable = false)
    Test test;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    User student;

    @Column(name = "attempt_number", nullable = false)
    Integer attemptNumber;

    @Column(name = "started_at", nullable = false)
    @Builder.Default
    LocalDateTime startedAt = LocalDateTime.now();

    @Column(name = "submitted_at")
    LocalDateTime submittedAt;

    @Column(name = "score", precision = 5, scale = 2)
    BigDecimal score;

    @Column(name = "max_score", precision = 5, scale = 2)
    BigDecimal maxScore;

    @Column(name = "percentage", precision = 5, scale = 2)
    BigDecimal percentage;

    @Column(name = "is_passed", nullable = false)
    @Builder.Default
    Boolean isPassed = false;

    @Column(name = "time_spent_minutes")
    Integer timeSpentMinutes;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    AttemptStatus status = AttemptStatus.IN_PROGRESS;

    @OneToMany(mappedBy = "attempt", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<TestAnswer> answers;

    public enum AttemptStatus {
        IN_PROGRESS("in_progress"),
        SUBMITTED("submitted"),
        GRADED("graded");

        private final String value;

        AttemptStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }
}
