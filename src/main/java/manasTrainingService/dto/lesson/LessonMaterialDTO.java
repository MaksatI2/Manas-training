package manasTrainingService.dto.lesson;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LessonMaterialDTO {
    private Integer id;
    private Integer lessonId;
    @NotBlank(message = "Название материала необходимо")
    private String title;
    @NotBlank(message = "URL материала необходим")
    private String url;
}