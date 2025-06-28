package manasTrainingService.dto.lesson;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

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

    private String url;
    private MultipartFile file;

}