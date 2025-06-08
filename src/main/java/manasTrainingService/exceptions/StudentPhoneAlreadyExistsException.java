package manasTrainingService.exceptions;

public class StudentPhoneAlreadyExistsException extends RuntimeException {
    public StudentPhoneAlreadyExistsException(String message) {
        super(message);
    }
}
