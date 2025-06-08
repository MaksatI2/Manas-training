package manasTrainingService.dto;

import lombok.*;
import manasTrainingService.entity.User;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CreateOrganizationDto {
    private Integer id;
    private User user;
    private String code;
}