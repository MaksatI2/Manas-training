package manasTrainingService.dto.quiz;


import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
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
    private Integer questionTimeLimit;
    @NotBlank(message = "Название теста обязательно для заполнения")
    private String title;
    @NotBlank(message = "Краткое описание теста обязательно для заполнения")
    private String description;
    private Boolean isActive;
    @Valid
    private List<LessonQuizQuestionDto> questions;
}
