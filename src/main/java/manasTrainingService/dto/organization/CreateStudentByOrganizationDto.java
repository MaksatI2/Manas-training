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

    @NotBlank(message = "Имя обязательно для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "Имя должно содержать только буквы")
    @Size(max = 100, message = "Имя не должно превышать 100 символов")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "Фамилия должна содержать только буквы")
    @Size(max = 100, message = "Фамилия не должна превышать 100 символов")
    private String lastName;

    @NotBlank(message = "Email обязателен")
    @Email(message = "Некорректный формат email")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "Email должен содержать только английские символы")
    @Size(max = 150, message = "Email не должен превышать 150 символов")
    private String email;

    @NotBlank(message = "Номер телефона обязателен")
    @ValidPhoneNumber
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер должен быть в формате +996XXXXXXXXX")
    private String phone;
}
