package manasTrainingService.exceptions.nsee;

public class OrganizationEmailAlreadyExistsException extends RuntimeException {
    public OrganizationEmailAlreadyExistsException(String message) {
        super(message);
    }
}