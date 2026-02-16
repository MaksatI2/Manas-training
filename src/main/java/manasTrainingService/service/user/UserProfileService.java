package manasTrainingService.service.user;


import manasTrainingService.dto.statistics.UserProfileDetailsDto;

public interface UserProfileService {
    UserProfileDetailsDto getProfileDetails(Integer userId);
}
