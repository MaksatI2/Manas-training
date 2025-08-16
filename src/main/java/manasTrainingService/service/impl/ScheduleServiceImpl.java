package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.dto.statistics.TeacherMonthlyHoursDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.service.ActivityLogService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.user.UserService;
import manasTrainingService.util.DateUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService {
    private final ScheduleRepository scheduleRepository;
    private final LessonService lessonService;
    private final CourseInstanceService courseInstanceService;
    private final UserService userService;
    private final EnrollmentService enrollmentService;
    private final ActivityLogService activityLogService;
    private final MessageSource messageSource;

    @Override
    public ScheduleDTO getScheduleByLessonId(Integer lessonId) {
        Schedule schedule = scheduleRepository.findByLessonId(lessonId).orElse(null);
        if (schedule == null) {
            return null;
        }
        return ScheduleDTO.builder()
                .id(schedule.getId())
                .courseInstanceId(schedule.getCourseInstance().getId())
                .lessonId(lessonId)
                .lessonDate(schedule.getLessonDate())
                .durationHours(schedule.getDurationHours())
                .teacherId(schedule.getTeacher().getId())
                .title(schedule.getTitle())
                .lessonType(schedule.getLessonType())
                .notes(schedule.getNotes())
                .formattedLessonDate(DateUtil.format(schedule.getLessonDate()))
                .teacherName(schedule.getTeacher().getName() + " " + schedule.getTeacher().getLastName())
                .build();
    }

    @Transactional
    @Override
    public void saveSchedule(ScheduleDTO schedule) {
        Lesson lesson = lessonService.getLessonModelById(schedule.getLessonId());
        CourseInstance courseInstance = courseInstanceService.getCourseInstanceModelById(schedule.getCourseInstanceId());
        User teacher = userService.getUserById(schedule.getTeacherId());

        CourseModule module = lesson.getModule();
        Integer moduleMaxHours = module.getDurationHours() != null ? module.getDurationHours() : 0;

        List<Lesson> moduleLessons = module.getLessons();

        Integer totalScheduledHours = moduleLessons.stream()
                .flatMap(l -> l.getSchedules() != null ? l.getSchedules().stream() : null)
                .filter(s -> schedule.getId() == null || !s.getId().equals(schedule.getId()))
                .mapToInt(s -> s.getDurationHours() != null ? s.getDurationHours() : 0)
                .sum();

        Integer newScheduleHours = schedule.getDurationHours() != null ? schedule.getDurationHours() : 0;
        Integer totalAfterUpdate = totalScheduledHours + newScheduleHours;

        if (totalAfterUpdate > moduleMaxHours) {
            throw new IllegalArgumentException(
                    messageSource.getMessage(
                            "module.hours.limit.exceeded",
                            new Object[]{totalAfterUpdate, moduleMaxHours},
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        int teacherHours = scheduleRepository.getTotalTeacherHoursForDate(
                teacher.getId(), schedule.getLessonDate(), schedule.getId());

        if (teacherHours + schedule.getDurationHours() > 8) {
            throw new IllegalArgumentException(
                    messageSource.getMessage(
                            "teacher.daily.hours.limit.exceeded",
                            new Object[]{8},
                            LocaleContextHolder.getLocale()
                    )
            );
        }

        List<CourseEnrollment> enrollments = enrollmentService.findAllEnrollmentsForCourseInstance(courseInstance.getId());
        List<User> students = enrollments.stream()
                .map(CourseEnrollment::getStudent)
                .filter(Objects::nonNull)
                .toList();

        List<String> violatingStudents = new ArrayList<>();

        for (User student : students) {
            int studentHours = scheduleRepository.getTotalStudentHoursForDate(
                    student.getId(), schedule.getLessonDate(), schedule.getId());

            if (studentHours + schedule.getDurationHours() > 8) {
                violatingStudents.add(student.getName());
            }
        }

        if (!violatingStudents.isEmpty()) {
            throw new IllegalArgumentException(
                    messageSource.getMessage(
                            "students.daily.hours.limit.exceeded",
                            new Object[]{String.join(", ", violatingStudents), 8},
                            LocaleContextHolder.getLocale()
                    )
            );
        }




        Schedule entity = schedule.getId() != null
                ? scheduleRepository.findById(schedule.getId())
                .orElseThrow(() -> new ScheduleNotFouneException(
                        messageSource.getMessage("schedule.not.found", null, LocaleContextHolder.getLocale())
                ))
                : new Schedule();


        entity.setLesson(lesson);
        entity.setCourseInstance(courseInstance);
        entity.setLessonDate(schedule.getLessonDate());
        entity.setDurationHours(schedule.getDurationHours());
        entity.setTeacher(teacher);
        entity.setTitle(schedule.getTitle());
        entity.setLessonType(schedule.getLessonType());
        entity.setNotes(schedule.getNotes());
        entity.setIsActive(true);

        Schedule saved = scheduleRepository.save(entity);

        activityLogService.log(
                userService.getAuthorizedUser(),
                schedule.getId() == null ? ActionType.CREATE : ActionType.UPDATE,
                TargetType.SCHEDULE,
                saved.getId()
        );
    }

    @Transactional
    @Override
    public void deleteSchedule(Integer scheduleId) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new ScheduleNotFouneException(messageSource.getMessage("schedule.not.found", null, LocaleContextHolder.getLocale())));
        schedule.setIsActive(false);
        Schedule saved = scheduleRepository.save(schedule);
        activityLogService.log(
                userService.getAuthorizedUser(),
                ActionType.DELETE,
                TargetType.SCHEDULE,
                saved.getId()
        );
    }

    @Override
    public boolean canUserEditSchedule(Integer userId, String userRole, Integer scheduleId) {
        if ("ADMIN".equals(userRole)) {
            return true;
        }
        if ("TEACHER".equals(userRole)) {
            Schedule schedule = scheduleRepository.findById(scheduleId).orElse(null);
            return schedule != null && schedule.getTeacher().getId().equals(userId);
        }
        return false;
    }

    @Override
    public List<ScheduleViewDTO> getFilteredSchedules(String courseTitle, String courseInstanceTitle,
                                                      String teacherName, String lessonType) {
        LessonType typeEnum = null;
        if (lessonType != null && !lessonType.isEmpty()) {
            try {
                typeEnum = LessonType.valueOf(lessonType);
            } catch (IllegalArgumentException ignored) {}
        }

        List<Schedule> schedules = scheduleRepository.findWithFilters(
                courseTitle, courseInstanceTitle, teacherName, typeEnum);

        return schedules.stream()
                .map(this::mapToScheduleViewDTO)
                .collect(Collectors.toList());
    }

    @Override
    public boolean hasSchedulesBeforeDateRange(Integer courseInstanceId, LocalDate newStart) {
        return scheduleRepository.existsByCourseInstanceIdAndLessonDateBeforeStart(courseInstanceId, newStart);
    }

    @Override
    public boolean hasSchedulesAfterDateRange(Integer courseInstanceId, LocalDate newEnd) {
        return scheduleRepository.existsByCourseInstanceIdAndLessonDateAfterEnd(courseInstanceId, newEnd);
    }

    private ScheduleViewDTO mapToScheduleViewDTO(Schedule schedule) {
        CourseInstance courseInstance = schedule.getCourseInstance();
        Course course = courseInstance.getCourse();
        Lesson lesson = schedule.getLesson();
        User teacher = schedule.getTeacher();

        return ScheduleViewDTO.builder()
                .id(schedule.getId())
                .lessonId(schedule.getLesson().getId())
                .courseInstanceId(courseInstance.getId())
                .courseTitle(course.getTitle())
                .courseInstanceTitle(courseInstance.getTitle())
                .lessonTitle(lesson.getTitle())
                .lessonDescription(lesson.getDescription())
                .lessonDate(schedule.getLessonDate())
                .durationHours(schedule.getDurationHours())
                .teacherName(teacher.getName() + " " + teacher.getLastName())
                .teacherId(teacher.getId())
                .lessonType(schedule.getLessonType())
                .notes(schedule.getNotes())
                .isActive(schedule.getIsActive())
                .build();
    }

    @Override
    public Integer sumActiveScheduleHoursByCourseInstanceId(Integer courseInstanceId) {
        return scheduleRepository.sumActiveScheduleHoursByCourseInstanceId(courseInstanceId);
    }


    @Override
    public List<TeacherMonthlyHoursDTO> getMonthlyTeacherHourStats(String monthStr, String yearStr) {
        LocalDate now = LocalDate.now();

        int month = parseMonthOrDefault(monthStr, now.getMonthValue());
        int year = parseYearOrDefault(yearStr, now.getYear());

        return fetchTeacherHours(month, year);
    }

    private int parseMonthOrDefault(String monthStr, int defaultMonth) {
        try {
            int parsed = Integer.parseInt(monthStr);
            if (parsed >= 1 && parsed <= 12) {
                return parsed;
            }
        } catch (Exception ignored) {}
        return defaultMonth;
    }

    private int parseYearOrDefault(String yearStr, int defaultYear) {
        try {
            return Integer.parseInt(yearStr);
        } catch (Exception ignored) {}
        return defaultYear;
    }

    private List<TeacherMonthlyHoursDTO> fetchTeacherHours(int month, int year) {
        return scheduleRepository.getMonthlyTeachingHoursPerTeacher(month, year);
    }


    @Override
    public List<Integer> getAvailableYears() {
        return scheduleRepository.findDistinctYears();
    }
}