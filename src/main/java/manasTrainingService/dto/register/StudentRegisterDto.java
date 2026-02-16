package manasTrainingService.dto.register;

import jakarta.validation.constraints.*;
import lombok.*;
import manasTrainingService.validation.ValidPhoneNumber;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentRegisterDto {

    @NotBlank(message = "{studentRegisterDto.name.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{studentRegisterDto.name.pattern}")
    @Size(max = 100, message = "{studentRegisterDto.name.size}")
    private String name;

    @NotBlank(message = "{studentRegisterDto.surname.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{studentRegisterDto.surname.pattern}")
    @Size(max = 100, message = "{studentRegisterDto.surname.size}")
    private String surname;

    @NotBlank(message = "{studentRegisterDto.email.notBlank}")
    @Email(message = "{studentRegisterDto.email.invalid}")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "{studentRegisterDto.email.pattern}")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "{studentRegisterDto.password.pattern}")
    @Size(min = 8, message = "{studentRegisterDto.password.size}")
    private String password;

    private String organizationCode;

    @NotBlank(message = "{studentRegisterDto.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;
}
