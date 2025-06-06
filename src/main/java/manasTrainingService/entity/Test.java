package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "tests")
public class Test {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id")
    Course course;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id")
    Lesson lesson;

    @Column(name = "title", length = 200)
    String title;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "time_limit_minutes")
    @Builder.Default
    Integer timeLimitMinutes = 60;

    @Column(name = "max_attempts")
    @Builder.Default
    Integer maxAttempts = 3;

    @Column(name = "passing_score", precision = 5, scale = 2)
    @Builder.Default
    BigDecimal passingScore = new BigDecimal("70.00");

    @OneToMany(mappedBy = "test", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<TestQuestion> questions;

    @OneToMany(mappedBy = "test", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<TestAttempt> attempts;
}
