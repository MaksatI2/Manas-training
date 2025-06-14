package manasTrainingService.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "lesson_quiz_options")
public class LessonQuizOption {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    LessonQuizQuestion question;

    @Column(name = "option_text", columnDefinition = "TEXT", nullable = false)
    String optionText;

    @Column(name = "is_correct")
    @Builder.Default
    Boolean isCorrect = false;
}