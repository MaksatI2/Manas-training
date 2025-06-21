package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.Schedule;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.ScheduleNotFouneException;
import manasTrainingService.repositories.ScheduleRepository;
import manasTrainingService.service.CourseInstanceService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

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
        entity.setIsOnline(true);
        entity.setMeetingUrl(schedule.getMeetingUrl());
        entity.setNotes(schedule.getNotes());
        entity.setIsActive(true);

        scheduleRepository.save(entity);
    }

    @Override
    public boolean hasSchedulesOutsideDateRange(Integer courseInstanceId, LocalDate newStart, LocalDate newEnd) {
        return scheduleRepository.existsByCourseInstanceIdAndLessonDateOutsideRange(courseInstanceId, newStart, newEnd);
    }

    @Override
    public boolean hasSchedulesBeforeDateRange(Integer courseInstanceId, LocalDate newStart) {
        return scheduleRepository.existsByCourseInstanceIdAndLessonDateBeforeStart(courseInstanceId, newStart);
    }

    @Override
    public boolean hasSchedulesAfterDateRange(Integer courseInstanceId, LocalDate newEnd) {
        return scheduleRepository.existsByCourseInstanceIdAndLessonDateAfterEnd(courseInstanceId, newEnd);
    }

}
