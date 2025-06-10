package manasTrainingService.exceptions.nsee;

public class ForbiddenFileTypeException extends RuntimeException {

    public ForbiddenFileTypeException() {
        super("File type not supported");
    }
}
