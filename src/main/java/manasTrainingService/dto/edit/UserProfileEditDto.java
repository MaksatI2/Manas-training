package manasTrainingService.dto.edit;

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
public class UserProfileEditDto {
    private Integer userId;

    @NotBlank(message = "{userProfile.name.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{userProfile.name.pattern}")
    @Size(max = 100, message = "{userProfile.name.size}")
    private String name;

    @NotBlank(message = "{userProfile.surname.notBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "{userProfile.surname.pattern}")
    @Size(max = 100, message = "{userProfile.surname.size}")
    private String surname;

    @NotBlank(message = "{userProfile.phone.notBlank}")
    @ValidPhoneNumber
    private String phone;

    @NotBlank(message = "{userProfile.specialization.notBlank}")
    private String specialization;
}
