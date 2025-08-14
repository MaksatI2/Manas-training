package manasTrainingService.dto.organization;

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
public class CreateStudentByOrganizationDto {

    @NotBlank(message = "{createStudentByOrganizationDto.name.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{createStudentByOrganizationDto.name.pattern}")
    @Size(max = 100, message = "{createStudentByOrganizationDto.name.size}")
    private String name;

    @NotBlank(message = "{createStudentByOrganizationDto.lastName.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{createStudentByOrganizationDto.lastName.pattern}")
    @Size(max = 100, message = "{createStudentByOrganizationDto.lastName.size}")
    private String lastName;

    @NotBlank(message = "{createStudentByOrganizationDto.email.notBlank}")
    @Email(message = "{createStudentByOrganizationDto.email.invalid}")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "{createStudentByOrganizationDto.email.pattern}")
    @Size(max = 150, message = "{createStudentByOrganizationDto.email.size}")
    private String email;

    @NotBlank(message = "{createStudentByOrganizationDto.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;
}
