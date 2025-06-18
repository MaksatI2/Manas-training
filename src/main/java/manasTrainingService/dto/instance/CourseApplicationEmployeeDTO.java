package manasTrainingService.dto.instance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import manasTrainingService.entity.Status;

@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CourseApplicationEmployeeDTO {
    private Integer id;
    private Integer employeeId;
    private String employeeName;
    private Integer applicationId;
    private Status applicationStatus;
}