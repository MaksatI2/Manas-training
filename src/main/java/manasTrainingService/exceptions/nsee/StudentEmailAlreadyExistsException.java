package manasTrainingService.exceptions.nsee;

public class StudentEmailAlreadyExistsException extends RuntimeException {
    public StudentEmailAlreadyExistsException(String message) {
        super(message);
    }
}
