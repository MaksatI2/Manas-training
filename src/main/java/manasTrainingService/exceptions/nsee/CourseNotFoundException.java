package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class CourseNotFoundException extends NoSuchElementException {
    public CourseNotFoundException(String message) {
        super(message);
    }
}
