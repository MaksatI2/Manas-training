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

    TestDto getTestForPassingById(int id);

    TestDto getTestByCourseId(int id);

    Test getTestEntityByCourseId(int id);

    Test getTestEntityById(int id);

    TestResultDto checkTestResult(TestAnswerDto result);

    void deactivateTest(int id);

    void activateTest(int id);

    List<TestDto> getAllTestsByCourseId(int courseId);

    void clearNoData(TestDto testDto);

    void deleteTest(int id);

    long getTotalTests();

    Boolean testExistById(int id);

    TestDto getTestByIdForTestResult(int testInstanceId);
}
