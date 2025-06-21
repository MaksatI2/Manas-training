package manasTrainingService.controller;

import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.instance.LessonDTO;
import manasTrainingService.service.LessonMaterialService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.ScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@RequiredArgsConstructor
public class PublicLessonController {

    private final LessonService lessonService;
    private final LessonMaterialService lessonMaterialsService;
    private final ScheduleService scheduleService;

    @GetMapping("/lessons/{lessonId}")
    public String showLessonDetails(@PathVariable Integer lessonId, Model model) {
        LessonDTO lesson = lessonService.getLessonById(lessonId);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materials", lessonMaterialsService.getMaterialsByLessonId(lessonId));
        model.addAttribute("schedule", scheduleService.getScheduleByLessonId(lessonId));
        return "lessons/lesson";
    }
}