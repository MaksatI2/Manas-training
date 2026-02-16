package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.quiz.LessonQuizDto;
import manasTrainingService.dto.quiz.answers.QuizAnswerDto;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.exceptions.nsee.user.LessonQuizAlreadyCreatedException;
import manasTrainingService.service.LessonAccessService;
import manasTrainingService.service.LessonService;
import manasTrainingService.service.quiz.LessonQuizQuestionService;
import manasTrainingService.service.quiz.LessonQuizService;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Locale;

@Controller
@RequestMapping("quiz")
@RequiredArgsConstructor
public class LessonQuizController {

    private final LessonQuizService lessonQuizService;
    private final LessonService lessonService;
    private final LessonAccessService lessonAccessService;
    private final LessonQuizQuestionService lessonQuizQuestionService;
    private final MessageSource messageSource;

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    @GetMapping("create/{lessonId}")
    public String createQuizPage(@PathVariable Integer lessonId, Model model) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessLessonQuizCreate(lessonService.getLessonModelById(lessonId))) {
            throw new NoAccessException(messageSource.getMessage("quiz.create.no_access", null, locale));
        }
        if (lessonService.getLessonModelById(lessonId).getLessonQuiz() != null) {
            throw new LessonQuizAlreadyCreatedException(messageSource.getMessage("quiz.create.already_exists", null, locale));
        }
        LessonQuizDto lessonQuizDto = new LessonQuizDto();

        model.addAttribute("lessonQuiz", lessonQuizDto);
        model.addAttribute("lesson", lessonService.getLessonById(lessonId));
        return "quizzes/quiz_create";
    }

    @PostMapping("create")
    public String createQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto,
                             BindingResult bindingResult,
                             RedirectAttributes redirectAttributes,
                             HttpServletRequest request,
                             Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
            return "quizzes/quiz_create";
        }
        request.getSession().removeAttribute("redirectAfterCreate");
        lessonQuizService.createQuiz(lessonQuizDto);
        redirectAttributes.addFlashAttribute("successMessage",
                messageSource.getMessage("quiz.create.success", null, LocaleContextHolder.getLocale()));
        return "redirect:/lessons/" + lessonQuizDto.getLessonId();
    }

    @GetMapping("{id}/edit")
    public String editQuizPage(@PathVariable Integer id, Model model) {
        Locale locale = LocaleContextHolder.getLocale();

        if(!lessonAccessService.canAccessLessonQuizEdit(lessonQuizService.getQuizEntityById(id))){
            throw new NoAccessException(messageSource.getMessage("quiz.edit.no_access", null, locale));
        }

        LessonQuizDto lessonQuizDto = lessonQuizService.getQuizById(id);
        model.addAttribute("lessonQuiz", lessonQuizDto);
        model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
        return "quizzes/quiz_edit";
    }

    @PostMapping("edit")
    public String editQuiz(@Valid @ModelAttribute("lessonQuiz") LessonQuizDto lessonQuizDto,
                           BindingResult bindingResult,
                           RedirectAttributes redirectAttributes,
                           Model model,
                           HttpServletRequest request,
                           HttpSession session){
        Locale locale = LocaleContextHolder.getLocale();

        if (bindingResult.hasErrors()) {
            model.addAttribute("lessonQuiz", lessonQuizDto);
            model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
            return "quizzes/quiz_edit";
        }

        lessonQuizService.editQuiz(lessonQuizDto);
        if(session.getAttribute("timer") != null && session.getAttribute("startTime") != null){
            session.removeAttribute("timer");
            session.removeAttribute("startTime");
        }
        redirectAttributes.addFlashAttribute("successMessage",
                messageSource.getMessage("quiz.edit.success", null, locale));
        return "redirect:/lessons/" + lessonQuizDto.getLessonId();
    }

    @GetMapping("{id}/passing")
    public String getQuizPassingPage(@PathVariable int id,
                                     Model model,
                                     HttpSession session) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessLessonQuizPassing(lessonQuizService.getQuizEntityById(id))) {
            throw new NoAccessException(messageSource.getMessage("quiz.pass.no_access", null, locale));
        }

        if (!lessonQuizService.getQuizById(id).getIsActive()) {
            throw new NoAccessException(messageSource.getMessage("quiz.pass.not_active", null, locale));
        }

        QuizAnswerDto quizAnswerDto = new QuizAnswerDto();
        quizAnswerDto.setPassingStart(LocalTime.now());
        quizAnswerDto.setQuizId(id);
        LessonQuizDto lessonQuizDto = lessonQuizService.getQuizByIdForPassing(id);
        if(session.getAttribute("timer") == null && session.getAttribute("startTime") == null){
            session.setAttribute("timer", lessonQuizDto.getQuestionTimeLimit());
            session.setAttribute("startTime", LocalDateTime.now());
        }
        model.addAttribute("result", quizAnswerDto);
        model.addAttribute("quiz", lessonQuizDto);
        model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
        return "quizzes/quiz_passing";
    }

    @PostMapping("checking")
    public String checkResults(@Valid @ModelAttribute("result") QuizAnswerDto result,
                               BindingResult bindingResult,
                               Model model,
                               HttpSession session) {
        LessonQuizDto lessonQuizDto = lessonQuizService.getQuizById(result.getQuizId());
        lessonQuizDto.setQuestions(lessonQuizQuestionService.getLessonQuizQuestionsByAnswersId(result));
        if(bindingResult.hasErrors()){
            model.addAttribute("result", result);
            model.addAttribute("quiz", lessonQuizDto);
            model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
            return "quizzes/quiz_passing";
        }
        model.addAttribute("results", lessonQuizService.checkQuizResults(result));
        session.removeAttribute("timer");
        session.removeAttribute("startTime");
        return "quizzes/quiz_passed_result_page";
    }

    @GetMapping("{id}/delete")
    public String deleteQuiz(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpServletRequest httpServletRequest, HttpSession session) {
        Locale locale = LocaleContextHolder.getLocale();

        if (!lessonAccessService.canAccessLessonQuizDelete(lessonQuizService.getQuizEntityById(id))) {
            throw new NoAccessException(messageSource.getMessage("quiz.delete.no_access", null, locale));
        }

        String url = httpServletRequest.getHeader("Referer");
        lessonQuizService.deleteQuiz(id);
        if(session.getAttribute("timer") != null && session.getAttribute("startTime") != null){
            session.removeAttribute("timer");
            session.removeAttribute("startTime");
        }
        redirectAttributes.addFlashAttribute("successMessage",
                messageSource.getMessage("quiz.delete.success", null, locale));
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
    public String deactivateQuiz(@PathVariable Integer id,
                                 RedirectAttributes redirectAttributes,
                                 HttpServletRequest httpServletRequest,
                                 HttpSession session) {
        lessonQuizService.deactivateQuiz(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно деактивирован");
        if(session.getAttribute("timer") != null && session.getAttribute("startTime") != null){
            session.removeAttribute("timer");
            session.removeAttribute("startTime");
        }
        return "redirect:" + httpServletRequest.getHeader("Referer");
    }

    @GetMapping("{id}/time-is-over")
    public String timeOut(@PathVariable int id, Model model, HttpSession session){
        LessonQuizDto lessonQuizDto = lessonQuizService.getQuizById(id);
        if(!lessonQuizDto.getIsActive()){
            throw new NoAccessException("У вас нет доступа к этой странице");
        }
        if(session.getAttribute("timer") != null && session.getAttribute("startTime") != null){
            session.removeAttribute("timer");
            session.removeAttribute("startTime");
        }
        model.addAttribute("quiz", lessonQuizDto);
        model.addAttribute("lesson", lessonService.getLessonById(lessonQuizDto.getLessonId()));
        return "quizzes/quiz_time_is_over";
    }
}
