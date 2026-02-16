package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class TestResultNotFoundException extends EntityNotFoundException {
    public TestResultNotFoundException(String message) {
        super(message);
    }
}
