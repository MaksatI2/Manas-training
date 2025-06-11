package manasTrainingService.service;

import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);
    void registerStudent(StudentRegisterDto studentRegisterDto);
    void registerTeacher(TeacherRegisterDto teacherRegisterDto);

    void editStudentInformation(UserProfileEditDto userProfileEditDto);
    void editTeacherInformation(TeacherProfileEditDto teacherProfileEditDto);

    void sendResetToken(String email);

    boolean resetPassword(String token, String newPassword);
    boolean existsByPhone(String phone);
    boolean isValidResetToken(String token);
    boolean verifyEmailToken(String token);

    User getUserEntityByEmail(String email);
    User getAuthorizedUser();

    Page<User> getUsersWithFilters(String role, String status, String search, Pageable pageable);
    Page<User> getUsersByStatus(Boolean isActive, Pageable pageable);
    Page<User> searchUsersByEmailOrName(String search, Pageable pageable);

    User getUserById(Integer id);
    User saveUser(User user);
}