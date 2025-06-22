package manasTrainingService.service.user;

import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.entity.User;

public interface StudentService {
    void createStudentProfile(StudentProfileDto studentProfileDto);
    void editStudentInformation(UserProfileEditDto userProfileEditDto);

    StudentProfileDto getAuthorizedStudentProfile(User user);
    UserProfileEditDto getStudentInformationForEdit(User user);
}
