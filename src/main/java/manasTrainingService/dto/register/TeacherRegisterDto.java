package manasTrainingService.dto.register;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TeacherRegisterDto {
    @NotBlank(message = "Email обязателен")
    @Email(message = "Некорректный формат email")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать хотя бы одну заглавную букву и одну цифру")
    @Size(min = 8, message = "Пароль должен быть не менее 8 символов")
    private String password;

    @NotBlank(message = "Имя обязательно для заполнения")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    private String surname;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер телефона должен быть в формате +996XXXXXXXXX (12 цифр)")
    private String phone;

    @NotBlank(message = "Отделение обязательна для заполнения")
    private String department;

    @NotBlank(message = "Квалификация обязательна для заполнения")
    private String qualifications;

    private String bio;
}