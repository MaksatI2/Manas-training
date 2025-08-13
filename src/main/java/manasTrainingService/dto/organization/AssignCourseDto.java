package manasTrainingService.dto.organization;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssignCourseDto {

    @NotNull(message = "{assignCourse.studentId.notNull}")
    private Long studentId;

    @NotNull(message = "{assignCourse.courseInstanceId.notNull}")
    private Integer courseInstanceId;
}
