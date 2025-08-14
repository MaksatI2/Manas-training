package manasTrainingService.exceptions.nsee.user;

import jakarta.persistence.EntityNotFoundException;

public class RoleNotFoundException extends EntityNotFoundException {
    public RoleNotFoundException(String message) {
        super(message);
    }
}
