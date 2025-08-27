package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "lesson_quizzes")
public class LessonQuiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @Column(name = "question_time_limit")
    Integer questionTimeLimit;

    @Column(name = "title", length = 200, nullable = false)
    String title;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "is_active")
    @Builder.Default
    Boolean isActive = true;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<LessonQuizQuestion> questions;

    @OneToOne
    @JoinColumn(name = "lesson_id")
    Lesson lesson;
}
