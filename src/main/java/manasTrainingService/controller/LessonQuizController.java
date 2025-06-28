package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.quiz.LessonQuizService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalTime;

@Controller
@RequestMapping("quiz")
@RequiredArgsConstructor
public class LessonQuizController {

    private final LessonQuizService lessonQuizService;
    private final LessonService lessonService;

    @GetMapping("create/{lessonId}")
    public String createQuizPage(@PathVariable Integer lessonId, Model model) {
        LessonQuizDto lessonQuizDto = new LessonQuizDto();
        lessonQuizDto.setLessonId(lessonId);
        System.out.println(lessonService.getLessonById(lessonId));
        model.addAttribute("lessonQuiz", lessonQuizDto);
        return "quizzes/quiz_create";
    }

    @PostMapping("create")
    public String createQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            return "quizzes/quiz_create";
        }
        lessonQuizService.createQuiz(lessonQuizDto);
        return "redirect:/";
    }

    @GetMapping("{id}/edit")
    public String editQuizPage(@PathVariable Integer id, Model model) {
        model.addAttribute("lessonQuiz", lessonQuizService.getQuizById(id));
        return "quizzes/quiz_edit";
    }

    @PostMapping("edit")
    public String editQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            return "quizzes/quiz_edit";
        }
        lessonQuizService.editQuiz(lessonQuizDto);
        return "redirect:/";
    }

    @GetMapping("{id}/passing")
    public String getQuizPassingPage(@PathVariable int id, Model model) {
        QuizAnswerDto quizAnswerDto = new QuizAnswerDto();
        quizAnswerDto.setPassingStart(LocalTime.now());
        quizAnswerDto.setQuizId(id);
        model.addAttribute("result", quizAnswerDto);
        model.addAttribute("quiz", lessonQuizService.getQuizById(id));
        return "quizzes/quiz_passing";
    }

    @PostMapping("checking")
    public String checkResults(@Valid QuizAnswerDto quizAnswerDto, Model model){
        model.addAttribute("results", lessonQuizService.checkQuizResults(quizAnswerDto));
        return "quizzes/quiz_passed_result_page";
    }
}
