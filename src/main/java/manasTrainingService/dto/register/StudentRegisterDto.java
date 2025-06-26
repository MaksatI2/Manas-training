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

    @NotBlank(message = "Имя обязательно для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "Имя должно содержать только буквы")
    private String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "Имя должно содержать только буквы")
    private String surname;

    @NotBlank(message = "Email обязателен")
    @Email(message = "Некорректный формат email")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "Email должен содержать только английские символы")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать хотя бы одну заглавную букву и одну цифру")
    @Size(min = 8, message = "Пароль должен быть не менее 8 символов")
    private String password;

    private String organizationCode;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @ValidPhoneNumber
    private String phone;
}