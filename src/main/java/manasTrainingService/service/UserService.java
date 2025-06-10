package manasTrainingService.service;

import manasTrainingService.dto.OrganizationProfileEditDto;
import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.dto.StudentRegisterDto;
import manasTrainingService.dto.UserProfileEditDto;
import manasTrainingService.entity.User;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);

    void registerStudent(StudentRegisterDto studentRegisterDto);

    void editStudentInformation(UserProfileEditDto userProfileEditDto);

    void editManagerInformation(OrganizationProfileEditDto organizationProfileEditDto);

    void sendResetToken(String email);

    boolean resetPassword(String token, String newPassword);

    boolean isValidResetToken(String token);

    boolean verifyEmailToken(String token);

    User getUserEntityByEmail(String email);

    User getAuthorizedUser();

    void addAvatarUrl(int userId, String filename);
}