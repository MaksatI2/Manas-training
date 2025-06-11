package manasTrainingService.service;

import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.entity.User;

public interface TeacherService {
    void createTeacherProfile(CreateTeacherDto createTeacherDto);
    void editTeacherProfile(TeacherProfileEditDto teacherProfileEditDto);

    TeacherProfileDto getTeacherProfile(User user);
    TeacherProfileEditDto getTeacherInformationForEdit(User user);
}
