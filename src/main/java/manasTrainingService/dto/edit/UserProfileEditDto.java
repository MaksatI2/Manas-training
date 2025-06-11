package manasTrainingService.dto.edit;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserProfileEditDto {
    private Integer userId;

    @NotBlank(message = "Имя обязательно для заполнения")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    private String surname;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер телефона должен быть в формате +996XXXXXXXXX (12 цифр)")
    private String phone;

    @NotBlank
    private String specialization;
}
