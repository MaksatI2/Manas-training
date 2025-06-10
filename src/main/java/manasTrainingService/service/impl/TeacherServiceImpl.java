package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.entity.TeacherProfile;
import manasTrainingService.repositories.TeacherProfileRepository;
import manasTrainingService.service.TeacherService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherService {
    private final TeacherProfileRepository teacherProfileRepository;

    @Override
    public void createTeacherProfile(CreateTeacherDto createTeacherDto) {
        TeacherProfile teacherProfile = TeacherProfile.builder()
                .user(createTeacherDto.getUser())
                .department(createTeacherDto.getDepartment())
                .qualifications(createTeacherDto.getQualifications())
                .bio(createTeacherDto.getBio())
                .build();

        teacherProfileRepository.save(teacherProfile);
    }
}