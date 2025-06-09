package manasTrainingService.service;

import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.dto.StudentRegisterDto;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);

    void registerStudent(StudentRegisterDto studentRegisterDto);

    void sendResetToken(String email);

    boolean resetPassword(String token, String newPassword);

    boolean isValidResetToken(String token);

    boolean verifyEmailToken(String token);

}