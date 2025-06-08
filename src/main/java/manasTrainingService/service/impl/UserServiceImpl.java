package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.CreateOrganizationDto;
import manasTrainingService.dto.OrganizationRegisterDto;
import manasTrainingService.entity.Role;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.OrganizationEmailAlreadyExistsException;
import manasTrainingService.exceptions.OrganizationNameAlreadyExistsException;
import manasTrainingService.exceptions.OrganizationPhoneAlreadyExistsException;
import manasTrainingService.repositories.UserRepository;
import manasTrainingService.service.OrganizationService;
import manasTrainingService.service.RoleService;
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

}