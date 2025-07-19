package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.Test;

import java.util.List;

public interface TestService {
    void createTest(TestDto testDto);

    void editTest(TestDto testDto);

    TestDto getTestById(int id);

    TestDto getTestByCourseId(int id);

    Test getTestEntityByCourseId(int id);

    Test getTestEntityById(int id);

    TestResultDto checkTestResult(TestAnswerDto result);

    Integer deactivateTest(int id);

    Integer activateTest(int id);

    List<TestDto> getAllTestsByCourseId(int courseId);

    void clearNoData(TestDto testDto);

    Integer deleteTest(int id);

    long getTotalTests();
}
