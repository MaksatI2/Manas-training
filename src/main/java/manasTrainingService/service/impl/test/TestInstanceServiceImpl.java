package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.TestInstanceNotFoundException;
import manasTrainingService.repositories.test.TestInstanceRepository;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TestInstanceServiceImpl implements TestInstanceService {

    private final TestInstanceRepository testInstanceRepository;
    private final CourseInstanceService courseInstanceService;
    private final TestService testService;

    @Transactional
    @Override
    public void addTestToCourseInstance(TestInstanceDto testInstanceDto){
        TestInstance testInstance = new TestInstance();
        LocalDateTime scheduledStart = parseDateRange(testInstanceDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testInstanceDto).get(1);

        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        if (courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate().isBefore(scheduledStart.toLocalDate())
                || courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate().isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException("Дата начала тестирования не может быть позднее даты окончания курса");
        }

        testInstance.setInstance(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()));
        testInstance.setTest(testService.getTestEntityById(testInstanceDto.getTestId()));
        testInstance.setScheduledStart(scheduledStart);
        testInstance.setScheduledEnd(scheduledEnd);

        testInstanceRepository.saveAndFlush(testInstance);
    }

    @Transactional
    @Override
    public void changeTestToCourseInstance(TestInstanceDto testInstanceDto){
        TestInstance testInstance = testInstanceRepository.findByCourseInstanceId(testInstanceDto.getCourseInstanceId())
                .orElseThrow(() -> new TestInstanceNotFoundException("Тест к потоку не найден"));
        LocalDateTime scheduledStart = parseDateRange(testInstanceDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testInstanceDto).get(1);
        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата не может быть в прошлом");
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException("Дата открытия доступа не может быть после даты закрытия доступа");
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException("Дата и время не могут быть равны");
        }
        if (courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate().isBefore(scheduledStart.toLocalDate())
                || courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate().isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException("Дата начала тестирования не может быть позднее даты окончания курса");
        }

        testInstance.setInstance(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()));
        testInstance.setTest(testService.getTestEntityById(testInstanceDto.getTestId()));
        testInstance.setScheduledStart(scheduledStart);
        testInstance.setScheduledEnd(scheduledEnd);

        testInstanceRepository.saveAndFlush(testInstance);
    }

        private List<LocalDateTime> parseDateRange(TestInstanceDto testInstanceDto) {
        LocalDateTime start = testInstanceDto.getStartDate().atTime(testInstanceDto.getStartTime());
        LocalDateTime end = testInstanceDto.getEndDate().atTime(testInstanceDto.getEndTime());
        List<LocalDateTime> dates = new ArrayList<>();
        dates.add(start);
        dates.add(end);
        return dates;
    }

    @Override
    public TestInstanceDto getTestInstanceByCourseInstance(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByCourseInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException("Для этого потока еще не был назначен тест"));
        return TestInstanceDto.builder()
                .id(testInstance.getId())
                .test(TestDto.builder()
                        .id(testInstance.getTest().getId())
                        .title(testInstance.getTest().getTitle())
                        .isActive(testInstance.getTest().getIsActive())
                        .build())
                .courseInstanceId(testInstance.getInstance().getId())
                .startDate(testInstance.getScheduledStart().toLocalDate())
                .endDate(testInstance.getScheduledEnd().toLocalDate())
                .startTime(testInstance.getScheduledStart().toLocalTime())
                .endTime(testInstance.getScheduledEnd().toLocalTime())
                .build();
    }

    @Override
    public void deleteTestFromTestInstance(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByCourseInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException("Тест к потоку не найден"));
        testInstanceRepository.delete(testInstance);
    }

    @Override
    public Boolean isValidAccessTime(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByCourseInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException("Тест к потоку не найден"));
        return testInstance.getScheduledStart().isBefore(LocalDateTime.now()) && testInstance.getScheduledEnd().isAfter(LocalDateTime.now());
    }
}
