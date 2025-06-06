package manasTrainingService.entity;


import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "test_answers")
public class TestAnswer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "attempt_id", nullable = false)
    TestAttempt attempt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    TestQuestion question;

    @Column(name = "selected_options", columnDefinition = "JSONB")
    String selectedOptions;

    @Column(name = "text_answer", columnDefinition = "TEXT")
    String textAnswer;

    @Column(name = "is_correct")
    Boolean isCorrect;

    @Column(name = "points_earned", precision = 5, scale = 2)
    @Builder.Default
    BigDecimal pointsEarned = BigDecimal.ZERO;
}