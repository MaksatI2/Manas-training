package manasTrainingService.service;

import manasTrainingService.entity.CourseInstance;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.entity.LessonQuiz;

public interface LessonAccessService {

    boolean canAccessLesson(Lesson lesson);

    boolean canAccessLessonQuizPassing(LessonQuiz lessonQuiz);

    boolean canAccessLessonStaff(Lesson lesson);

    boolean canAccessModuleCreation(CourseModule module);

    boolean canAccessLessonQuizCreate(Lesson lesson);

    boolean canAccessLessonQuizEdit(LessonQuiz lessonQuiz);

    boolean canAccessLessonQuizDelete(LessonQuiz lessonQuiz);

    boolean canAccessInstanceStatistics(CourseInstance instance);
}
