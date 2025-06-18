package manasTrainingService.service;

import manasTrainingService.dto.instance.CourseEnrollmentCardDTO;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.entity.User;

import java.util.List;

public interface StudentService {
    void createStudentProfile(StudentProfileDto studentProfileDto);
    void editStudentInformation(UserProfileEditDto userProfileEditDto);

    StudentProfileDto getAuthorizedStudentProfile(User user);
    UserProfileEditDto getStudentInformationForEdit(User user);
}
