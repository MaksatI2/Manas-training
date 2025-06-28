package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.user.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
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
                .meetingUrl(schedule.getMeetingUrl())
                .notes(schedule.getNotes())
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
                    "Превышен лимит часов модуля. Установлено: " + totalAfterUpdate +
                            " ч, допустимо: " + moduleMaxHours + " ч."
            );
        }

        int teacherHours = scheduleRepository.getTotalTeacherHoursForDate(
                teacher.getId(), schedule.getLessonDate(), schedule.getId());

        if (teacherHours + schedule.getDurationHours() > 8) {
            throw new IllegalArgumentException("У преподавателя превышен лимит 8 часов на день");
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
            throw new IllegalArgumentException("У следующих студентов превышен лимит 8 часов на день: " +
                    String.join(", ", violatingStudents));
        }




        Schedule entity = schedule.getId() != null
                ? scheduleRepository.findById(schedule.getId())
                .orElseThrow(() -> new ScheduleNotFouneException("Расписание не найдено"))
                : new Schedule();

        entity.setLesson(lesson);
        entity.setCourseInstance(courseInstance);
        entity.setLessonDate(schedule.getLessonDate());
        entity.setDurationHours(schedule.getDurationHours());
        entity.setTeacher(teacher);
        entity.setTitle(schedule.getTitle());
        entity.setLessonType(schedule.getLessonType());
        entity.setMeetingUrl(schedule.getMeetingUrl());
        entity.setNotes(schedule.getNotes());
        entity.setIsActive(true);

        scheduleRepository.save(entity);
    }

    @Transactional
    @Override
    public void deleteSchedule(Integer scheduleId) {
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new ScheduleNotFouneException("Schedule not found"));
        schedule.setIsActive(false);
        scheduleRepository.save(schedule);
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
    public List<ScheduleViewDTO> getFilteredAndSortedSchedules(String courseTitle, String courseInstanceTitle,
                                                               String teacherName, String lessonType,
                                                               String sortBy, String sortDir) {
        List<ScheduleViewDTO> schedules = getFilteredSchedules(
                courseTitle, courseInstanceTitle, teacherName, lessonType);
        return sortSchedules(schedules, sortBy, sortDir);
    }

    private List<ScheduleViewDTO> sortSchedules(List<ScheduleViewDTO> schedules, String sortBy, String sortDir) {
        Comparator<ScheduleViewDTO> comparator = getComparator(sortBy);
        if ("desc".equalsIgnoreCase(sortDir)) {
            comparator = comparator.reversed();
        }
        return schedules.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    private Comparator<ScheduleViewDTO> getComparator(String sortBy) {
        switch (sortBy != null ? sortBy.toLowerCase() : "date") {
            case "course":
                return Comparator.comparing(s -> s.getCourseTitle() != null ? s.getCourseTitle() : "");
            case "teacher":
                return Comparator.comparing(s -> s.getTeacherName() != null ? s.getTeacherName() : "");
            case "type":
                return Comparator.comparing(s -> s.getLessonType() != null ? s.getLessonType().name() : "");
            case "lesson":
                return Comparator.comparing(s -> s.getLessonTitle() != null ? s.getLessonTitle() : "");
            case "date":
            default:
                return Comparator.comparing(ScheduleViewDTO::getLessonDate);
        }
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
                .meetingUrl(schedule.getMeetingUrl())
                .notes(schedule.getNotes())
                .isActive(schedule.getIsActive())
                .build();
    }
}