package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class StudentProfileNotFoundException extends NoSuchElementException {
    public StudentProfileNotFoundException(String message) {
        super(message);
    }
}
