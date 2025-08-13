package manasTrainingService.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;
import manasTrainingService.validation.PasswordMatch;

@Data
@PasswordMatch(password = "password", confirmPassword = "confirmPassword", message = "{PasswordResetDto.PasswordMatch}")
public class PasswordResetDto {

    @NotBlank(message = "{PasswordResetDto.token.NotBlank}")
    private String token;

    @NotBlank(message = "{PasswordResetDto.password.NotBlank}")
    @Size(min = 8, message = "{PasswordResetDto.password.Size}")
    @Pattern(regexp = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).+$",
            message = "{PasswordResetDto.password.Pattern}")
    private String password;

    @NotBlank(message = "{PasswordResetDto.confirmPassword.NotBlank}")
    private String confirmPassword;
}
