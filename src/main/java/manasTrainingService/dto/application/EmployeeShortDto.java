package manasTrainingService.dto.application;

import lombok.*;
import manasTrainingService.entity.Status;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeShortDto {
    private Integer id;
    private String fullName;
    private String email;
    private Status applicationStatus;
}
