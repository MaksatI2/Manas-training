package manasTrainingService.service.impl.user;

import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.organization.AssignCourseDto;
import manasTrainingService.dto.organization.CreateStudentByOrganizationDto;
import manasTrainingService.dto.organization.StudentCourseInfoDto;
import manasTrainingService.dto.organization.StudentEditByOrganizationDto;
import manasTrainingService.dto.profile.OrganizationProfileDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.course.CourseEnrollmentNotFoundException;
import manasTrainingService.exceptions.nsee.user.*;
import manasTrainingService.repositories.course.CourseEnrollmentRepository;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.repositories.user.OrganizationRepository;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.user.EmailService;
import manasTrainingService.service.user.OrganizationService;
import manasTrainingService.service.user.RoleService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.PasswordGenerator;
import manasTrainingService.util.StatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
@Transactional
public class OrganizationServiceImpl implements OrganizationService {

    private final OrganizationRepository organizationRepository;
    private final UserRepository userRepository;
    private final CourseEnrollmentRepository courseEnrollmentRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private final StudentProfileRepository studentProfileRepository;
    private final CourseInstanceRepository courseInstanceRepository;
    private final EmailService emailService;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

    @Override
    public void createOrganization(CreateOrganizationDto dto) {
        Organization organization = Organization.builder()
                .user(dto.getUser())
                .code(generateOrganizationCode())
                .build();
        organizationRepository.save(organization);
    }

