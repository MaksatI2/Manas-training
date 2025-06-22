package manasTrainingService.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.ScheduleViewDTO;
import manasTrainingService.dto.instance.CourseInstanceDTO;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.dto.lesson.ScheduleDTO;
import manasTrainingService.dto.teacher.CourseInstanceTeacherDTO;
import manasTrainingService.entity.LessonType;
import manasTrainingService.entity.User;
import manasTrainingService.service.*;
import org.springframework.security.core.Authentication;
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

    @GetMapping("/lessons/{lessonId}")
    public String showScheduleForm(@PathVariable Integer lessonId, Model model) {
        LessonDTO lesson = lessonService.getLessonById(lessonId);
        CourseInstanceDTO courseInstance = courseInstanceService.getCourseInstanceByLessonId(lessonId);
        ScheduleDTO schedule = scheduleService.getScheduleByLessonId(lessonId);

        if (schedule == null) {
            schedule = ScheduleDTO.builder()
                    .lessonId(lessonId)
                    .courseInstanceId(courseInstance.getId())
                    .isOnline(false)
                    .isActive(true)
                    .build();
        }

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
        model.addAttribute("lessonTypes", LessonType.values());
        return "lessons/schedule-form";
    }

    @PostMapping("/lessons/{lessonId}")
    public String saveSchedule(
            @PathVariable Integer lessonId,
            @Valid @ModelAttribute("schedule") ScheduleDTO schedule,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

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
            model.addAttribute("lessonTypes", LessonType.values());
            model.addAttribute("errorMessage", "Пожалуйста, исправьте ошибки в форме");
            return "lessons/schedule-form";
        }

        try {
            scheduleService.saveSchedule(schedule);
            redirectAttributes.addFlashAttribute("success", "Расписание сохранено");
            return "redirect:/lessons/" + lessonId;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/lessons/" + lessonId;
        }
    }

    @GetMapping
    public String showSchedule(
            Authentication authentication,
            Model model,
            @RequestParam(value = "courseTitle", required = false) String courseTitle,
            @RequestParam(value = "courseInstanceTitle", required = false) String courseInstanceTitle,
            @RequestParam(value = "teacherName", required = false) String teacherName,
            @RequestParam(value = "lessonType", required = false) String lessonType,
            @RequestParam(value = "sortBy", required = false, defaultValue = "date") String sortBy,
            @RequestParam(value = "sortDir", required = false, defaultValue = "asc") String sortDir) {

        try {
            User currentUser = userService.getUserEntityByEmail(authentication.getName());
            List<ScheduleViewDTO> schedules = scheduleService.getFilteredAndSortedSchedules(
                    courseTitle, courseInstanceTitle, teacherName, lessonType, sortBy, sortDir);

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
            model.addAttribute("selectedSortBy", sortBy);
            model.addAttribute("selectedSortDir", sortDir);

            model.addAttribute("schedulesJson", convertSchedulesToJson(schedules));
            model.addAttribute("schedules", schedules != null ? schedules : new ArrayList<>());
            model.addAttribute("currentDate", LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE));

            return "schedule/calendar";
        } catch (Exception e) {
            model.addAttribute("error", "Произошла ошибка при загрузке расписания");
            return "schedule/calendar";
        }
    }

    @DeleteMapping("/{scheduleId}")
    @ResponseBody
    public Map<String, Object> deleteSchedule(@PathVariable Integer scheduleId, Authentication authentication) {
        Map<String, Object> response = new HashMap<>();
        try {
            User currentUser = userService.getUserEntityByEmail(authentication.getName());
            if (scheduleService.canUserEditSchedule(currentUser.getId(), currentUser.getRole().getName(), scheduleId)) {
                scheduleService.deleteSchedule(scheduleId);
                response.put("success", true);
                response.put("message", "Расписание успешно удалено");
            } else {
                response.put("success", false);
                response.put("message", "Недостаточно прав для удаления расписания");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Ошибка при удалении расписания: " + e.getMessage());
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
        Map<String, Object> map = new HashMap<>();
        try {
            map.put("id", schedule.getId());
            map.put("lessonTitle", schedule.getLessonTitle() != null ? schedule.getLessonTitle() : "Без названия");
            map.put("lessonType", schedule.getLessonType() != null ? schedule.getLessonType().name() : "LECTURE");
            map.put("teacherName", schedule.getTeacherName() != null ? schedule.getTeacherName() : "Преподаватель не указан");
            map.put("teacherId", schedule.getTeacherId());
            map.put("meetingUrl", schedule.getMeetingUrl());
            map.put("notes", schedule.getNotes());
            map.put("courseTitle", schedule.getCourseTitle() != null ? schedule.getCourseTitle() : "Курс не указан");
            map.put("courseInstanceTitle", schedule.getCourseInstanceTitle());
            map.put("lessonDescription", schedule.getLessonDescription());
            map.put("durationHours", schedule.getDurationHours());
            map.put("lessonId", schedule.getLessonId());
        } catch (Exception e) {
            map.put("id", schedule.getId() != null ? schedule.getId() : 0);
            map.put("lessonTitle", "Ошибка загрузки данных");
            map.put("lessonType", "LECTURE");
            map.put("teacherName", "Неизвестно");
            map.put("courseTitle", "Неизвестно");
            map.put("teacherId", 0);
            map.put("lessonId", 0);
        }
        return map;
    }
}