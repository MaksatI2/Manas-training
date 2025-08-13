package manasTrainingService.dto.quiz;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import manasTrainingService.dto.instance.LessonDTO;
import java.util.List;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LessonQuizDto {
    private Integer id;
    private Integer lessonId;
    private LessonDTO lesson;

    @NotNull(message = "{lessonQuizDto.questionTimeLimit.notNull}")
    @Min(value = 1, message = "{lessonQuizDto.questionTimeLimit.min}")
    @Max(value = 60, message = "{lessonQuizDto.questionTimeLimit.max}")
    private Integer questionTimeLimit;

    @NotBlank(message = "{lessonQuizDto.title.notBlank}")
    private String title;

    @NotBlank(message = "{lessonQuizDto.description.notBlank}")
    private String description;

    private Boolean isActive;

    @Valid
    private List<LessonQuizQuestionDto> questions;
}
