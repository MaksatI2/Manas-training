package manasTrainingService.service.jitsi;

import manasTrainingService.dto.jitsi.JoinMeetingRequestDTO;
import manasTrainingService.dto.jitsi.MeetingParticipantDTO;

public interface MeetingParticipantService {

    MeetingParticipantDTO joinMeeting(JoinMeetingRequestDTO request);

    void leaveMeeting(Integer meetingId, Integer userId);

    void leaveMeetingByParticipantId(Integer meetingId, String participantId);
}