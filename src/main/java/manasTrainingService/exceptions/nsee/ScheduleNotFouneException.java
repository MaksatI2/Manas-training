package manasTrainingService.exceptions.nsee;

import java.util.NoSuchElementException;

public class ScheduleNotFouneException extends NoSuchElementException {
    public ScheduleNotFouneException(String message) {
        super(message);
    }
}
