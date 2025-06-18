package manasTrainingService.service;

import manasTrainingService.dto.lesson.ScheduleDTO;
import org.springframework.transaction.annotation.Transactional;

public interface ScheduleService {
    ScheduleDTO getScheduleByLessonId(Integer lessonId);

    @Transactional
    void saveSchedule(ScheduleDTO schedule);
}
