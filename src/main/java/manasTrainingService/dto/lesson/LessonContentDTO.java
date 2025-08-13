package manasTrainingService.dto.lesson;

import lombok.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LessonContentDTO {

    @NotBlank(message = "{lessonContent.title.notBlank}")
    @Size(max = 200, message = "{lessonContent.title.size}")
    private String title;

    private String content;
}
