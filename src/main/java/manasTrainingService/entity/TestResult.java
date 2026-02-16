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
@Table(name = "test_results")
public class TestResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_instance_id", nullable = false)
    TestInstance testInstance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    User student;

    @Column(name = "started_at", nullable = false)
    @Builder.Default
    LocalDateTime startedAt = LocalDateTime.now();

    @Column(name = "submitted_at")
    LocalDateTime submittedAt;

    @Column(name = "score", precision = 5, scale = 2)
    BigDecimal score;

    @Column(name = "percentage", precision = 5, scale = 2)
    BigDecimal percentage;

    @Column(name = "is_passed", nullable = false)
    @Builder.Default
    Boolean isPassed = false;

    @Column(name = "time_spent_minutes")
    Integer timeSpentMinutes;

    @OneToMany(mappedBy = "attempt", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    List<TestAnswer> answers;

}