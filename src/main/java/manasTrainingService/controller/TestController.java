package manasTrainingService.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.course.CourseService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;

@Controller
@RequestMapping("test")
@RequiredArgsConstructor
public class TestController {

    private final TestService testService;
    private final CourseService courseService;
    private final TestInstanceService testInstanceService;
    private final TestResultService testResultService;

    @GetMapping("create/{courseInstanceId}")
    public String createLessonTestPage(@PathVariable int courseInstanceId, Model model) {
        TestDto test = new TestDto();
        test.setCourseInstanceId(courseInstanceId);
        model.addAttribute("test", test);
        return "tests/create";
    }

    @PostMapping("create")
    public String createTest(@Valid @ModelAttribute("test") TestDto test, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "tests/create";
        }
        try {
            testService.createTest(test);
        } catch (IncorrectDateException e) {
            model.addAttribute("error", e.getMessage());
            return "tests/create";
        }
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно создан");
        return "redirect:/courses/"+test.getCourseInstanceId()+"/tests";
    }

    @GetMapping("{id}/edit")
    public String getEditTestPage(@PathVariable int id, Model model, HttpServletRequest request) {
        model.addAttribute("test", testService.getTestById(id));
        String url = request.getHeader("Referer");
        if(url != null){
            request.getSession().setAttribute("redirectAfterEdit", url);
        } else {
            request.getSession().setAttribute("redirectAfterEdit", "/");
        }
        return "tests/edit";
    }

    @PostMapping("edit")
    public String editTest(@Valid @ModelAttribute("test") TestDto test,
                           BindingResult bindingResult,
                           Model model,
                           RedirectAttributes redirectAttributes,
                           HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            return "tests/edit";
        }
        try {
            testService.editTest(test);
        } catch (IncorrectDateException e) {
            model.addAttribute("error", e.getMessage());
            return "tests/edit";
        }
        String redirectUrl = request.getSession().getAttribute("redirectAfterEdit").toString();
        request.getSession().removeAttribute("redirectAfterEdit");
        redirectAttributes.addFlashAttribute("successMessage", "Содержание теста успешно изменено");
        return "redirect:" + redirectUrl;
    }

    @GetMapping("{id}/delete")
    public String deleteTest(@PathVariable int id, RedirectAttributes redirectAttributes) {
        try {
            int courseId = testService.deleteTest(id);
            redirectAttributes.addFlashAttribute("successMessage", "Тест успешно удален");
            return "redirect:/courses/"+courseId+"/tests";
        } catch (IncorrectDateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/courses/"+testService.getTestById(id).getCourseInstanceId()+"/tests";
        }
    }

    @GetMapping("{id}/passing")
    public String getTestById(@PathVariable int id, @RequestParam("instance") int instanceId, Model model, RedirectAttributes redirectAttributes) {
        TestDto testDto = testService.getTestById(id);
        if (!testDto.getIsActive()){
            throw new NoAccessException("Тестирование сейчас не доступно");
        }
        if (testResultService.userHasTestAttempt(testService.getTestById(id).getId())) {
            throw new NoAccessException("Вы уже прошли данный тест");
        }
        if(testInstanceService.isValidAccessTime(instanceId)){
            model.addAttribute("result", new TestAnswerDto());
            model.addAttribute("test", testDto);
            model.addAttribute("passing_start", LocalDateTime.now());
            model.addAttribute("courseTitle", courseService.getCourseById(testDto.getId()).getTitle());
            return "tests/test_passing";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Прохождение тестирования доступно только в специально отведенное время");
            return "redirect:/student/course/" + instanceId;
        }
    }

    @GetMapping("{id}/activate")
    public String activateTest(@PathVariable int id, RedirectAttributes redirectAttributes){
        int courseId = testService.activateTest(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно активирован!");
        return "redirect:/courses/"+courseId+"/tests";
    }

    @GetMapping("{id}/deactivate")
    public String deactivateTest(@PathVariable int id, RedirectAttributes redirectAttributes){
        try {
            int courseId = testService.deactivateTest(id);
            redirectAttributes.addFlashAttribute("successMessage", "Тест успешно деактивирован!");
            return "redirect:/courses/"+courseId+"/tests";
        } catch (IncorrectDateException e){
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/courses/"+testService.getTestById(id).getCourseInstanceId()+"/tests";
        }
    }

    @PostMapping("checking")
    public String checkTestResults(@Valid @ModelAttribute("result") TestAnswerDto result, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("test", testService.getTestById(result.getTestId()));
            return "tests/test_passing";
        }
        model.addAttribute("results", testService.checkTestResult(result));
        model.addAttribute("test", testService.getTestById(result.getTestId()));
        return "tests/test_passed_page";
    }

    @GetMapping("{id}/details")
    public String testDetailsPage(@PathVariable int id, Model model) {
        model.addAttribute("test", testService.getTestById(id));
        return "tests/test-details";
    }
}
