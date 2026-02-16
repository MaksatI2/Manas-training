package manasTrainingService.service.test;

import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.TestInstance;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface TestInstanceService {
    @Transactional
    void addTestToCourseInstance(TestInstanceDto testInstanceDto);

    @Transactional
    void changeTestToCourseInstance(TestInstanceDto testInstanceDto);

    TestInstanceDto getTestInstanceByCourseInstanceId(int courseInstanceId);

    TestInstanceDto getTestInstanceById(int id);

    TestInstance getTestInstanceEntityById(int id);

    void deleteTestFromTestInstance(int courseInstanceId);

    Boolean isValidAccessTime(int courseInstanceId);

    Boolean isTestInstanceExist(int courseInstanceId);

    Boolean isAvailableTime(int courseInstanceId);

    Optional<TestInstance> getTestInstanceModelByCourseInstanceId(Integer id);

    @Transactional
    void changeTestInstanceTime(TestInstanceDto testInstanceDto);
}
