package manasTrainingService.entity;

public enum LessonType {
    LECTURE("lecture"),
    PRACTICAL("practical"),
    EXAM("exam"),
    CONSULTATION("consultation");

    private final String value;

    LessonType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}