package manasTrainingService.entity;


import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "lesson_progress")
public class LessonProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    Lesson lesson;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    User student;

    @Column(name = "started_at", nullable = false)
    @Builder.Default
    LocalDateTime startedAt = LocalDateTime.now();

    @Column(name = "completed_at")
    LocalDateTime completedAt;

    @Column(name = "time_spent_minutes")
    @Builder.Default
    Integer timeSpentMinutes = 0;

    @Column(name = "is_completed", nullable = false)
    @Builder.Default
    Boolean isCompleted = false;
}
