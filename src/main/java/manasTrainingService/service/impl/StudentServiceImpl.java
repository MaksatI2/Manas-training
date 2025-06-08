package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.StudentProfileDto;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.repositories.StudentProfileRepository;
import manasTrainingService.service.StudentService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final StudentProfileRepository studentProfileRepository;

    @Override
    public void createStudentProfile(StudentProfileDto studentProfileDto){
        StudentProfile studentProfile = StudentProfile.builder()
                .user(studentProfileDto.getStudent())
                .organization(studentProfileDto.getOrganization())
                .build();
        studentProfileRepository.save(studentProfile);
    }
}