    @Override
    public void editOrganizationInformation(OrganizationProfileEditDto organizationProfileEditDto) {
        Organization organization = organizationRepository.findByUserId(organizationProfileEditDto.getUserId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));
        organization.setDescription(organizationProfileEditDto.getOrganizationName());
        userService.editManagerInformation(organizationProfileEditDto);
    }

    @Override
    public OrganizationProfileEditDto getOrganizationUserInformationForEdit(User user) {
        return OrganizationProfileEditDto.builder()
                .userId(user.getId())
                .name(user.getName())
                .surname(user.getLastName())
                .phone(user.getPhone())
                .organizationName(organizationRepository.findByUserId(user.getId()).get().getDescription())
                .build();
    }

    @Override
    public Organization getOrganizationByCode(String code) {
        return organizationRepository.findByCode(code)
                .orElseThrow(() -> new OrganizationCodeNotFound("Организация с таким кодом не найдена"));
    }

    @Override
    public Organization getOrganizationById(int id) {
        return organizationRepository.findById(id)
                .orElseThrow(() -> new OrganizationCodeNotFound("Организация с таким ID не найдена"));
    }

    @Override
    public OrganizationProfileDto getAuthorizedUserOrganization(User user) {
        return OrganizationProfileDto.builder()
                .user(user)
                .organization(organizationRepository.findByUserId(user.getId()).orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена")))
                .build();
    }

    private String generateOrganizationCode() {
        int maxAttempts = 10000;
        for (int i = 1; i <= maxAttempts; i++) {
            String code = String.format("ORG%04d", i);
            if (!organizationRepository.findByCode(code).isPresent()) {
                return code;
            }
        }
        throw new IllegalStateException("Не удалось сгенерировать уникальный код организации");
    }

    @Override
    public String getOrganizationName(Organization organization) {
        if (organization != null && organization.getUser() != null) {
            return organization.getUser().getName();
        }
        return null;
    }

    @Override
    public String getOrganizationNameByCode(String code) {
        Organization organization = getOrganizationByCode(code);
        return getOrganizationName(organization);
    }

    @Override
    public String getOrganizationNameById(int id) {
        Organization organization = getOrganizationById(id);
        return getOrganizationName(organization);
    }

    @Override
    public List<StudentCourseInfoDto> getStudentsCourseInfoForOrganization(User organizationUser) {
        Organization organization = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));

        List<StudentProfile> profiles = studentProfileRepository.findAllByOrganization(organization);
        List<User> students = profiles.stream().map(StudentProfile::getUser).toList();

        List<CourseEnrollment> enrollments = courseEnrollmentRepository.findByStudentIn(students);

        return students.stream()
                .flatMap(student -> {
                    List<CourseEnrollment> studentEnrollments = enrollments.stream()
                            .filter(e -> e.getStudent().getId().equals(student.getId()))
                            .toList();

                    if (studentEnrollments.isEmpty()) {
                        return Stream.of(
                                StudentCourseInfoDto.builder()
                                        .studentId(student.getId())
                                        .fullName(student.getName() + " " + student.getLastName())
                                        .email(student.getEmail())
                                        .phone(student.getPhone())
                                        .courseTitle("-")
                                        .status("-")
                                        .localizedStatus("-")
                                        .progress(BigDecimal.ZERO)
                                        .finalGrade(null)
                                        .build()
                        );
                    } else {
                        return studentEnrollments.stream().map(enrollment ->
                                StudentCourseInfoDto.builder()
                                        .studentId(student.getId())
                                        .enrollmentId(enrollment.getId())
                                        .fullName(student.getName() + " " + student.getLastName())
                                        .email(student.getEmail())
                                        .phone(student.getPhone())
                                        .courseTitle(enrollment.getCourseInstance().getCourse().getTitle())
                                        .localizedStatus(StatusUtil.localize(enrollment.getStatus()))
                                        .progress(enrollment.getProgressPercentage())
                                        .finalGrade(enrollment.getFinalGrade())
                                        .build()
                        );
                    }
                })
                .toList();
    }

    @Override
    public void editStudentProfileByOrganization(StudentEditByOrganizationDto dto) {
        User user = userRepository.findById(dto.getStudentId().intValue())
                .orElseThrow(() -> new UserNotFoundException("Студент не найден"));

        user.setName(dto.getName());
        user.setLastName(dto.getLastName());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());

        userRepository.save(user);
    }

    @Override
    public void assignStudentToCourse(AssignCourseDto dto, User organizationUser) {
        User student = userRepository.findById(dto.getStudentId().intValue())
                .orElseThrow(() -> new UserNotFoundException("Студент не найден"));

        Organization organization = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));
        Organization studentOrg = student.getStudentProfile() != null
                ? student.getStudentProfile().getOrganization()
                : null;
        if (studentOrg == null || !studentOrg.getId().equals(organization.getId())) {
            throw new AccessDeniedException("Невозможно назначить курс студенту из другой организации");
        }

        if (courseEnrollmentRepository.existsByStudentIdAndCourseInstanceId(student.getId(), dto.getCourseInstanceId())) {
            throw new UserAlreadyExistsException("Этот студент уже записан на выбранный курс");
        }
        CourseInstance courseInstance = courseInstanceRepository.findById(dto.getCourseInstanceId())
                .orElseThrow(() -> new IllegalArgumentException("Курс не найден"));

        CourseEnrollment enrollment = CourseEnrollment.builder()
                .student(student)
                .courseInstance(courseInstance)
                .status(Status.ENROLLED)
                .build();

        courseEnrollmentRepository.save(enrollment);
    }

    @Override
    public void removeStudentFromCourse(Integer enrollmentId, User organizationUser) {
        CourseEnrollment enrollment = courseEnrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new CourseEnrollmentNotFoundException("Запись на курс не найдена"));

        User student = enrollment.getStudent();

        Organization org = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));

        if (student.getStudentProfile() == null ||
                !student.getStudentProfile().getOrganization().getId().equals(org.getId())) {
            throw new AccessDeniedException("Доступ запрещен: студент не принадлежит вашей организации");
        }

        courseEnrollmentRepository.delete(enrollment);
    }

    @Override
    public void deleteStudentFromOrganization(Integer studentId, User organizationUser) {
        Organization organization = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));

        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new UserNotFoundException("Студент не найден"));

        StudentProfile profile = student.getStudentProfile();
        if (profile == null || profile.getOrganization() == null ||
                !profile.getOrganization().getId().equals(organization.getId())) {
            throw new IllegalArgumentException("Студент не принадлежит данной организации");
        }

        List<CourseEnrollment> enrollments = courseEnrollmentRepository.findByStudent(student);
        courseEnrollmentRepository.deleteAll(enrollments);

        profile.setOrganization(null);
        studentProfileRepository.save(profile);

        student.setIsActive(false);
        userRepository.save(student);
    }

    @Override
    @Transactional
    public void createStudentByOrganization(CreateStudentByOrganizationDto dto, User organizationUser) {
        Organization organization = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));

        String normalizedPhone = normalizePhoneNumber(dto.getPhone());

        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new EmailAlreadyExistsException("Email уже используется");
        }
        if (userRepository.existsByPhone(normalizedPhone)) {
            throw new PhoneAlreadyExistsException("Телефон уже используется");
        }

        Role studentRole = roleService.getStudentRoleId();
        String rawPassword = PasswordGenerator.generateDefault();
        User student = User.builder()
                .email(dto.getEmail())
                .passwordHash(passwordEncoder.encode(rawPassword))
                .name(dto.getName())
                .lastName(dto.getLastName())
                .phone(normalizedPhone)
                .isActive(true)
                .role(studentRole)
                .build();

        userRepository.save(student);

        StudentProfile studentProfile = StudentProfile.builder()
                .user(student)
                .organization(organization)
                .build();
        studentProfileRepository.save(studentProfile);
        emailService.sendStudentWelcomeEmail(student.getEmail(), student.getName(), rawPassword);
    }

    private String normalizePhoneNumber(String phone) {
        if (phone == null || phone.isBlank()) {
            throw new ValidationException("Номер телефона не может быть пустым");
        }
        String cleanedPhone = phone.replaceAll("[^0-9+]", "");
        if (cleanedPhone.startsWith("+996") && cleanedPhone.length() == 13) {
            return cleanedPhone;
        }
        if (cleanedPhone.startsWith("0")) {
            cleanedPhone = cleanedPhone.substring(1);
        }
        if (cleanedPhone.length() == 9) {
            return "+996" + cleanedPhone;
        }
        throw new ValidationException("Некорректный формат номера телефона. Ожидается 9 цифр или формат +996XXXXXXXXX");
    }

    @Override
    public void attachStudentToOrganization(Integer studentId, User organizationUser) {
        Organization organization = organizationRepository.findByUserId(organizationUser.getId())
                .orElseThrow(() -> new OrganizationNotFoundException("Организация не найдена"));

        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new UserNotFoundException("Студент не найден"));
        StudentProfile profile = student.getStudentProfile();

        if (profile == null) {
            throw new IllegalStateException("У пользователя нет профиля студента");
        }
        if (profile.getOrganization() != null) {
            throw new IllegalArgumentException("Студент уже прикреплён к другой организации");
        }
        profile.setOrganization(organization);
        studentProfileRepository.save(profile);
    }
}