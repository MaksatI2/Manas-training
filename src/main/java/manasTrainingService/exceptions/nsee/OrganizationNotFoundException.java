package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class OrganizationNotFoundException extends RuntimeException {
    public OrganizationNotFoundException(String message) {
        super(message);
    }
}
