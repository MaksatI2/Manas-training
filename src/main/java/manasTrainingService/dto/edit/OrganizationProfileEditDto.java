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
public class OrganizationProfileEditDto {
    Integer userId;

    @NotBlank(message = "Имя обязательно для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "Поле может содержать только буквы и пробелы")
    String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    @Pattern(regexp = "^[a-zA-Zа-яА-ЯёЁ\\s]+$", message = "Поле может содержать только буквы и пробелы")
    String surname;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @ValidPhoneNumber
    String phone;

    @NotBlank(message = "Названия организации обязательно для заполнения")
    String organizationName;
}
