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

    @NotBlank(message = "{CourseCategoryDto.name.NotBlank}")
    @Size(max = 200, message = "{CourseCategoryDto.name.Size}")
    private String name;

    @Size(max = 1000, message = "{CourseCategoryDto.description.Size}")
    private String description;
}
