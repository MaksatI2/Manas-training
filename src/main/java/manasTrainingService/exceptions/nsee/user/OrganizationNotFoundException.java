package manasTrainingService.exceptions.nsee.user;

import jakarta.persistence.EntityNotFoundException;

public class OrganizationNotFoundException extends EntityNotFoundException {
    public OrganizationNotFoundException(String message) {
        super(message);
    }
}
