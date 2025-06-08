package manasTrainingService.exceptions;

public class StudentEmailAlreadyExistsException extends RuntimeException {
    public StudentEmailAlreadyExistsException(String message) {
        super(message);
    }
}
