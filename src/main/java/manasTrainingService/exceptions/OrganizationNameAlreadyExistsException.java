package manasTrainingService.exceptions;

public class OrganizationNameAlreadyExistsException extends RuntimeException {
    public OrganizationNameAlreadyExistsException(String message) {
        super(message);
    }
}
