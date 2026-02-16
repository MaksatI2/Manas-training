package manasTrainingService.dto.register;

import jakarta.validation.constraints.*;
import lombok.*;
import manasTrainingService.validation.ValidPhoneNumber;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TeacherRegisterDto {

    @NotBlank(message = "{teacherRegisterDto.email.notBlank}")
    @Email(message = "{teacherRegisterDto.email.invalid}")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "{teacherRegisterDto.email.pattern}")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "{teacherRegisterDto.password.pattern}")
    @Size(min = 8, message = "{teacherRegisterDto.password.size}")
    private String password;

    @NotBlank(message = "{teacherRegisterDto.name.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{teacherRegisterDto.name.pattern}")
    private String name;

    @NotBlank(message = "{teacherRegisterDto.surname.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{teacherRegisterDto.surname.pattern}")
    private String surname;

    @NotBlank(message = "{teacherRegisterDto.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;

    @NotBlank(message = "{teacherRegisterDto.department.notBlank}")
    private String department;

    @NotBlank(message = "{teacherRegisterDto.qualifications.notBlank}")
    private String qualifications;

    private String bio;
}
