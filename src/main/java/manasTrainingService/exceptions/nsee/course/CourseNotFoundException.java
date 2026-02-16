package manasTrainingService.exceptions.nsee.course;

import java.util.NoSuchElementException;

public class CourseNotFoundException extends NoSuchElementException {
    public CourseNotFoundException(String message) {
        super(message);
    }
}
