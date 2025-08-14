package manasTrainingService.exceptions.nsee.user;

import jakarta.persistence.EntityNotFoundException;

public class OrganizationCodeNotFound extends EntityNotFoundException {
    public OrganizationCodeNotFound(String message) {
        super(message);
    }
}
