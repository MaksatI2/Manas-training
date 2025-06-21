package manasTrainingService.service;

import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TeacherService {
    void createTeacherProfile(CreateTeacherDto createTeacherDto);

    void editTeacherProfile(TeacherProfileEditDto teacherProfileEditDto);

    TeacherProfileDto getTeacherProfile(User user);

    TeacherProfileEditDto getTeacherInformationForEdit(User user);

    Page<TeacherCardDto> getTeachers(Pageable pageable, String search, String department);

    TeacherProfileDto getTeacherProfileById(Long id);
}
