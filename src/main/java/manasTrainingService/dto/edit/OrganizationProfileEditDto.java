package manasTrainingService.dto.edit;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import manasTrainingService.validation.ValidPhoneNumber;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationProfileEditDto {
    Integer userId;

    @NotBlank(message = "{organizationProfileEdit.name.notblank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{organizationProfileEdit.name.pattern}")
    String name;

    @NotBlank(message = "{organizationProfileEdit.surname.notblank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{organizationProfileEdit.surname.pattern}")
    String surname;

    @NotBlank(message = "{organizationProfileEdit.phone.notblank}")
    @ValidPhoneNumber
    String phone;

    @NotBlank(message = "{organizationProfileEdit.organizationName.notblank}")
    String organizationName;
}
