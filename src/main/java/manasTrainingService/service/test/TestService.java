package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.answers.TestResultDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.Test;

public interface TestService {
    void createTest(TestDto testDto);

    void editTest(TestDto testDto);

    TestDto getTestById(int id);

    TestDto getTestByCourseId(int id);

    Test getTestEntityByCourseId(int id);

    Test getTestEntityById(int id);

    TestResultDto checkTestResult(TestAnswerDto result);

    void deleteTest(int id);
}
