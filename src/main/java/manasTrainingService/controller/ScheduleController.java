package manasTrainingService.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.config.CustomUserDetails;
import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.entity.LessonType;
import manasTrainingService.entity.User;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.*;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.course.CourseTeacherInstanceService;
import manasTrainingService.service.user.UserService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/schedules")
@RequiredArgsConstructor
public class ScheduleController {
    private final LessonService lessonService;
    private final CourseInstanceService courseInstanceService;
    private final ScheduleService scheduleService;
    private final CourseTeacherInstanceService courseTeacherInstanceService;
    private final UserService userService;
    private final ObjectMapper objectMapper;
    private final MessageSource messageSource;

    @GetMapping("/lessons/{lessonId}")
    public String showScheduleForm(@PathVariable Integer lessonId, Model model) {
        CustomUserDetails user = (CustomUserDetails)
                SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!user.hasRole("ADMIN")) {
            Locale locale = LocaleContextHolder.getLocale();
            throw new NoAccessException(messageSource.getMessage("access.no_edit", null, locale));
        }
        LessonDTO lesson = lessonService.getLessonById(lessonId);
        CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceByLessonId(lessonId);
        ScheduleDTO schedule = scheduleService.getScheduleByLessonId(lessonId);

        if (schedule == null) {
            schedule = ScheduleDTO.builder()
                    .lessonId(lessonId)
                    .courseInstanceId(courseInstance.getId())
                    .build();
        }

        Map<String, String> lessonTypesLocalized = Arrays.stream(LessonType.values())
                .collect(Collectors.toMap(LessonType::name, LessonType::getValue));

        Map<String, String> teachers = courseTeacherInstanceService.getTeachersByCourseInstanceId(courseInstance.getId()).stream()
                .sorted(Comparator.comparing(CourseInstanceTeacherDTO::getIsPrimary, Comparator.reverseOrder()))
                .collect(Collectors.toMap(
                        dto -> String.valueOf(dto.getTeacherId()),
                        CourseInstanceTeacherDTO::getTeacherName,
                        (existing, replacement) -> existing,
                        LinkedHashMap::new
                ));

