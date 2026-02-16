package manasTrainingService.exceptions.nsee.jitsi;

import jakarta.persistence.EntityNotFoundException;

public class MeetingNotFoundException extends EntityNotFoundException {
    public MeetingNotFoundException(String message) {
        super(message);
    }
}
