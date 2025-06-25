package manasTrainingService.dto.register;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationRegisterDto {

    @Email(message = "Неправильный формат email")
    @NotBlank(message = "Email не может быть пустым")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "Email должен содержать только английские символы")
    private String email;

    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "Пароль должен содержать хотя бы одну заглавную букву и одну цифру")
    @Size(min = 8, message = "Пароль должен быть не менее 8 символов")
    private String password;

    @NotBlank(message = "Название организации не может быть пустым")
    private String companyName;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер телефона должен быть в формате +996XXXXXXXXX (12 цифр)")
    private String phone;
    private Integer roleId;

}