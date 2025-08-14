package manasTrainingService.exceptions.nsee;

import jakarta.persistence.EntityNotFoundException;

public class LessonQuizOptionNotFoundException extends EntityNotFoundException {
    public LessonQuizOptionNotFoundException(String message) {
        super(message);
    }
}
