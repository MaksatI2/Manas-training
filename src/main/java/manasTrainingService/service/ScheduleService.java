package manasTrainingService.service;

import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.dto.statistics.TeacherMonthlyHoursDTO;

import java.util.List;

import java.time.LocalDate;

public interface ScheduleService {
    ScheduleDTO getScheduleByLessonId(Integer lessonId);
    void saveSchedule(ScheduleDTO schedule);
    void deleteSchedule(Integer scheduleId);
    boolean canUserEditSchedule(Integer userId, String userRole, Integer scheduleId);
    List<ScheduleViewDTO> getFilteredSchedules(String courseTitle, String courseInstanceTitle, String teacherName, String lessonType);

    boolean hasSchedulesBeforeDateRange(Integer courseInstanceId, LocalDate newStart);

    boolean hasSchedulesAfterDateRange(Integer courseInstanceId, LocalDate newEnd);

    Integer sumActiveScheduleHoursByCourseInstanceId(Integer courseInstanceId);

    List<TeacherMonthlyHoursDTO> getMonthlyTeacherHourStats();
}