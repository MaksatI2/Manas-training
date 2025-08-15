package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.MeetingAnalyticsDTO;

public interface MeetingAnalyticsService {
    MeetingAnalyticsDTO getMeetingAnalytics(Integer meetingId);
    MeetingAnalyticsDTO getScheduleAnalytics(Integer scheduleId);
}