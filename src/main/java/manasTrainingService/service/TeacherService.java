package manasTrainingService.service;

import manasTrainingService.dto.create.CreateTeacherDto;

public interface TeacherService {
    void createTeacherProfile(CreateTeacherDto createTeacherDto);
}
