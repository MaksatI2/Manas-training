package manasTrainingService.dto.profile;

import lombok.*;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentProfileDto {
    private User student;
    private Organization organization;
    private String organizationName;
    private String specialization;
}