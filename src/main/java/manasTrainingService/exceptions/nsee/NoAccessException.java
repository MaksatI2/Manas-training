package manasTrainingService.exceptions.nsee;

import org.springframework.security.access.AccessDeniedException;

public class NoAccessException extends AccessDeniedException {
    public NoAccessException(String message) {
        super(message);
    }
}
