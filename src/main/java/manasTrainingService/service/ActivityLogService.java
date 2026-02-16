package manasTrainingService.service;

import manasTrainingService.entity.ActionType;
import manasTrainingService.entity.TargetType;
import manasTrainingService.entity.User;

public interface ActivityLogService {

    void log(User user,
             ActionType action,
             TargetType targetType,
             Integer targetId);
}
