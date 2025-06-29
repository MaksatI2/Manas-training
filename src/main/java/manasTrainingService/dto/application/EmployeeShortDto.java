package manasTrainingService.dto.application;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeShortDto {
    private Integer id;
    private String fullName;
    private String email;
}
