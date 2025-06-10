package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.*;
import manasTrainingService.dto.create.CreateOrganizationDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.register.OrganizationRegisterDto;
import manasTrainingService.dto.register.StudentRegisterDto;
import manasTrainingService.dto.register.TeacherRegisterDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.*;
import manasTrainingService.repositories.PasswordResetTokenRepository;
import manasTrainingService.repositories.UserRepository;
import manasTrainingService.service.*;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

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
    private final PasswordResetTokenRepository passwordResetTokenRepository;

    @Override
    public void registerOrganization(OrganizationRegisterDto organizationRegisterDto) {
        if (userRepository.existsByEmail(organizationRegisterDto.getEmail())) {
            throw new EmailAlreadyExistsException("Организация с такой почтой уже существует");
        }
        if (userRepository.existsByPhone(organizationRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
        }
        if (userRepository.existsByName(organizationRegisterDto.getCompanyName())) {
            throw new OrganizationNameAlreadyExistsException("Организация с таким названием уже существует");
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
            throw new EmailAlreadyExistsException("Студент с такой почтой уже существует");
        }
        if (userRepository.existsByPhone(studentRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
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
            throw new EmailAlreadyExistsException("Преподаватель с такой почтой уже существует");
        }
        if (userRepository.existsByPhone(teacherRegisterDto.getPhone())) {
            throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
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
    public void editStudentInformation(UserProfileEditDto userProfileEditDto){
        User user = userRepository.findById(userProfileEditDto.getUserId())
                .orElseThrow(() -> new UserNotFoundException("Пользователь с таким ID не найден"));
        user.setName(userProfileEditDto.getName());
        user.setLastName(userProfileEditDto.getSurname());
        user.setPhone(userProfileEditDto.getPhone());
        userRepository.saveAndFlush(user);
    }

    @Override
    public void sendResetToken(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("Пользователь с таким email не найден"));
        passwordResetService.createResetToken(user);

    }

    @Override
    public boolean resetPassword(String token, String newPassword) {
        return passwordResetService.resetPassword(token, newPassword);
    }

    @Override
    public boolean isValidResetToken(String token) {
        return passwordResetTokenRepository.findByToken(token)
                .filter(t -> t.getExpiryDate().isAfter(LocalDateTime.now()))
                .isPresent();
    }

    @Override
    public boolean verifyEmailToken(String token) {
        return emailVerificationService.verifyEmailToken(token);
    }

    @Override
    public User getUserEntityByEmail(String email){
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("Пользователь с данным Email не найден"));
    }

    @Override
    public User getAuthorizedUser(){
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
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Page<User> getUsersByRole(String role, Pageable pageable) {
        return userRepository.findByRole_Name(role, pageable);
    }

    @Override
    public List<String> getAllRoles() {
        return userRepository.findAllDistinctRoleNames();
    }
}
