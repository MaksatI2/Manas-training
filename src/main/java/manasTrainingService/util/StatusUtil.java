package manasTrainingService.util;

import manasTrainingService.entity.Status;

import java.util.HashMap;
import java.util.Map;

public class StatusUtil {

    private static final Map<Status, String> RUSSIAN_LABELS = new HashMap<>();

    static {
        RUSSIAN_LABELS.put(Status.PENDING, "В ожидании");
        RUSSIAN_LABELS.put(Status.APPROVED, "Одобрен");
        RUSSIAN_LABELS.put(Status.REJECTED, "Отклонён");
        RUSSIAN_LABELS.put(Status.ENROLLED, "Записан");
        RUSSIAN_LABELS.put(Status.IN_PROGRESS, "В процессе");
        RUSSIAN_LABELS.put(Status.COMPLETED, "Завершён");
        RUSSIAN_LABELS.put(Status.DROPPED, "Отчислен");
        RUSSIAN_LABELS.put(Status.PRESENT, "Присутствует");
        RUSSIAN_LABELS.put(Status.ABSENT, "Отсутствует");
        RUSSIAN_LABELS.put(Status.LATE, "Опоздал");
        RUSSIAN_LABELS.put(Status.EXCUSED, "Уваж. причина");
    }

    public static String localize(Status status) {
        return RUSSIAN_LABELS.getOrDefault(status, "Неизвестно");
    }
}
