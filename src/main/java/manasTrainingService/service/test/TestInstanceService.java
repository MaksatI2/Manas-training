package manasTrainingService.service.test;

import manasTrainingService.dto.tests.TestInstanceDto;
import org.springframework.transaction.annotation.Transactional;

public interface TestInstanceService {
    @Transactional
    void addTestToCourseInstance(TestInstanceDto testInstanceDto);

    @Transactional
    void changeTestToCourseInstance(TestInstanceDto testInstanceDto);

    TestInstanceDto getTestInstanceByCourseInstance(int courseInstanceId);

    void deleteTestFromTestInstance(int courseInstanceId);

    Boolean isValidAccessTime(int courseInstanceId);
}
