package manasTrainingService.entity;

public enum LessonType {
    LECTURE("lesson.type.lecture"),
    PRACTICAL("lesson.type.practical"),
    EXAM("lesson.type.exam"),
    CONSULTATION("lesson.type.consultation");

    private final String value;

    LessonType(String messageKey) {
        this.value = messageKey;
    }

    public String getValue() {
        return value;
    }
}
