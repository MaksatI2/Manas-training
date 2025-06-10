package manasTrainingService.dto;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationProfileEditDto {
    Integer userId;
    String name;
    String surname;
    String phone;
    String organizationName;
}
