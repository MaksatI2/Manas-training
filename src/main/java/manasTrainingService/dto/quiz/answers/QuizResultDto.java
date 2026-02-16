package manasTrainingService.dto.quiz.answers;

import lombok.*;
import manasTrainingService.dto.quiz.LessonQuizDto;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class QuizResultDto {
    private Integer totalPoints;
    private Integer correctAnswersCount;
    private Integer wrongAnswersCount;
    private Integer withoutAnswersCount;
    private Integer passingTime;
    private Integer questionsCount;
    private LessonQuizDto quiz;
}