        model.addAttribute("lesson", lesson);
        model.addAttribute("courseInstance", courseInstance);
        model.addAttribute("schedule", schedule);
        model.addAttribute("teachers", teachers);
        model.addAttribute("lessonTypes", lessonTypesLocalized);
        return "lessons/schedule-form";
    }

    @PostMapping("/lessons/{lessonId}")
    public String saveSchedule(
            @PathVariable Integer lessonId,
            @Valid @ModelAttribute("schedule") ScheduleDTO schedule,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {
        Locale locale = LocaleContextHolder.getLocale();

        CustomUserDetails user = (CustomUserDetails)
                SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!user.hasRole("ADMIN")) {
            throw new NoAccessException(messageSource.getMessage("access.no_edit", null, locale));
        }

        if (bindingResult.hasErrors()) {
            CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceByLessonId(lessonId);
            Map<String, String> teachers = courseTeacherInstanceService.getTeachersByCourseInstanceId(courseInstance.getId()).stream()
                    .sorted(Comparator.comparing(CourseInstanceTeacherDTO::getIsPrimary, Comparator.reverseOrder()))
                    .collect(Collectors.toMap(
                            dto -> String.valueOf(dto.getTeacherId()),
                            CourseInstanceTeacherDTO::getTeacherName,
                            (existing, replacement) -> existing,
                            LinkedHashMap::new
                    ));

            model.addAttribute("lesson", lessonService.getLessonById(lessonId));
            model.addAttribute("courseInstance", courseInstance);
            model.addAttribute("teachers", teachers);
            Map<String, String> lessonTypesLocalized = Arrays.stream(LessonType.values())
                    .collect(Collectors.toMap(LessonType::name, LessonType::getValue));
            model.addAttribute("lessonTypes", lessonTypesLocalized);
            model.addAttribute("errorMessage", messageSource.getMessage("form.errors.correct", null, locale));
            return "lessons/schedule-form";
        }

        try {
            scheduleService.saveSchedule(schedule);
            redirectAttributes.addFlashAttribute("successMessage", messageSource.getMessage("schedule.saved.success", null, locale));
            return "redirect:/lessons/" + lessonId;
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceByLessonId(lessonId);
            Map<String, String> teachers = courseTeacherInstanceService.getTeachersByCourseInstanceId(courseInstance.getId()).stream()
                    .sorted(Comparator.comparing(CourseInstanceTeacherDTO::getIsPrimary, Comparator.reverseOrder()))
                    .collect(Collectors.toMap(
                            dto -> String.valueOf(dto.getTeacherId()),
                            CourseInstanceTeacherDTO::getTeacherName,
                            (existing, replacement) -> existing,
                            LinkedHashMap::new
                    ));
            model.addAttribute("lesson", lessonService.getLessonById(lessonId));
            model.addAttribute("courseInstance", courseInstance);
            model.addAttribute("teachers", teachers);
            Map<String, String> lessonTypesLocalized = Arrays.stream(LessonType.values())
                    .collect(Collectors.toMap(LessonType::name, LessonType::getValue));
            model.addAttribute("lessonTypes", lessonTypesLocalized);
            return "lessons/schedule-form";
        }
    }

    @GetMapping
    public String showSchedule(
            Authentication authentication,
            Model model,
            @RequestParam(value = "courseTitle", required = false) String courseTitle,
            @RequestParam(value = "courseInstanceTitle", required = false) String courseInstanceTitle,
            @RequestParam(value = "teacherName", required = false) String teacherName,
            @RequestParam(value = "lessonType", required = false) String lessonType) {

        try {
            User currentUser = userService.getUserEntityByEmail(authentication.getName());
            List<ScheduleViewDTO> schedules = scheduleService.getFilteredSchedules(
                    courseTitle, courseInstanceTitle, teacherName, lessonType);

            String userRole = currentUser.getRole().getName().toLowerCase();
            model.addAttribute("userRole", userRole);
            model.addAttribute("userName", currentUser.getName() + " " + currentUser.getLastName());

            model.addAttribute("courseTitles", getUniqueCourseTitles(schedules));
            model.addAttribute("courseInstanceTitles", getUniqueCourseInstanceTitles(schedules));
            model.addAttribute("teacherNames", getUniqueTeacherNames(schedules));
            model.addAttribute("lessonTypes", LessonType.values());

            model.addAttribute("selectedCourseTitle", courseTitle);
            model.addAttribute("selectedCourseInstanceTitle", courseInstanceTitle);
            model.addAttribute("selectedTeacherName", teacherName);
            model.addAttribute("selectedLessonType", lessonType);

            model.addAttribute("schedulesJson", convertSchedulesToJson(schedules));
            model.addAttribute("schedules", schedules != null ? schedules : new ArrayList<>());
            model.addAttribute("currentDate", LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE));

            return "schedule/calendar";
        } catch (Exception e) {
            Locale locale = LocaleContextHolder.getLocale();
            model.addAttribute("error", messageSource.getMessage("schedule.load.error", null, locale));
            return "schedule/calendar";
        }
    }

    @DeleteMapping("/{scheduleId}")
    @ResponseBody
    public Map<String, Object> deleteSchedule(@PathVariable Integer scheduleId, Authentication authentication) {
        Locale locale = LocaleContextHolder.getLocale();
        Map<String, Object> response = new HashMap<>();

        try {
            User currentUser = userService.getUserEntityByEmail(authentication.getName());
            if (scheduleService.canUserEditSchedule(currentUser.getId(), currentUser.getRole().getName(), scheduleId)) {
                scheduleService.deleteSchedule(scheduleId);
                response.put("success", true);
                response.put("message", messageSource.getMessage("schedule.delete.success", null, locale));
            } else {
                response.put("success", false);
                response.put("message", messageSource.getMessage("schedule.delete.no_access", null, locale));
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", messageSource.getMessage("schedule.delete.error",
                    new Object[]{e.getMessage()}, locale));
        }

        return response;
    }


    private Set<String> getUniqueCourseTitles(List<ScheduleViewDTO> schedules) {
        return schedules.stream()
                .map(ScheduleViewDTO::getCourseTitle)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private Set<String> getUniqueCourseInstanceTitles(List<ScheduleViewDTO> schedules) {
        return schedules.stream()
                .map(ScheduleViewDTO::getCourseInstanceTitle)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private Set<String> getUniqueTeacherNames(List<ScheduleViewDTO> schedules) {
        return schedules.stream()
                .map(ScheduleViewDTO::getTeacherName)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private String convertSchedulesToJson(List<ScheduleViewDTO> schedules) {
        try {
            Map<String, List<Map<String, Object>>> schedulesByDate = schedules.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.groupingBy(
                            schedule -> schedule.getLessonDate().format(DateTimeFormatter.ISO_LOCAL_DATE),
                            LinkedHashMap::new,
                            Collectors.mapping(this::convertToMap, Collectors.toList())
                    ));
            return objectMapper.writeValueAsString(schedulesByDate);
        } catch (JsonProcessingException e) {
            return "{}";
        }
    }

    private Map<String, Object> convertToMap(ScheduleViewDTO schedule) {
        Locale locale = LocaleContextHolder.getLocale();
        Map<String, Object> map = new HashMap<>();
        try {
            map.put("id", schedule.getId());
            map.put("lessonTitle", schedule.getLessonTitle() != null
                    ? schedule.getLessonTitle()
                    : messageSource.getMessage("lesson.title.default", null, locale));

            map.put("lessonType", schedule.getLessonType() != null ?
                    schedule.getLessonType().getValue()
                    : messageSource.getMessage("lesson.type.lecture", null, locale));

            map.put("teacherName", schedule.getTeacherName() != null
                    ? schedule.getTeacherName()
                    : messageSource.getMessage("teacher.not.specified", null, locale));
            map.put("teacherId", schedule.getTeacherId());
            map.put("meetingUrl", schedule.getMeetingUrl());
            map.put("notes", schedule.getNotes());
            map.put("courseTitle", schedule.getCourseTitle() != null
                    ? schedule.getCourseTitle()
                    : messageSource.getMessage("course.title.default", null, locale));
            map.put("courseInstanceTitle", schedule.getCourseInstanceTitle());
            map.put("lessonDescription", schedule.getLessonDescription());
            map.put("durationHours", schedule.getDurationHours());
            map.put("lessonId", schedule.getLessonId());
        } catch (Exception e) {
            map.put("id", schedule.getId() != null ? schedule.getId() : 0);
            map.put("lessonTitle", messageSource.getMessage("error.loading.data", null, locale));
            map.put("lessonType", messageSource.getMessage("lesson.type.lecture", null, locale));
            map.put("teacherName", messageSource.getMessage("teacher.unknown", null, locale));
            map.put("courseTitle", messageSource.getMessage("course.unknown", null, locale));
            map.put("teacherId", 0);
            map.put("lessonId", 0);
        }
        return map;
    }
}