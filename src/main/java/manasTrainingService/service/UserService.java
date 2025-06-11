package manasTrainingService.service;

import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.OrganizationProfileEditDto;
import manasTrainingService.dto.UserProfileEditDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);
    void registerStudent(StudentRegisterDto studentRegisterDto);
    void registerTeacher(TeacherRegisterDto teacherRegisterDto);

    void editStudentInformation(UserProfileEditDto userProfileEditDto);
<<<<<<< src/main/java/manasTrainingService/service/UserService.java
=======

    void editManagerInformation(OrganizationProfileEditDto organizationProfileEditDto);

>>>>>>> src/main/java/manasTrainingService/service/UserService.java
    void sendResetToken(String email);

    boolean resetPassword(String token, String newPassword);
    boolean isValidResetToken(String token);
    boolean verifyEmailToken(String token);

    User getUserEntityByEmail(String email);
    User getAuthorizedUser();

<<<<<<< src/main/java/manasTrainingService/service/UserService.java
    Page<User> getAllUsers(Pageable pageable);
    Page<User> getUsersByRole(String role, Pageable pageable);
    List<String> getAllRoles();
=======
    void addAvatarUrl(int userId, String filename);
>>>>>>> src/main/java/manasTrainingService/service/UserService.java
}