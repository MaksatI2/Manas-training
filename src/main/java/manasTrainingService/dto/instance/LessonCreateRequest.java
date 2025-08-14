package manasTrainingService.dto.instance;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class LessonCreateRequest {

    @NotBlank(message = "{lessonCreate.title.notBlank}")
    private String title;

    private String description;

}
