package manasTrainingService.exceptions;

public class OrganizationEmailAlreadyExistsException extends RuntimeException {
    public OrganizationEmailAlreadyExistsException(String message) {
        super(message);
    }
}