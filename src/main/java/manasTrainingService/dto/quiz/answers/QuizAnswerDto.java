package manasTrainingService.dto.quiz.answers;

import jakarta.validation.Valid;
import lombok.*;

import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuizAnswerDto {
    private Integer id;
    private Integer quizId;
    private List<QuizQuestionAnswerDto> questionAnswers;
    private LocalTime passingStart;
}
