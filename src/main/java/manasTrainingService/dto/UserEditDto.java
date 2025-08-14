package manasTrainingService.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;
import manasTrainingService.validation.ValidPhoneNumber;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEditDto {

    private Integer id;

    @NotBlank(message = "{UserEditDto.email.NotBlank}")
    @Email(message = "{UserEditDto.email.Email}")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
            message = "{UserEditDto.email.Pattern}")
    private String email;

    @NotBlank(message = "{UserEditDto.name.NotBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "{UserEditDto.name.Pattern}")
    private String name;

    @NotBlank(message = "{UserEditDto.lastName.NotBlank}")
    @Pattern(regexp = "^[a-zA-Zа-яА-Я]+$", message = "{UserEditDto.lastName.Pattern}")
    private String lastName;

    @NotBlank(message = "{UserEditDto.phone.NotBlank}")
    @ValidPhoneNumber
    private String phone;
}
