package manasTrainingService.dto.instance;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.dto.quiz.LessonQuizDto;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LessonDTO {
    private Integer id;

    @NotNull
    private Integer moduleId;
    private CourseModuleDTO courseModule;

    @NotBlank(message = "Название урока необходимо")
    private String title;

    private String description;

    private LessonQuizDto quiz;

}