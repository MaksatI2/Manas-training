package manasTrainingService.dto.organization;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssignCourseDto {

    @NotNull(message = "Выберите студента")
    private Long studentId;

    @NotNull(message = "Выберите курс")
    private Integer courseInstanceId;
}
