package manasTrainingService.exceptions.nsee.course;

import java.util.NoSuchElementException;

public class CourseCategoryNotFoundException extends NoSuchElementException {
    public CourseCategoryNotFoundException(String message) {
        super(message);
    }
}
