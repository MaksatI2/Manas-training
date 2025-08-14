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
public class TeacherProfileEditDto {
    private Integer userId;

    @NotBlank(message = "{teacherProfile.name.notBlank}")
    private String name;

    @NotBlank(message = "{teacherProfile.surname.notBlank}")
    private String surname;

    @NotBlank(message = "{teacherProfile.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;

    @NotBlank(message = "{teacherProfile.department.notBlank}")
    private String department;

    @NotBlank(message = "{teacherProfile.qualifications.notBlank}")
    private String qualifications;

    private String bio;
}
