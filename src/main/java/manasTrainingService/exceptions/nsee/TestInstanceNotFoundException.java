package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class TestInstanceNotFoundException extends EntityNotFoundException {
    public TestInstanceNotFoundException(String message) {
        super(message);
    }
}
