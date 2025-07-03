package manasTrainingService.entity;

public enum LessonType {
    LECTURE("Лекция"),
    PRACTICAL("Практическое занятие"),
    EXAM("Экзамен"),
    CONSULTATION("Консультация");

    private final String value;

    LessonType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
