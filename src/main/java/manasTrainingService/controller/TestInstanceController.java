package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.tests.TestDto;
import manasTrainingService.dto.tests.TestInstanceDto;
import manasTrainingService.entity.CourseInstance;
import manasTrainingService.exceptions.nsee.IncorrectDateException;
import manasTrainingService.exceptions.nsee.NoAccessException;
import manasTrainingService.service.course.CourseInstanceService;
import manasTrainingService.service.test.TestInstanceService;
import manasTrainingService.service.test.TestResultService;
import manasTrainingService.service.test.TestService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("instance")
@RequiredArgsConstructor
public class TestInstanceController {

    private final TestService testService;
    private final CourseInstanceService courseInstanceService;
    private final TestInstanceService testInstanceService;
    private final TestResultService testResultService;

    @GetMapping("{id}/test")
    public String addTestToInstancePage(@PathVariable Integer id, Model model) {
        if(testInstanceService.isTestInstanceExist(id)){
            throw new NoAccessException("Тест уже привязан к данному потоку");
        }
        CourseInstance ci = courseInstanceService.getCourseInstanceModelById(id);
        List<TestDto> activeTests = testService.getAllTestsByCourseId(ci.getCourse().getId()).stream().filter( t -> t.getIsActive()).toList();
        model.addAttribute("tests", activeTests);
        model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(id));
        model.addAttribute("testInstanceDto", new TestInstanceDto());
        model.addAttribute("courseInstanceId", id);
        return "tests/add-test-to-course-instance";
    }

    @PostMapping("add/test")
    public String addTestToInstance(@Valid @ModelAttribute TestInstanceDto testInstanceDto, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        Integer courseInstanceId = testInstanceDto.getCourseInstanceId();
        if(bindingResult.hasErrors()) {
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(courseInstanceId));
            model.addAttribute("tests", testService.getAllTestsByCourseId(courseInstanceId).stream().filter(TestDto::getIsActive).toList());
            model.addAttribute("courseInstanceId", courseInstanceId);
            return "tests/add-test-to-course-instance";
        }
        try{
            testInstanceService.addTestToCourseInstance(testInstanceDto);
            redirectAttributes.addFlashAttribute("successMessage", "Тест привязан к потоку");
            return "redirect:/teacher/course/"+testInstanceDto.getCourseInstanceId();
        }catch (IncorrectDateException e){
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(courseInstanceId));
            model.addAttribute("tests", testService.getAllTestsByCourseId(courseInstanceId).stream().filter(TestDto::getIsActive).toList());
            model.addAttribute("courseInstanceId", courseInstanceId);
            model.addAttribute("error", e.getMessage());
            return "tests/add-test-to-course-instance";
        }
    }

    @GetMapping("{id}/change/test")
    public String changeInstanceTestPage(@PathVariable Integer id, Model model){
        if(testResultService.hasResultsByTestInstanceId(testInstanceService.getTestInstanceByCourseInstanceId(id).getId())){
            throw new NoAccessException("По данному тесту уже есть результаты");
        }
        List<TestDto> activeTests = testService.getAllTestsByCourseId(id).stream().filter( t -> t.getIsActive()).toList();
        model.addAttribute("tests", activeTests);
        model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(id));
        model.addAttribute("testInstanceDto", testInstanceService.getTestInstanceByCourseInstanceId(id));
        model.addAttribute("courseInstanceId", id);
        return "tests/change-test-to-course-instance";
    }

    @PostMapping("change/test")
    public String changeTestToInstance(@Valid @ModelAttribute TestInstanceDto testInstanceDto, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes){
        Integer courseInstanceId = testInstanceDto.getCourseInstanceId();
        if(bindingResult.hasErrors()) {
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(courseInstanceId));
            model.addAttribute("tests", testService.getAllTestsByCourseId(courseInstanceId).stream().filter(TestDto::getIsActive).toList());
            model.addAttribute("courseInstanceId", courseInstanceId);
            return "tests/change-test-to-course-instance";
        }
        try{
            testInstanceService.changeTestToCourseInstance(testInstanceDto);
            redirectAttributes.addFlashAttribute("successMessage", "Тест успешно переназначен");
            return "redirect:/teacher/course/"+testInstanceDto.getCourseInstanceId();
        } catch (IncorrectDateException e){
            model.addAttribute("courseInstance", courseInstanceService.getCourseInstanceById(courseInstanceId));
            model.addAttribute("tests", testService.getAllTestsByCourseId(courseInstanceId).stream().filter(TestDto::getIsActive).toList());
            model.addAttribute("courseInstanceId", courseInstanceId);
            model.addAttribute("error", e.getMessage());
            return "tests/change-test-to-course-instance";
        }
    }

    @GetMapping("{id}/delete/test")
    public String deleteTestFromTestInstance(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        if(testResultService.hasResultsByTestInstanceId(testInstanceService.getTestInstanceByCourseInstanceId(id).getId())){
            throw new NoAccessException("По данному тесту уже есть результаты");
        }
        testInstanceService.deleteTestFromTestInstance(id);
        redirectAttributes.addFlashAttribute("successMessage", "Тест успешно отвязан от данного потока");
        return "redirect:/teacher/course/"+id;
    }
}
