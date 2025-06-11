package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.entity.TeacherProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.UserNotFoundException;
import manasTrainingService.repositories.TeacherProfileRepository;
import manasTrainingService.service.TeacherService;
import manasTrainingService.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherService {
    private final TeacherProfileRepository teacherProfileRepository;
    private UserService userService;

    @Autowired
    public void setUserService(@Lazy UserService userService) {
        this.userService = userService;
    }

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

    @Override
    public TeacherProfileDto getTeacherProfile(User user) {
        TeacherProfile teacherProfile = teacherProfileRepository.findByUser(user)
                .orElseThrow(() -> new UserNotFoundException("Профиль преподавателя не найден"));

        return TeacherProfileDto.builder()
                .teacher(user)
                .department(teacherProfile.getDepartment())
                .qualifications(teacherProfile.getQualifications())
                .bio(teacherProfile.getBio())
                .build();
    }

    @Override
    public void editTeacherProfile(TeacherProfileEditDto teacherProfileEditDto) {
        User user = userService.getUserById(teacherProfileEditDto.getUserId());

        if (!user.getPhone().equals(teacherProfileEditDto.getPhone())) {
            if (userService.existsByPhone(teacherProfileEditDto.getPhone())) {
                throw new PhoneAlreadyExistsException("Пользователь с таким номером телефона уже существует");
            }
        }

        user.setName(teacherProfileEditDto.getName());
        user.setLastName(teacherProfileEditDto.getSurname());
        user.setPhone(teacherProfileEditDto.getPhone());
        userService.saveUser(user);

        TeacherProfile teacherProfile = teacherProfileRepository.findByUser(user)
                .orElseThrow(() -> new UserNotFoundException("Профиль преподавателя не найден"));

        teacherProfile.setDepartment(teacherProfileEditDto.getDepartment());
        teacherProfile.setQualifications(teacherProfileEditDto.getQualifications());
        teacherProfile.setBio(teacherProfileEditDto.getBio());

        teacherProfileRepository.save(teacherProfile);
    }
    @Override
    public TeacherProfileEditDto getTeacherInformationForEdit(User user){
        return  TeacherProfileEditDto.builder()
                .userId(user.getId())
                .name(user.getName())
                .surname(user.getLastName())
                .phone(user.getPhone())
                .department(getTeacherProfile(user).getDepartment())
                .qualifications(getTeacherProfile(user).getQualifications())
                .bio(getTeacherProfile(user).getBio())
                .build();
    }
}