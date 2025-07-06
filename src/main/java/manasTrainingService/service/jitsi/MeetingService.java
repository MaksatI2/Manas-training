package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.EndMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingResponseDTO;
import manasTrainingService.dto.jitsi.StartMeetingRequestDTO;

public interface MeetingService {

    MeetingResponseDTO startMeeting(StartMeetingRequestDTO request);

    void endMeeting(EndMeetingRequestDTO request);

    MeetingResponseDTO getMeetingByScheduleId(Integer scheduleId);

    MeetingResponseDTO getMeetingById(Integer meetingId);

    boolean isMeetingActive(Integer scheduleId);

    boolean canUserAccessMeeting(Integer userId, String userRole, Integer meetingId);
}