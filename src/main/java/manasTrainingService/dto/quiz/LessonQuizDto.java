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
    @NotNull(message = "Длительность необходима")
    @Min(value = 1, message = "Минимальная длительность квиза: 1")
    @Max(value = 60, message = "Максимальная длительность квиза: 60")
    private Integer questionTimeLimit;
    @NotBlank(message = "Название теста обязательно для заполнения")
    private String title;
    @NotBlank(message = "Краткое описание теста обязательно для заполнения")
    private String description;
    private Boolean isActive;
    @Valid
    private List<LessonQuizQuestionDto> questions;
}
