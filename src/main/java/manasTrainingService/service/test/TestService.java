package manasTrainingService.service.test;

import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.entity.Test;

public interface TestService {
    void createTest(TestDto testDto);

    void editTest(TestDto testDto);

    TestDto getTestById(int id);

    Test getTestEntityById(int id);

    void checkTestResunt(TestAnswerDto result);
}
