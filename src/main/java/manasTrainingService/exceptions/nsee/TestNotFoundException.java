package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class TestNotFoundException extends EntityNotFoundException {
    public TestNotFoundException(String message) {
        super(message);
    }
}
