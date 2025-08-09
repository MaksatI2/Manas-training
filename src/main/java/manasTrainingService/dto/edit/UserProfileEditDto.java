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

    @NotBlank(message = "Имя обязательно для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "Поле может содержать только буквы и пробелы")
    @Size(max = 100, message = "Имя не должно превышать 100 символов")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "Поле может содержать только буквы и пробелы")
    @Size(max = 100, message = "Фамилия не должна превышать 100 символов")
    private String surname;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @ValidPhoneNumber
    private String phone;

    @NotBlank(message = "Специализация обязательно должна быть указана")
    private String specialization;
}
