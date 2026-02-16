package manasTrainingService.dto.register;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;
import manasTrainingService.validation.ValidPhoneNumber;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationRegisterDto {

    @Email(message = "{organizationRegisterDto.email.invalid}")
    @NotBlank(message = "{organizationRegisterDto.email.notBlank}")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "{organizationRegisterDto.email.pattern}")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "{organizationRegisterDto.password.pattern}")
    @Size(min = 8, message = "{organizationRegisterDto.password.size}")
    private String password;

    @NotBlank(message = "{organizationRegisterDto.companyName.notBlank}")
    @Size(max = 100, message = "{organizationRegisterDto.companyName.size}")
    private String companyName;

    @NotBlank(message = "{organizationRegisterDto.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;
    private Integer roleId;
}
