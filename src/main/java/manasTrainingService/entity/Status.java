package manasTrainingService.entity;

public enum Status {
    PENDING("pending"),
    APPROVED("approved"),
    REJECTED("rejected"),
    ENROLLED("enrolled"),
    IN_PROGRESS("in_progress"),
    COMPLETED("completed"),
    DROPPED("dropped"),
    PRESENT("present"),
    ABSENT("absent"),
    LATE("late"),
    ACTIVE("active"),
    ENDED("ended"),
    EXCUSED("excused");

    private final String value;

    Status(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}