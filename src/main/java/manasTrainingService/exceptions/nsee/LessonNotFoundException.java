package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class LessonNotFoundException extends NoSuchElementException {
    public LessonNotFoundException(String message) {
        super(message);
    }
}
