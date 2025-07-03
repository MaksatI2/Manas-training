package manasTrainingService.service;

import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;

public interface LessonAccessService {

    boolean canAccessLesson(Lesson lesson);

    boolean canAccessLessonStaff(Lesson lesson);

    boolean canAccessModuleCreation(CourseModule module);
}
