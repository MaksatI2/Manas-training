package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class ModuleNotFoundException extends NoSuchElementException {
    public ModuleNotFoundException(String message) {
        super(message);
    }
}
