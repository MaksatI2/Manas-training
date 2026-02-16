package manasTrainingService.dto.organization;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentEditByOrganizationDto {

    private Long studentId;

    @NotBlank(message = "Имя обязательно")
    @Size(max = 100, message = "Имя не должно превышать 100 символов")
    private String name;

    @NotBlank(message = "Фамилия обязательна")
    @Size(max = 100, message = "Фамилия не должна превышать 100 символов")
    private String lastName;

    @NotBlank(message = "Email обязателен")
    @Email(message = "Некорректный email")
    @Size(max = 150, message = "Email не должен превышать 150 символов")
    private String email;

    @NotBlank(message = "Телефон обязателен")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер должен быть в формате +996XXXXXXXXX")
    private String phone;
}
