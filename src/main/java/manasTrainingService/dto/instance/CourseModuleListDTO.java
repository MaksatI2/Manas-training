package manasTrainingService.dto.instance;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CourseModuleListDTO {
    @Valid
    @NotEmpty(message = "{courseModuleList.notEmpty}")
    private List<CourseModuleCreationDTO> modules = new ArrayList<>();
}