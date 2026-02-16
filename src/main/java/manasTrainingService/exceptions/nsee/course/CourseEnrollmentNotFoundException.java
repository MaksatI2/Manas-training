package manasTrainingService.exceptions.nsee.course;

import jakarta.persistence.EntityNotFoundException;

public class CourseEnrollmentNotFoundException extends EntityNotFoundException {
    public CourseEnrollmentNotFoundException(String message) {
        super(message);
    }
}
