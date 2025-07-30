package manasTrainingService.entity;

import java.time.LocalDate;

public enum MonthYear {
    JANUARY(1, "Январь"),
    FEBRUARY(2, "Февраль"),
    MARCH(3, "Март"),
    APRIL(4, "Апрель"),
    MAY(5, "Май"),
    JUNE(6, "Июнь"),
    JULY(7, "Июль"),
    AUGUST(8, "Август"),
    SEPTEMBER(9, "Сентябрь"),
    OCTOBER(10, "Октябрь"),
    NOVEMBER(11, "Ноябрь"),
    DECEMBER(12, "Декабрь");

    private final int monthNumber;
    private final String russianName;

    MonthYear(int monthNumber, String russianName) {
        this.monthNumber = monthNumber;
        this.russianName = russianName;
    }

    public int getMonthNumber() {
        return monthNumber;
    }

    public String getRussianName() {
        return russianName;
    }

    public String format(int year) {
        return russianName + " " + year;
    }

    public static MonthYear fromMonthNumber(int monthNumber) {
        for (MonthYear m : values()) {
            if (m.monthNumber == monthNumber) return m;
        }
        throw new IllegalArgumentException("Invalid month number: " + monthNumber);
    }

    public static String currentMonthYear() {
        LocalDate now = LocalDate.now();
        MonthYear currentMonth = fromMonthNumber(now.getMonthValue());
        return currentMonth.format(now.getYear());
    }
}
