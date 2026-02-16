package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.UserEditDto;
import manasTrainingService.dto.UserRelationsCountDto;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.edit.UserProfileEditDto;
import manasTrainingService.dto.profile.StudentProfileDto;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.dto.statistics.UserStatisticsDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.StudentProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.*;
import manasTrainingService.repositories.user.StudentProfileRepository;
import manasTrainingService.repositories.user.UserRepository;
import manasTrainingService.service.user.*;
import org.hibernate.Hibernate;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final RoleService roleService;
    private final PasswordEncoder passwordEncoder;
    private final OrganizationService organizationService;
    private final StudentService studentService;
    private final TeacherService teacherService;
    private final EmailVerificationService emailVerificationService;
    private final PasswordResetService passwordResetService;
    private final StudentProfileRepository studentProfileRepository;
    private final MessageSource messageSource;

    @Override
    public void registerOrganization(OrganizationRegisterDto organizationRegisterDto) {
        if (userRepository.existsByEmail(organizationRegisterDto.getEmail())) {
            throw new EmailAlreadyExistsException(
                    messageSource.getMessage(
                            "organization.email.exists",
                            null,
                            "Организация с такой почтой уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (userRepository.existsByPhone(organizationRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException(
                    messageSource.getMessage(
                            "user.phone.exists",
                            null,
                            "Пользователь с таким номером телефона уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (userRepository.existsByName(organizationRegisterDto.getCompanyName())) {
            throw new OrganizationNameAlreadyExistsException(
                    messageSource.getMessage(
                            "organization.name.exists",
                            null,
                            "Организация с таким названием уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }


        Role companyRole = roleService.getCompanyTypeId();
        User user = User.builder()
                .email(organizationRegisterDto.getEmail())
                .passwordHash(passwordEncoder.encode(organizationRegisterDto.getPassword()))
                .name(organizationRegisterDto.getCompanyName())
                .lastName("null")
                .phone(organizationRegisterDto.getPhone())
                .role(companyRole)
                .isActive(false)
                .build();
        userRepository.save(user);
        emailVerificationService.generateVerificationToken(user);

        organizationService.createOrganization(
                CreateOrganizationDto.builder()
                        .user(user)
                        .build()
        );
    }

    @Override
    public void registerStudent(StudentRegisterDto studentRegisterDto) {
        if (userRepository.existsByEmail(studentRegisterDto.getEmail())) {
            throw new EmailAlreadyExistsException(
                    messageSource.getMessage(
                            "student.email.exists",
                            null,
                            "Студент с такой почтой уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (userRepository.existsByPhone(studentRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException(
                    messageSource.getMessage(
                            "user.phone.exists",
                            null,
                            "Пользователь с таким номером телефона уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }


        Organization organization = null;
        String orgCode = studentRegisterDto.getOrganizationCode();

        if (orgCode != null && !orgCode.isBlank()) {
            organization = organizationService.getOrganizationByCode(orgCode);
        }

        Role studentRole = roleService.getStudentRoleId();
        User user = User.builder()
                .email(studentRegisterDto.getEmail())
                .passwordHash(passwordEncoder.encode(studentRegisterDto.getPassword()))
                .name(studentRegisterDto.getName())
                .lastName(studentRegisterDto.getSurname())
                .phone(studentRegisterDto.getPhone())
                .role(studentRole)
                .isActive(false)
                .build();
        userRepository.save(user);
        emailVerificationService.generateVerificationToken(user);

        studentService.createStudentProfile(
                StudentProfileDto.builder()
                        .student(user)
                        .organization(organization)
                        .build()
        );
    }

    @Override
    public void registerTeacher(TeacherRegisterDto teacherRegisterDto) {
        if (userRepository.existsByEmail(teacherRegisterDto.getEmail())) {
            throw new EmailAlreadyExistsException(
                    messageSource.getMessage(
                            "teacher.email.exists",
                            null,
                            "Преподаватель с такой почтой уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        if (userRepository.existsByPhone(teacherRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException(
                    messageSource.getMessage(
                            "user.phone.exists",
                            null,
                            "Пользователь с таким номером телефона уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }


        Role teacherRole = roleService.getTeacherRoleId();
        User user = User.builder()
                .email(teacherRegisterDto.getEmail())
                .passwordHash(passwordEncoder.encode(teacherRegisterDto.getPassword()))
                .name(teacherRegisterDto.getName())
                .lastName(teacherRegisterDto.getSurname())
                .phone(teacherRegisterDto.getPhone())
                .role(teacherRole)
                .isActive(false)
                .build();
        userRepository.save(user);
        emailVerificationService.generateVerificationToken(user);

        teacherService.createTeacherProfile(
                CreateTeacherDto.builder()
                        .user(user)
                        .department(teacherRegisterDto.getDepartment())
                        .qualifications(teacherRegisterDto.getQualifications())
                        .bio(teacherRegisterDto.getBio())
                        .build()
        );
    }

    @Override
    public void editStudentInformation(UserProfileEditDto userProfileEditDto) {
        User user = userRepository.findById(userProfileEditDto.getUserId())
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.id.not.found",
                                null,
                                "Пользователь с таким ID не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        user.setName(userProfileEditDto.getName());
        user.setLastName(userProfileEditDto.getSurname());
        user.setPhone(userProfileEditDto.getPhone());
        userRepository.saveAndFlush(user);
    }

    @Override
    public void editManagerInformation(OrganizationProfileEditDto organizationProfileEditDto) {
        User user = userRepository.findById(organizationProfileEditDto.getUserId())
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.id.not.found",
                                null,
                                "Пользователь с таким ID не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        user.setName(organizationProfileEditDto.getName());
        user.setLastName(organizationProfileEditDto.getSurname());
        user.setPhone(organizationProfileEditDto.getPhone());
        userRepository.saveAndFlush(user);
    }

    @Override
    public void sendResetToken(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.email.not.found",
                                null,
                                "Пользователь с таким email не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
        passwordResetService.createResetToken(user);

    }

    @Override
    public boolean resetPassword(String token, String newPassword) {
        return passwordResetService.resetPassword(token, newPassword);
    }

    @Override
    public boolean isValidResetToken(String token) {
        return passwordResetService.isValidToken(token);
    }

    @Override
    public boolean verifyEmailToken(String token) {
        return emailVerificationService.verifyEmailToken(token);
    }

    @Override
    public boolean existsByPhone(String phone) {
        return userRepository.existsByPhone(phone);
    }

    @Override
    public User getUserEntityByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.email.not.found",
                                null,
                                "Пользователь с таким email не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
    }

    @Override
    public User getAuthorizedUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username;
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else {
            username = principal.toString();
        }
        return getUserEntityByEmail(username);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }


    public void addAvatarUrl(int userId, String filename) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(messageSource.getMessage(
                                "user.id.not.found",
                                null,
                                "Пользователь с таким ID не найден",
                                LocaleContextHolder.getLocale()
                        )


                        )
                );
        user.setAvatarUrl(filename);
        userRepository.saveAndFlush(user);
    }

    @Override
    public Page<User> getUsersWithFilters(String role, String status, String search, Pageable pageable) {
        return userRepository.findUsersWithFilters(role, status, search, pageable);
    }

    @Override
    public User getUserById(Integer id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));
    }

    @Override
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    @Override
    public void editTeacherInformation(TeacherProfileEditDto teacherProfileEditDto) {
        teacherService.editTeacherProfile(teacherProfileEditDto);
    }

    @Override
    public void resendVerificationEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.email.not.found",
                                null,
                                "Пользователь с таким email не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (user.getIsActive()) {
            throw new EmailAlreadyVerifiedException(
                    messageSource.getMessage(
                            "email.already.verified",
                            null,
                            "Email уже подтвержден",
                            LocaleContextHolder.getLocale()
                    )
            );
        }
        emailVerificationService.generateVerificationToken(user);
    }

    @Override
    public List<User> getStudentsWithoutOrganization() {
        List<StudentProfile> profiles = studentProfileRepository.findAllByOrganizationIsNull();

        return profiles.stream()
                .map(StudentProfile::getUser)
                .filter(user -> user.getRole() != null && "STUDENT".equals(user.getRole().getName()))
                .collect(Collectors.toList());
    }

    @Override
    public long countActiveAdmins() {
        return userRepository.countByRole_NameAndIsActiveTrue("ADMIN");
    }


    @Override
    @Transactional
    public void deleteUserById(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if ("ADMIN".equals(user.getRole().getName()) && user.getIsActive()) {
            long activeAdmins = countActiveAdmins();
            if (activeAdmins <= 1) {
                throw new IllegalStateException(
                        messageSource.getMessage(
                                "admin.last.active.cannot.delete",
                                null,
                                "Нельзя удалить последнего активного администратора.",
                                LocaleContextHolder.getLocale()
                        )
                );
            }
        }

        userRepository.delete(user);
    }

    @Transactional(readOnly = true)
    @Override
    public UserRelationsCountDto getUserRelationsCount(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

        Hibernate.initialize(user.getSchedules());
        Hibernate.initialize(user.getEmployees());
        Hibernate.initialize(user.getCourseApplicationEmployees());
        Hibernate.initialize(user.getTestResults());
        Hibernate.initialize(user.getAttendancesAsStudent());
        Hibernate.initialize(user.getAttendancesMarkedBy());
        Hibernate.initialize(user.getCertificatesAsStudent());
        Hibernate.initialize(user.getCertificatesIssuedByUser());
        Hibernate.initialize(user.getCourseInstanceTeachers());
        Hibernate.initialize(user.getCourseTeachers());
        Hibernate.initialize(user.getEnrollments());

        return UserRelationsCountDto.builder()
                .schedules(user.getSchedules() != null ? user.getSchedules().size() : 0)
                .employees(user.getEmployees() != null ? user.getEmployees().size() : 0)
                .courseApplicationEmployees(user.getCourseApplicationEmployees() != null ? user.getCourseApplicationEmployees().size() : 0)
                .testResults(user.getTestResults() != null ? user.getTestResults().size() : 0)
                .attendancesAsStudent(user.getAttendancesAsStudent() != null ? user.getAttendancesAsStudent().size() : 0)
                .attendancesMarkedBy(user.getAttendancesMarkedBy() != null ? user.getAttendancesMarkedBy().size() : 0)
                .certificatesAsStudent(user.getCertificatesAsStudent() != null ? user.getCertificatesAsStudent().size() : 0)
                .certificatesIssuedByUser(user.getCertificatesIssuedByUser() != null ? user.getCertificatesIssuedByUser().size() : 0)
                .courseInstanceTeachers(user.getCourseInstanceTeachers() != null ? user.getCourseInstanceTeachers().size() : 0)
                .courseTeachers(user.getCourseTeachers() != null ? user.getCourseTeachers().size() : 0)
                .enrollments(user.getEnrollments() != null ? user.getEnrollments().size() : 0)
                .build();
    }

    @Override
    public UserEditDto getUserEditDtoById(Integer userId) {
        User user = getUserById(userId);

        return UserEditDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getName())
                .lastName(user.getLastName())
                .phone(user.getPhone())
                .build();
    }

    @Transactional
    @Override
    public void updateUser(UserEditDto userEditDto) {
        User user = userRepository.findById(userEditDto.getId())
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.not.found",
                                null,
                                "Пользователь не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));

        if (!user.getEmail().equals(userEditDto.getEmail())) {
            if (userRepository.existsByEmail(userEditDto.getEmail())) {
                throw new EmailAlreadyExistsException(
                        messageSource.getMessage(
                                "user.email.exists",
                                null,
                                "Пользователь с таким Email уже существует",
                                LocaleContextHolder.getLocale()
                        )
                );
            }
            user.setEmail(userEditDto.getEmail());
        }

        if (!user.getPhone().equals(userEditDto.getPhone()) && userRepository.existsByPhone(userEditDto.getPhone())) {
            throw new PhoneAlreadyExistsException(
                    messageSource.getMessage(
                            "user.phone.exists",
                            null,
                            "Пользователь с таким номером телефона уже существует",
                            LocaleContextHolder.getLocale()
                    )
            );
        }


        user.setName(userEditDto.getName());
        user.setLastName(userEditDto.getLastName());
        user.setPhone(userEditDto.getPhone());

        userRepository.save(user);
    }

    @Override
    public UserStatisticsDto getUserStatistics() {
        long students = userRepository.countByRole_NameAndIsActiveTrue("STUDENT");
        long teachers = userRepository.countByRole_NameAndIsActiveTrue("TEACHER");
        long organizations = userRepository.countByRole_NameAndIsActiveTrue("ORGANIZATION");
        long inactiveUsers = userRepository.countByIsActiveFalse();

        return new UserStatisticsDto(students, teachers, organizations, inactiveUsers);
    }

    public User getCurrentUser(Authentication authentication) {
        String email = authentication.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException(
                        messageSource.getMessage(
                                "user.email.not.found",
                                null,
                                "Пользователь с таким email не найден",
                                LocaleContextHolder.getLocale()
                        )
                ));    }

    @Override
    public void updateLanguage(Authentication authentication, String lang) {
        User user = getCurrentUser(authentication);
        user.setLanguagePreference(lang);
        userRepository.save(user);
    }

}
