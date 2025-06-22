package manasTrainingService.exceptions.nsee.user;

public class OrganizationNameAlreadyExistsException extends RuntimeException {
    public OrganizationNameAlreadyExistsException(String message) {
        super(message);
    }
}
