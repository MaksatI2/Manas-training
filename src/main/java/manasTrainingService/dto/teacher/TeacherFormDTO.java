package manasTrainingService.dto.teacher;

import jakarta.validation.constraints.NotEmpty;
import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeacherFormDTO {
    @NotEmpty(message = "{teacherFormDTO.teacherIds.notEmpty}")
    private List<Integer> teacherIds;
}
