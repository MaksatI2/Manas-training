package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.StudentProfileNotFoundException;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.service.user.StudentService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final StudentProfileRepository studentProfileRepository;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Override
    public void createStudentProfile(StudentProfileDto studentProfileDto){
        StudentProfile studentProfile = StudentProfile.builder()
                .user(studentProfileDto.getStudent())
                .organization(studentProfileDto.getOrganization())
                .build();
        studentProfileRepository.save(studentProfile);
    }

    @Override
    public void editStudentInformation(UserProfileEditDto userProfileEditDto){
        StudentProfile studentProfile = studentProfileRepository.findByUserId(userProfileEditDto.getUserId())
                .orElseThrow(() -> new StudentProfileNotFoundException("Профиль студента не найден"));

        User user = studentProfile.getUser();

        if (!user.getPhone().equals(userProfileEditDto.getPhone())) {
            if (userService.existsByPhone(userProfileEditDto.getPhone())) {
                throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
            }
        }

        userService.editStudentInformation(userProfileEditDto);
        studentProfile.setSpecialization(userProfileEditDto.getSpecialization());
        studentProfileRepository.saveAndFlush(studentProfile);
    }

    @Override
    public StudentProfileDto getAuthorizedStudentProfile(User user){
        StudentProfile studentProfile = studentProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new StudentProfileNotFoundException("Профиль студента не найден"));

        String organizationName = null;
        if (studentProfile.getOrganization() != null &&
            studentProfile.getOrganization().getUser() != null) {
            organizationName = studentProfile.getOrganization().getUser().getName();
        }

        return StudentProfileDto.builder()
                .student(studentProfile.getUser())
                .organization(studentProfile.getOrganization())
                .organizationName(organizationName)
                .specialization(studentProfile.getSpecialization())
                .build();
    }

    @Override
    public UserProfileEditDto getStudentInformationForEdit(User user){
        return  UserProfileEditDto.builder()
                .userId(user.getId())
                .name(user.getName())
                .surname(user.getLastName())
                .phone(user.getPhone())
                .specialization(studentProfileRepository.findByUserId(user.getId()).get().getSpecialization())
                .build();
    }


}
