package manasTrainingService.service.impl.user;

import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.StudentProfileNotFoundException;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.user.StudentService;
import manasTrainingService.service.user.UserService;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

@Service
public class StudentServiceImpl implements StudentService {

    private final StudentProfileRepository studentProfileRepository;
    private final UserService userService;
    private final ActivityLogService activityLogService;
    private final MessageSource messageSource;

    public StudentServiceImpl(StudentProfileRepository studentProfileRepository,
                              @Lazy UserService userService, ActivityLogService activityLogService, MessageSource messageSource) {
        this.studentProfileRepository = studentProfileRepository;
        this.userService = userService;
        this.activityLogService = activityLogService;
        this.messageSource = messageSource;
    }

    @Override
    public void createStudentProfile(StudentProfileDto studentProfileDto){
        StudentProfile studentProfile = StudentProfile.builder()
                .user(studentProfileDto.getStudent())
                .organization(studentProfileDto.getOrganization())
                .build();
        studentProfileRepository.save(studentProfile);
        activityLogService.log(
                studentProfileDto.getStudent(),
                ActionType.CREATE,
                TargetType.STUDENT_PROFILE,
                studentProfile.getId()
        );
    }

    @Override
    public void editStudentInformation(UserProfileEditDto userProfileEditDto){
        StudentProfile studentProfile = studentProfileRepository.findByUserId(userProfileEditDto.getUserId())
                .orElseThrow(() -> new StudentProfileNotFoundException(
                        messageSource.getMessage(
                                "student.profile.not.found",
                                null,
                                "Профиль студента не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

        User user = studentProfile.getUser();

        if (!user.getPhone().equals(userProfileEditDto.getPhone())) {
            if (userService.existsByPhone(userProfileEditDto.getPhone())) {
                throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
            }
        }

        userService.editStudentInformation(userProfileEditDto);
        studentProfile.setSpecialization(userProfileEditDto.getSpecialization());
        studentProfileRepository.saveAndFlush(studentProfile);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.STUDENT_PROFILE,
                studentProfile.getId()
        );
    }

    @Override
    public StudentProfileDto getAuthorizedStudentProfile(User user){
        StudentProfile studentProfile = studentProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new StudentProfileNotFoundException(
                        messageSource.getMessage(
                                "student.profile.not.found",
                                null,
                                "Профиль студента не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

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
