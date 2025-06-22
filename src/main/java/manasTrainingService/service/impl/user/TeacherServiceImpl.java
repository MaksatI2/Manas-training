package manasTrainingService.service.impl.user;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.dto.create.CreateTeacherDto;
import manasTrainingService.dto.edit.TeacherProfileEditDto;
import manasTrainingService.dto.profile.TeacherProfileDto;
import manasTrainingService.entity.TeacherProfile;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.exceptions.nsee.user.UserNotFoundException;
import manasTrainingService.repositories.user.TeacherProfileRepository;
import manasTrainingService.service.user.TeacherService;
import manasTrainingService.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

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

    @Override
    public Page<TeacherCardDto> getTeachers(Pageable pageable, String search, String department) {
        List<TeacherCardDto> filtered = teacherProfileRepository.findAll()
                .stream()
                .filter(tp -> {
                    User user = tp.getUser();
                    return user != null &&
                            Boolean.TRUE.equals(user.getIsActive()) &&
                            user.getRole() != null &&
                            "TEACHER".equalsIgnoreCase(user.getRole().getName()) &&
                            (search == null || (user.getName() + " " + user.getLastName())
                                    .toLowerCase().contains(search.toLowerCase())) &&
                            (department == null || department.isBlank() || tp.getDepartment().equalsIgnoreCase(department));
                })
                .map(tp -> {
                    User user = tp.getUser();
                    return TeacherCardDto.builder()
                            .id(user.getId().longValue())
                            .fullName(user.getName() + " " + user.getLastName())
                            .avatarUrl(user.getAvatarUrl())
                            .department(tp.getDepartment())
                            .email(user.getEmail())
                            .phone(user.getPhone())
                            .build();
                })
                .toList();

        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), filtered.size());
        List<TeacherCardDto> pageContent = filtered.subList(start, end);

        return new PageImpl<>(pageContent, pageable, filtered.size());
    }

    @Override
    public TeacherProfileDto getTeacherProfileById(Long id) {
        User user = userService.getUserById(id.intValue());

        if (!"TEACHER".equalsIgnoreCase(user.getRole().getName())) {
            throw new UserNotFoundException("Пользователь не является преподавателем");
        }

        TeacherProfile teacherProfile = teacherProfileRepository.findByUser(user)
                .orElseThrow(() -> new UserNotFoundException("Профиль преподавателя не найден"));

        return TeacherProfileDto.builder()
                .teacher(user)
                .department(teacherProfile.getDepartment())
                .qualifications(teacherProfile.getQualifications())
                .bio(teacherProfile.getBio())
                .avatarUrl(user.getAvatarUrl())
                .build();
    }

}