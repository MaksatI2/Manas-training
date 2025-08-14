package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class QuestionOptionNotFoundException extends EntityNotFoundException {
    public QuestionOptionNotFoundException(String message) {
        super(message);
    }
}
