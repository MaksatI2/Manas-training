package manasTrainingService.dto.teacher;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.Builder;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeacherFormDTO {
    @NotEmpty(message = "Выберите хотя бы одного преподавателя")
    private List<Integer> teacherIds;
}