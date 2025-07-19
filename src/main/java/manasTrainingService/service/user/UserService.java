package manasTrainingService.service.user;

import manasTrainingService.dto.UserEditDto;
import manasTrainingService.dto.UserRelationsCountDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.dto.statistics.UserStatisticsDto;
import manasTrainingService.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface UserService {
    void registerOrganization(OrganizationRegisterDto organizationRegisterDto);

    void registerStudent(StudentRegisterDto studentRegisterDto);

    void registerTeacher(TeacherRegisterDto teacherRegisterDto);

    void editStudentInformation(UserProfileEditDto userProfileEditDto);

    void editTeacherInformation(TeacherProfileEditDto teacherProfileEditDto);

    void editManagerInformation(OrganizationProfileEditDto organizationProfileEditDto);

    void sendResetToken(String email);

    void addAvatarUrl(int userId, String filename);

    boolean resetPassword(String token, String newPassword);

    boolean existsByPhone(String phone);

    boolean isValidResetToken(String token);

    boolean verifyEmailToken(String token);

    User getUserEntityByEmail(String email);

    User getAuthorizedUser();

    Page<User> getUsersWithFilters(String role, String status, String search, Pageable pageable);

    User getUserById(Integer id);

    User saveUser(User user);

    List<User> getAllUsers();

    void resendVerificationEmail(String email);

    List<User> getStudentsWithoutOrganization();

    long countActiveAdmins();


    void deleteUserById(Integer userId);

    @Transactional(readOnly = true)
    UserRelationsCountDto getUserRelationsCount(Integer userId);

    UserEditDto getUserEditDtoById(Integer userId);

    @Transactional
    void updateUser(UserEditDto userEditDto);

    UserStatisticsDto getUserStatistics();
}