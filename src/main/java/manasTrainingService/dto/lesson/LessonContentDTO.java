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

    @NotBlank(message = "Название не должно быть пустым")
    @Size(max = 200, message = "Название должно быть не длиннее 200 символов")
    private String title;

    private String content;
}
