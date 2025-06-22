package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.entity.*;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.repositories.CourseEnrollmentRepository;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService {
    private final ScheduleRepository scheduleRepository;
    private final LessonService lessonService;
    private final CourseInstanceService courseInstanceService;
    private final UserService userService;

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

        Schedule entity = schedule.getId() != null
                ? scheduleRepository.findById(schedule.getId())
                .orElseThrow(() -> new ScheduleNotFouneException("Schedule not found"))
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