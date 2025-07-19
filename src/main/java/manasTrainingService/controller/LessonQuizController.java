package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.entity.LessonQuiz;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.user.LessonQuizAlreadyCreatedException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.quiz.LessonQuizService;
import org.springframework.expression.AccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalTime;

@Controller
@RequestMapping("quiz")
@RequiredArgsConstructor
public class LessonQuizController {

    private final LessonQuizService lessonQuizService;
    private final LessonService lessonService;
    private final LessonAccessService lessonAccessService;

    @GetMapping("create/{lessonId}")
    public String createQuizPage(@PathVariable Integer lessonId, Model model, HttpServletRequest request) {
        if(!lessonAccessService.canAccessLessonQuizCreate(lessonService.getLessonModelById(lessonId))){
            throw new NoAccessException("У вас нет доступа к созданию теста");
        }
        if(lessonService.getLessonModelById(lessonId).getLessonQuiz() != null) {
            throw new LessonQuizAlreadyCreatedException("Тест к данному уроку уже был создан");
        }
        LessonQuizDto lessonQuizDto = new LessonQuizDto();
        String url = request.getHeader("Referer");
        if(url != null){
            request.getSession().setAttribute("redirectAfterCreate", url);
        }else {
            request.getSession().setAttribute("redirectAfterCreate", "/");
        }
        lessonQuizDto.setLessonId(lessonId);
        model.addAttribute("lessonQuiz", lessonQuizDto);
        return "quizzes/quiz_create";
    }

    @PostMapping("create")
    public String createQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes,
                             HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            return "quizzes/quiz_create";
        }
        String redirectUrl = request.getSession().getAttribute("redirectAfterCreate").toString();
        request.getSession().removeAttribute("redirectAfterCreate");
        lessonQuizService.createQuiz(lessonQuizDto);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно создан");
        return "redirect:" + redirectUrl;
    }

    @GetMapping("{id}/edit")
    public String editQuizPage(@PathVariable Integer id, Model model, HttpServletRequest request) {
        if(!lessonAccessService.canAccessLessonQuizEdit(lessonQuizService.getQuizEntityById(id))){
            throw new NoAccessException("У вас нет доступа к редактированию теста");
        }
        String url = request.getHeader("Referer");
        if(url != null){
            request.getSession().setAttribute("redirectAfterEdit", url);
        } else {
            request.getSession().setAttribute("redirectAfterEdit", "/");
        }
        model.addAttribute("lessonQuiz", lessonQuizService.getQuizById(id));
        return "quizzes/quiz_edit";
    }

    @PostMapping("edit")
    public String editQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto,
                           BindingResult bindingResult,
                           RedirectAttributes redirectAttributes,
                           HttpServletRequest request){
        if (bindingResult.hasErrors()) {
            return "quizzes/quiz_edit";
        }
        String redirectUrl = request.getSession().getAttribute("redirectAfterEdit").toString();
        request.getSession().removeAttribute("redirectAfterEdit");
        lessonQuizService.editQuiz(lessonQuizDto);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно изменен");
        return "redirect:" + redirectUrl;
    }

    @GetMapping("{id}/passing")
    public String getQuizPassingPage(@PathVariable int id, Model model) {
        if(!lessonAccessService.canAccessLessonQuizPassing(lessonQuizService.getQuizEntityById(id))){
            throw new NoAccessException("У вас нет доступа к прохождению тестов");
        }
        if(!lessonQuizService.getQuizById(id).getIsActive()){
            throw new NoAccessException("Тестирование сейчас не доступно");
        }
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

    @GetMapping("{id}/delete")
    public String deleteQuiz(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpServletRequest httpServletRequest) {
        if(!lessonAccessService.canAccessLessonQuizDelete(lessonQuizService.getQuizEntityById(id))){
            throw new NoAccessException("У вас нет доступа к удалению теста");
        }
        String url = httpServletRequest.getHeader("Referer");
        lessonQuizService.deleteQuiz(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно удален");
        if(url == null){
            return "redirect:/";
        }
        return "redirect:" + url;
    }

    @GetMapping("{id}/activate")
    public String activateQuiz(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpServletRequest httpServletRequest) {
        lessonQuizService.activateQuiz(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно активирован");
        return "redirect:" + httpServletRequest.getHeader("Referer");
    }

    @GetMapping("{id}/deactivate")
    public String deactivateQuiz(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpServletRequest httpServletRequest) {
        lessonQuizService.deactivateQuiz(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно деактивирован");
        return "redirect:" + httpServletRequest.getHeader("Referer");
    }

}
