package manasTrainingService.service;

import manasTrainingService.dto.StudentProfileDto;
import manasTrainingService.dto.UserProfileEditDto;
import manasTrainingService.entity.User;

public interface StudentService {
    void createStudentProfile(StudentProfileDto studentProfileDto);

    void editStudentInformation(UserProfileEditDto userProfileEditDto);

    StudentProfileDto getAuthorizedStudentProfile(User user);

    UserProfileEditDto getStudentInformationForEdit(User user);
}
