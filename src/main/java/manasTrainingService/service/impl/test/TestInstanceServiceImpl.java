package manasTrainingService.service.impl.test;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.TestInstance;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.TestInstanceNotFoundException;
import manasTrainingService.repositories.test.TestInstanceRepository;
import manasTrainingService.service.NotificationService;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TestInstanceServiceImpl implements TestInstanceService {

    private final TestInstanceRepository testInstanceRepository;
    private final CourseInstanceService courseInstanceService;
    private final TestService testService;
    private final NotificationService notificationService;
    private final MessageSource messageSource;

    @Transactional
    @Override
    public void addTestToCourseInstance(TestInstanceDto testInstanceDto){
        TestInstance testInstance = new TestInstance();
        LocalDateTime scheduledStart = parseDateRange(testInstanceDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testInstanceDto).get(1);
        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.in.past", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("access.start.after.end", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.start.equals.end", null, LocaleContextHolder.getLocale())
            );
        }
        LocalDate courseEndDate = courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate();
        if (courseEndDate.isBefore(scheduledStart.toLocalDate()) || courseEndDate.isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException(
                    messageSource.getMessage("test.start.after.course.end", null, LocaleContextHolder.getLocale())
            );
        }


        testInstance.setInstance(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()));
        testInstance.setTest(testService.getTestEntityById(testInstanceDto.getTestId()));
        testInstance.setScheduledStart(scheduledStart);
        testInstance.setScheduledEnd(scheduledEnd);

        testInstanceRepository.saveAndFlush(testInstance);
        notificationService.notifyStudentsAboutTest(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()), testInstance, "добавлен");

    }

    @Transactional
    @Override
    public void changeTestToCourseInstance(TestInstanceDto testInstanceDto){
        TestInstance testInstance = testInstanceRepository.findByInstanceId(testInstanceDto.getCourseInstanceId())
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage("test-instance.not.found", null, LocaleContextHolder.getLocale())
                ));
        LocalDateTime scheduledStart = parseDateRange(testInstanceDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testInstanceDto).get(1);
        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.in.past", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("access.start.after.end", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.start.equals.end", null, LocaleContextHolder.getLocale())
            );
        }
        LocalDate courseEndDate = courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate();
        if (courseEndDate.isBefore(scheduledStart.toLocalDate()) || courseEndDate.isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException(
                    messageSource.getMessage("test.start.after.course.end", null, LocaleContextHolder.getLocale())
            );
        }


        testInstance.setInstance(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()));
        testInstance.setTest(testService.getTestEntityById(testInstanceDto.getTestId()));
        testInstance.setScheduledStart(scheduledStart);
        testInstance.setScheduledEnd(scheduledEnd);

        testInstanceRepository.saveAndFlush(testInstance);
        notificationService.notifyStudentsAboutTest(courseInstanceService.getCourseInstanceModelById(testInstanceDto.getCourseInstanceId()), testInstance, "обновлен");

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
    public TestInstanceDto getTestInstanceByCourseInstanceId(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage(
                                "test.instance.not.assigned",
                                null,
                                "Для этого потока еще не был назначен тест",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return TestInstanceDto.builder()
                .id(testInstance.getId())
                .test(TestDto.builder()
                        .id(testInstance.getTest().getId())
                        .title(testInstance.getTest().getTitle())
                        .passingScore(testInstance.getTest().getPassingScore().intValue())
                        .isActive(testInstance.getTest().getIsActive())
                        .build())
                .courseInstanceId(testInstance.getInstance().getId())
                .courseInstance(CourseInstanceDTO.builder()
                        .id(testInstance.getInstance().getId())
                        .title(testInstance.getInstance().getTitle())
                        .build())
                .startDate(testInstance.getScheduledStart().toLocalDate())
                .endDate(testInstance.getScheduledEnd().toLocalDate())
                .startTime(testInstance.getScheduledStart().toLocalTime())
                .endTime(testInstance.getScheduledEnd().toLocalTime())
                .isEnded(testInstance.getScheduledEnd().isBefore(LocalDateTime.now()))
                .build();
    }

    @Override
    public TestInstanceDto getTestInstanceById(int id){
        TestInstance testInstance = testInstanceRepository.findById(id)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage(
                                "test.instance.not.assigned",
                                null,
                                "Для этого потока еще не был назначен тест",
                                LocaleContextHolder.getLocale()
                        )
                ));
        return TestInstanceDto.builder()
                .id(testInstance.getId())
                .test(TestDto.builder()
                        .id(testInstance.getTest().getId())
                        .title(testInstance.getTest().getTitle())
                        .passingScore(testInstance.getTest().getPassingScore().intValue())
                        .isActive(testInstance.getTest().getIsActive())
                        .build())
                .courseInstanceId(testInstance.getInstance().getId())
                .courseInstance(CourseInstanceDTO.builder()
                        .id(testInstance.getInstance().getId())
                        .title(testInstance.getInstance().getTitle())
                        .build())
                .startDate(testInstance.getScheduledStart().toLocalDate())
                .endDate(testInstance.getScheduledEnd().toLocalDate())
                .startTime(testInstance.getScheduledStart().toLocalTime())
                .endTime(testInstance.getScheduledEnd().toLocalTime())
                .isEnded(testInstance.getScheduledEnd().isBefore(LocalDateTime.now()))
                .build();
    }

    @Override
    public TestInstance getTestInstanceEntityById(int id){
        return testInstanceRepository.findById(id)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage(
                                "test.instance.not.assigned",
                                null,
                                "Для этого потока еще не был назначен тест",
                                LocaleContextHolder.getLocale()
                        )
                ));
    }


    @Transactional
    @Override
    public void deleteTestFromTestInstance(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage("test-instance.not.found", null, LocaleContextHolder.getLocale())
                ));
        CourseInstance courseInstance = testInstance.getInstance();
        courseInstance.setTestInstance(null);
        testInstanceRepository.delete(testInstance);
    }

    @Override
    public Boolean isValidAccessTime(int id){
        TestInstance testInstance = testInstanceRepository.findById(id)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage("test-instance.not.found", null, LocaleContextHolder.getLocale())
                ));
        return testInstance.getScheduledStart().isBefore(LocalDateTime.now()) && testInstance.getScheduledEnd().isAfter(LocalDateTime.now());
    }

    @Override
    public Boolean isTestInstanceExist(int courseInstanceId){
        return testInstanceRepository.existsByInstanceId(courseInstanceId);
    }

    @Override
    public Boolean isAvailableTime(int courseInstanceId){
        TestInstance testInstance = testInstanceRepository.findByInstanceId(courseInstanceId)
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage("test-instance.not.found", null, LocaleContextHolder.getLocale())
                ));
        return testInstance.getScheduledStart().isBefore(LocalDateTime.now()) && testInstance.getScheduledEnd().isAfter(LocalDateTime.now());
    }

    @Override
    public Optional<TestInstance> getTestInstanceModelByCourseInstanceId(Integer id) {
        return testInstanceRepository.findByInstanceId(id);
    }

    @Transactional
    @Override
    public void changeTestInstanceTime(TestInstanceDto testInstanceDto){
        TestInstance testInstance = testInstanceRepository.findByInstanceId(testInstanceDto.getCourseInstanceId())
                .orElseThrow(() -> new TestInstanceNotFoundException(
                        messageSource.getMessage("test-instance.not.found", null, LocaleContextHolder.getLocale())
                ));
        LocalDateTime scheduledStart = parseDateRange(testInstanceDto).get(0);
        LocalDateTime scheduledEnd = parseDateRange(testInstanceDto).get(1);
        if (LocalDateTime.now().isAfter(scheduledStart) && LocalDateTime.now().isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.in.past", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.isAfter(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("access.start.after.end", null, LocaleContextHolder.getLocale())
            );
        }
        if (scheduledStart.equals(scheduledEnd)) {
            throw new IncorrectDateException(
                    messageSource.getMessage("date.start.equals.end", null, LocaleContextHolder.getLocale())
            );
        }
        LocalDate courseEndDate = courseInstanceService.getCourseInstanceById(testInstanceDto.getCourseInstanceId()).getEndDate();
        if (courseEndDate.isBefore(scheduledStart.toLocalDate()) || courseEndDate.isBefore(scheduledEnd.toLocalDate())) {
            throw new IncorrectDateException(
                    messageSource.getMessage("test.start.after.course.end", null, LocaleContextHolder.getLocale())
            );
        }
        testInstance.setScheduledStart(scheduledStart);
        testInstance.setScheduledEnd(scheduledEnd);

        testInstanceRepository.saveAndFlush(testInstance);
    }
}
