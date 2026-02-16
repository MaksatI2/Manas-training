package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class TestQuestionNotFoundException extends EntityNotFoundException {
    public TestQuestionNotFoundException(String message) {
        super(message);
    }
}
