package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.entity.CourseModule;
import manasTrainingService.entity.Lesson;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.EnrollmentService;
import manasTrainingService.service.LessonAccessService;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LessonAccessServiceImpl implements LessonAccessService {

    private final CourseTeacherInstanceService courseInstanceTeacherService;
    private final EnrollmentService courseEnrollmentService;

    @Override
    public boolean canAccessLesson(Lesson lesson) {
        CustomUserDetails user = (CustomUserDetails)
                SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (user.hasRole("ADMIN")) {
            return true;
        }
        if (user.hasRole("TEACHER")) {
            courseInstanceTeacherService.hasAccess(lesson.getModule().getCourseInstance().getId());
            return true;
        }
        if (user.hasRole("STUDENT")) {
            courseEnrollmentService.hasAccess(lesson.getModule().getCourseInstance().getId());
            return true;
        }
        return false;
    }

    @Override
    public boolean canAccessLessonStaff(Lesson lesson) {
        CustomUserDetails user = (CustomUserDetails)
                SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (user.hasRole("ADMIN")) {
            return true;
        }
        if (user.hasRole("TEACHER")) {
            courseInstanceTeacherService.hasAccess(lesson.getModule().getCourseInstance().getId());
            return true;
        }
        return false;
    }

    @Override
    public boolean canAccessModuleCreation(CourseModule module) {
        CustomUserDetails user = (CustomUserDetails)
                SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (user.hasRole("ADMIN")) {
            return true;
        }
        if (user.hasRole("TEACHER")) {
            courseInstanceTeacherService.hasAccess(module.getCourseInstance().getId());
            return true;
        }
        return false;
    }


}
