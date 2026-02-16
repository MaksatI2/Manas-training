package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.ActivityLogs;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;
import manasTrainingService.repositories.ActivityLogRepository;
import manasTrainingService.service.ActivityLogService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ActivityLogServiceImpl implements ActivityLogService {

    private final ActivityLogRepository activityLogRepository;

    @Override
    public void log(User user,
                    ActionType action,
                    TargetType targetType,
                    Integer targetId) {
        ActivityLogs log = ActivityLogs.builder()
                .user(user)
                .action(action)
                .targetType(targetType)
                .targetId(targetId)
                .build();
        activityLogRepository.save(log);
    }


}
