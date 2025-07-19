package manasTrainingService.dto.statistics;

import lombok.*;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserProfileDetailsDto {
    private User user;

    private Organization organization;
    private String organizationName;
    private String specialization;

    private String department;
    private String qualifications;
    private String bio;
}
