package manasTrainingService.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.repositories.course.CourseInstanceRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class CourseInstanceScheduler {

    private final CourseInstanceRepository courseInstanceRepository;

    @Transactional
    @Scheduled(cron = "0 0 3 * * ?", zone = "Asia/Bishkek")
    public void checkCourseInstances() {
        try {
            List<CourseInstance> allInstances = courseInstanceRepository.findAll();
            if (allInstances == null || allInstances.isEmpty()) {
                log.warn("Список курсов пуст или равен null");
                return;
            }

            for (CourseInstance instance : allInstances) {

                if (instance.getEndDate().isBefore(LocalDateTime.now())) {
                    if (Boolean.TRUE.equals(instance.getIsActive())) {
                        instance.setIsActive(false);
                        log.info("Курс '{}' (ID: {}) деактивирован (конец курса уже прошел).", instance.getTitle(), instance.getId());
                    }
                }
            }
            courseInstanceRepository.saveAll(allInstances);
            log.info("Конец выполнения планировщика");
        } catch (Exception e) {
            log.error("Ошибка в планировщике проверки курсов", e);
        }
    }
}