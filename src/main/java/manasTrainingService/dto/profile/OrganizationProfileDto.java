package manasTrainingService.dto.profile;

import lombok.*;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.User;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationProfileDto {
    private User user;
    private Organization organization;
}
