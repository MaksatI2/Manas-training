package manasTrainingService.exceptions;

public class OrganizationPhoneAlreadyExistsException extends RuntimeException {
    public OrganizationPhoneAlreadyExistsException(String message) {
        super(message);
    }
}