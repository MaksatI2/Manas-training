package manasTrainingService.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrganizationProfileEditDto {
    Integer userId;

    @NotBlank(message = "Имя обязательно для заполнения")
    String name;

    @NotBlank(message = "Фамилия обязательна для заполнения")
    String surname;

    @NotBlank(message = "Номер телефона не может быть пустым")
    @Pattern(regexp = "^\\+996\\d{9}$", message = "Номер телефона должен быть в формате +996XXXXXXXXX (12 цифр)")
    String phone;

    @NotBlank(message = "Названия организации обязательно для заполнения")
    String organizationName;
}
