package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CreateOrganizationDto;
import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.dto.StudentProfileDto;
import manasTrainingService.dto.StudentRegisterDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.*;
import manasTrainingService.repositories.UserRepository;
import manasTrainingService.service.OrganizationService;
import manasTrainingService.service.RoleService;
import manasTrainingService.service.StudentService;
import manasTrainingService.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final RoleService roleService;
    private final PasswordEncoder passwordEncoder;
    private final OrganizationService organizationService;
    private final StudentService studentService;

    @Override
    public void registerOrganization(OrganizationRegisterDto organizationRegisterDto){
        if (userRepository.existsByEmail(organizationRegisterDto.getEmail())) {
            throw new OrganizationEmailAlreadyExistsException("Организация с такой почтой уже существует");
        }
        if (userRepository.existsByPhone(organizationRegisterDto.getPhone())) {
            throw new OrganizationPhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
        }
        if (userRepository.existsByName(organizationRegisterDto.getCompanyName())){
            throw new OrganizationNameAlreadyExistsException("Организация с таким названием уже существует");
        }

        Role companyRole = roleService.getCompanyTypeId();
        User user  = User.builder()
                .email(organizationRegisterDto.getEmail())
                .passwordHash(passwordEncoder.encode(organizationRegisterDto.getPassword()))
                .name(organizationRegisterDto.getCompanyName())
                .lastName("null")
                .phone(organizationRegisterDto.getPhone())
                .role(companyRole)
                .build();
        userRepository.save(user);

        organizationService.createOrganization(
                CreateOrganizationDto.builder()
                        .user(user)
                        .build()
        );
    }

    @Override
    public void registerStudent(StudentRegisterDto studentRegisterDto) {
        if (userRepository.existsByEmail(studentRegisterDto.getEmail())) {
            throw new StudentEmailAlreadyExistsException("Студент с такой почтой уже существует");
        }
        if (userRepository.existsByPhone(studentRegisterDto.getPhone())) {
            throw new StudentPhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
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
                .build();
        userRepository.save(user);

        studentService.createStudentProfile(
                StudentProfileDto.builder()
                        .student(user)
                        .organization(organization)
                        .build()
        );
    }



}