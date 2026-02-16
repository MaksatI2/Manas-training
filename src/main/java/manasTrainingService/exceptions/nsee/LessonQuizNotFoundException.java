package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class LessonQuizNotFoundException extends EntityNotFoundException {
    public LessonQuizNotFoundException(String message) {
        super(message);
    }
}
