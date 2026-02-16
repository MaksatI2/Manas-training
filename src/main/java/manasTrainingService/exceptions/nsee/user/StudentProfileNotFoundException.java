package manasTrainingService.exceptions.nsee.user;

import java.util.NoSuchElementException;

public class StudentProfileNotFoundException extends NoSuchElementException {
    public StudentProfileNotFoundException(String message) {
        super(message);
    }
}
