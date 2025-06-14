package manasTrainingService.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CourseCategoryDto {

    private Integer id;

    @NotBlank(message = "Название категории обязательно")
    @Size(max = 200, message = "Максимум 200 символов")
    private String name;

    @Size(max = 1000, message = "Максимум 1000 символов")
    private String description;
}
