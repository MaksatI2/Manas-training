package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.answers.TestAnswerDto;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.service.course.CourseService;
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
        return "redirect:/teacher/my-courses";
    }

    @GetMapping("{id}/edit")
    public String getEditTestPage(@PathVariable int id, Model model) {
        model.addAttribute("test", testService.getTestById(id));
        return "tests/edit";
    }

    @PostMapping("edit")
    public String editTest(@Valid @ModelAttribute("test") TestDto test, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "tests/edit";
        }
        try {
            testService.editTest(test);
        } catch (IncorrectDateException e) {
            model.addAttribute("error", e.getMessage());
            return "tests/edit";
        }
        redirectAttributes.addFlashAttribute("successMessage", "Содержание теста успешно изменено");
        return "redirect:/teacher/my-courses";
    }

    @GetMapping("{id}/delete")
    public String deleteTest(@PathVariable int id, RedirectAttributes redirectAttributes) {
        testService.deleteTest(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно удален");
        return "redirect:/teacher/my-courses";
    }

    @GetMapping("{id}/passing")
    public String getTestById(@PathVariable int id, Model model) {
        TestDto testDto = testService.getTestById(id);
        model.addAttribute("result", new TestAnswerDto());
        model.addAttribute("test", testDto);
        model.addAttribute("passing_start", LocalDateTime.now());
        model.addAttribute("courseTitle", courseService.getCourseById(testDto.getId()).getTitle());
        return "tests/test_passing";
    }

    @PostMapping("checking")
    public String checkTestResults(@Valid @ModelAttribute("result") TestAnswerDto result, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("test", testService.getTestById(result.getTestId()));
            return "tests/test_passing";
        }
        model.addAttribute("results", testService.checkTestResult(result));
        return "tests/test_passed_page";
    }
}
