package manasTrainingService.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import manasTrainingService.entity.User;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CreateOrganizationDto {
    private Integer id;
    private User user;
    private String code;
}