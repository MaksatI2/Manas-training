package manasTrainingService.service;

import manasTrainingService.entity.Lesson;

public interface LessonAccessService {

    boolean canAccessLesson(Lesson lesson);
}
