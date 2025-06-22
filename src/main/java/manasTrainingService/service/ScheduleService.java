package manasTrainingService.service;

import manasTrainingService.dto.lesson.ScheduleDTO;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

public interface ScheduleService {
    ScheduleDTO getScheduleByLessonId(Integer lessonId);

    @Transactional
    void saveSchedule(ScheduleDTO schedule);

    boolean hasSchedulesOutsideDateRange(Integer courseInstanceId, LocalDate newStart, LocalDate newEnd);

    boolean hasSchedulesBeforeDateRange(Integer courseInstanceId, LocalDate newStart);

    boolean hasSchedulesAfterDateRange(Integer courseInstanceId, LocalDate newEnd);
}
