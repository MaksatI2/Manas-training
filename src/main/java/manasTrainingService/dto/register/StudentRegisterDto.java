package manasTrainingService.dto.register;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentRegisterDto {

    @NotBlank(message = "Имя обязательно для заполнения")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    private String surname;

    @NotBlank(message = "Email обязателен")
    @Email(message = "Некорректный формат email")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать хотя бы одну заглавную букву и одну цифру")
    @Size(min = 8, message = "Пароль должен быть не менее 8 символов")
    private String password;

    private String organizationCode;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер телефона должен быть в формате +996XXXXXXXXX (12 цифр)")
    private String phone;
}