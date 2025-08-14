package manasTrainingService.service.impl.course;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseModuleApiDto;
import manasTrainingService.dto.instance.CourseModuleCreationDTO;
import manasTrainingService.dto.instance.CourseModuleDTO;
import manasTrainingService.dto.instance.CourseModuleUpdateDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ModuleNotFoundException;
import manasTrainingService.repositories.course.CourseModuleRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseModuleService;
import manasTrainingService.service.user.UserService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CourseModuleServiceImpl implements CourseModuleService {

    private final CourseModuleRepository courseModuleRepository;
    private final CourseInstanceService courseInstanceService;
    private final ActivityLogService activityLogService;
    private final UserService userService;
    private final MessageSource messageSource;

    @Transactional
    @Override
    public void createCourseModules(Integer courseInstanceId, List<CourseModuleCreationDTO> dtos) {
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(courseInstanceId);

        int existingModulesHours = courseInstance.getModules().stream()
                .mapToInt(m -> m.getDurationHours() != null ? m.getDurationHours() : 0)
                .sum();

        int newModulesHours = dtos.stream()
                .mapToInt(dto -> dto.getDurationHours() != null ? dto.getDurationHours() : 0)
                .sum();

        int totalHoursAfterAdd = existingModulesHours + newModulesHours;

        validateTotalDuration(courseInstance, null, totalHoursAfterAdd);

        int currentMaxOrder = courseInstance.getModules().stream()
                .mapToInt(CourseModule::getOrderIndex)
                .max()
                .orElse(-1);

        List<CourseModule> modules = new ArrayList<>();
        for (int i = 0; i < dtos.size(); i++) {
            CourseModuleCreationDTO dto = dtos.get(i);
            CourseModule module = CourseModule.builder()
                    .courseInstance(courseInstance)
                    .title(dto.getTitle())
                    .durationHours(dto.getDurationHours())
                    .description(dto.getDescription())
                    .orderIndex(currentMaxOrder + i + 1)
                    .isActive(true)
                    .build();
            modules.add(module);
        }

        List<CourseModule> saved = courseModuleRepository.saveAll(modules);
        for (CourseModule m : saved) {
            activityLogService.log(
                    userService.getAuthorizedUser(),
                    ActionType.CREATE,
                    TargetType.COURSE_MODULE,
                    m.getId()
            );
        }
    }

    @Transactional
    public void deleteCourseModule(Integer moduleId) {
        if (!courseModuleRepository.existsById(moduleId)) {
            String message = messageSource.getMessage(
                    "module.not.found",
                    new Object[]{moduleId},
                    LocaleContextHolder.getLocale()
            );
            throw new IllegalArgumentException(message);
        }
        courseModuleRepository.deleteById(moduleId);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.COURSE_MODULE,
                moduleId
        );
    }

    @Override
    public CourseModule getCourseModuleById(Integer moduleId) {
        return courseModuleRepository.findById(moduleId)
                .orElseThrow(() -> {
                    String message = messageSource.getMessage(
                            "module.not.found.simple",
                            null,
                            LocaleContextHolder.getLocale()
                    );
                    return new ModuleNotFoundException(message);
                });
    }


    private CourseModuleDTO convertToDto(CourseModule module) {
        return CourseModuleDTO.builder()
                .id(module.getId())
                .title(module.getTitle())
                .durationHours(module.getDurationHours())
                .description(module.getDescription())
                .orderIndex(module.getOrderIndex())
                .courseInstanceId(module.getCourseInstance().getId())
                .lessons(module.getLessons().stream()
                        .map(lesson -> LessonDTO.builder()
                                .id(lesson.getId())
                                .title(lesson.getTitle())
                                .description(lesson.getDescription())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }

    @Override
    public List<CourseModuleApiDto> getModuleApiDtosByCourseInstanceId(Integer courseInstanceId) {
        return courseModuleRepository.findByCourseInstanceIdOrderByOrderIndexAsc(courseInstanceId).stream()
                .map(module -> {
                    CourseModuleApiDto dto = new CourseModuleApiDto();
                    dto.setTitle(module.getTitle());
                    dto.setDurationHours(module.getDurationHours());
                    dto.setOrderIndex(module.getOrderIndex());
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Override
    public void deleteByIdIfNoLessons(Integer moduleId) {
        CourseModule module = getCourseModuleById(moduleId);
        if (!module.getLessons().isEmpty()) {
            String message = messageSource.getMessage(
                    "module.has.lessons",
                    null,
                    LocaleContextHolder.getLocale()
            );
            throw new IllegalStateException(message);
        }

        courseModuleRepository.deleteById(moduleId);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.COURSE_MODULE,
                moduleId
        );
    }

    @Override
    public CourseModuleUpdateDTO getModuleForUpdate(Integer moduleId) {
        CourseModule module = getCourseModuleById(moduleId);
        CourseModuleUpdateDTO updateDTO = new CourseModuleUpdateDTO();
        updateDTO.setTitle(module.getTitle());
        updateDTO.setDurationHours(module.getDurationHours());
        updateDTO.setDescription(module.getDescription());
        return updateDTO;
    }

    @Override
    public void updateModule(Integer moduleId, CourseModuleUpdateDTO dto) {
        CourseModule module = getCourseModuleById(moduleId);
        CourseInstance courseInstance = module.getCourseInstance();
        List<Lesson> lessons = module.getLessons();

        Integer newModuleHours = dto.getDurationHours();

        int totalScheduledHours = lessons.stream()
                .filter(lesson -> lesson.getSchedules() != null && !lesson.getSchedules().isEmpty())
                .flatMap(lesson -> lesson.getSchedules().stream())
                .mapToInt(schedule -> schedule.getDurationHours() != null ? schedule.getDurationHours() : 0)
                .sum();

        if (newModuleHours < totalScheduledHours) {
            String message = messageSource.getMessage(
                    "module.duration.less.than.scheduled",
                    new Object[]{newModuleHours, totalScheduledHours},
                    LocaleContextHolder.getLocale()
            );
            throw new IllegalStateException(message);
        }


        int totalOtherModulesHours = courseInstance.getModules().stream()
                .filter(m -> !m.getId().equals(moduleId))
                .mapToInt(m -> m.getDurationHours() != null ? m.getDurationHours() : 0)
                .sum();
        int totalAfterUpdate = totalOtherModulesHours + (dto.getDurationHours() != null ? dto.getDurationHours() : 0);

        validateTotalDuration(courseInstance, moduleId, totalAfterUpdate);

        module.setTitle(dto.getTitle());
        module.setDurationHours(dto.getDurationHours());
        module.setDescription(dto.getDescription());
        CourseModule updated = courseModuleRepository.save(module);

        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.UPDATE,
                TargetType.COURSE_MODULE,
                updated.getId()
        );
    }

    private void validateTotalDuration(CourseInstance courseInstance, Integer updatingModuleId, int totalNewDuration) {
        int maxAllowedHours = courseInstance.getCourse().getDurationHours();
        if (totalNewDuration > maxAllowedHours) {
            String message = messageSource.getMessage(
                    "module.total.duration.exceeds",
                    new Object[]{totalNewDuration, maxAllowedHours},
                    LocaleContextHolder.getLocale()
            );
            throw new IllegalStateException(message);
        }
    }


    @Override
    public CourseModuleDTO getCourseModuleDTOById(Integer moduleId) {
        return convertToDto(courseModuleRepository.findById(moduleId).orElseThrow(() -> new ModuleNotFoundException(messageSource.getMessage(
                "module.not.found.simple",
                null,
                LocaleContextHolder.getLocale()
        ))));
    }
}
