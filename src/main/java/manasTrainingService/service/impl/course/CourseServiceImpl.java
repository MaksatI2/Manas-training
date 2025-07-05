package manasTrainingService.service.impl.course;

import jakarta.persistence.EntityNotFoundException;
import manasTrainingService.dto.CourseCategoryDto;
import manasTrainingService.dto.CourseDto;
import manasTrainingService.dto.TeacherCardDto;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.course.CourseNotFoundException;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import manasTrainingService.repositories.course.CourseRepository;
import manasTrainingService.repositories.course.CourseTeacherRepository;
import manasTrainingService.service.course.CourseCategoryService;
import manasTrainingService.service.course.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;

@Service
public class CourseServiceImpl implements CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CourseCategoryService categoryService;

    @Autowired
    private CourseCategoryService categoryAdminService;

    @Autowired
    private CourseInstanceRepository courseInstanceRepository;

    @Autowired
    private CourseTeacherRepository courseTeacherRepository;

    @Override
    public List<CourseDto> getAllCourses() {
        return courseRepository.findAll().stream().map(this::toDto).toList();
    }

    @Override
    public CourseDto getById(Integer id) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Курс с ID " + id + " не найден"));
        return convertToDto(course);
    }

    @Override
    public List<CourseCategoryDto> getCategories() {
        return categoryService.getAllCategories();
    }

    private CourseDto toDto(Course course) {
        CourseDto dto = new CourseDto();
        dto.setId(course.getId());
        dto.setTitle(course.getTitle());
        dto.setCode(course.getCode());
        dto.setDescription(course.getDescription());
        dto.setDuration(course.getDurationHours());
        dto.setCategory(toCategoryDto(course.getCategory()));
        return dto;
    }

    private CourseCategoryDto toCategoryDto(CourseCategory category) {
        CourseCategoryDto dto = new CourseCategoryDto();
        dto.setId(category.getId());
        dto.setName(category.getName());
        return dto;
    }

    public CourseDto convertToDto(Course course) {
        CourseCategoryDto categoryDto = categoryAdminService.convertToDto(course.getCategory());
        return CourseDto.builder()
                .id(course.getId())
                .title(course.getTitle())
                .code(course.getCode())
                .description(course.getDescription())
                .duration(course.getDurationHours())
                .individual(course.getIsIndividual())
                .active(course.getIsActive())
                .createdAt(course.getCreatedAt())
                .updatedAt(course.getUpdatedAt())
                .category(categoryDto)
                .categoryId(course.getCategory().getId())
                .build();
    }

    @Override
    public Course getCourseById(Integer id) {
        return courseRepository.findById(id).orElseThrow(() -> new CourseNotFoundException("Курс не был найден"));
    }

    @Override
    public List<CourseDto> getAvailableCoursesForOrganization(User organizationUser) {
        return courseInstanceRepository.findAllByIsActiveTrue().stream()
                .filter(ci -> ci.getCourse() != null)
                .map(CourseInstance::getCourse)
                .filter(distinctByKey(Course::getId))
                .map(course -> CourseDto.builder()
                        .id(course.getId())
                        .title(course.getTitle())
                        .code(course.getCode())
                        .description(course.getDescription())
                        .duration(course.getDurationHours())
                        .individual(course.getIsIndividual())
                        .active(course.getIsActive())
                        .createdAt(course.getCreatedAt())
                        .updatedAt(course.getUpdatedAt())
                        .categoryId(course.getCategory().getId())
                        .build()
                ).toList();
    }

    @Override
    public List<TeacherCardDto> getTeachersByCourse(Integer courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new CourseNotFoundException("Курс не найден"));

        List<CourseTeacher> courseTeachers = courseTeacherRepository.findByCourseId(courseId);

        return courseTeachers.stream()
                .map(ct -> {
                    User teacher = ct.getTeacher();
                    return TeacherCardDto.builder()
                            .id(Long.valueOf(teacher.getId()))
                            .fullName(teacher.getName() + " " + teacher.getLastName())
                            .email(teacher.getEmail())
                            .avatarUrl(teacher.getAvatarUrl())
                            .phone(teacher.getPhone())
                            .build();
                })
                .toList();
    }

    private static <T> Predicate<T> distinctByKey(Function<? super T, ?> keyExtractor) {
        Set<Object> seen = ConcurrentHashMap.newKeySet();
        return t -> seen.add(keyExtractor.apply(t));
    }

}