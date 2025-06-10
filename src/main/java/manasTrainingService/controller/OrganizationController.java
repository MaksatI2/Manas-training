package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.OrganizationProfileEditDto;
import manasTrainingService.entity.Organization;
import manasTrainingService.service.OrganizationService;
import manasTrainingService.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("organization")
@RequiredArgsConstructor
public class OrganizationController {

    private final OrganizationService organizationService;
    private final UserService userService;

    @GetMapping("profile")
    public String organizationProfilePage(Model model) {
        model.addAttribute("organization", organizationService.getAuthorizedUserOrganization(userService.getAuthorizedUser()));
        return "organization/view";
    }

    @GetMapping("profile/edit")
    public String organizationProfileEditPage(Model model) {
        model.addAttribute("organizationProfile", organizationService.getOrganizationUserInformationForEdit(userService.getAuthorizedUser()));
        return "organization/edit";
    }

    @PostMapping("profile/edit")
    public String organizationProfileEdit(@Valid OrganizationProfileEditDto organizationProfileEditDto, BindingResult bindingResult, Model model) {
        if (!bindingResult.hasErrors()) {
            organizationService.editOrganizationInformation(organizationProfileEditDto);
            return "redirect:/organization/profile";
        }
        model.addAttribute("organizationProfile", organizationProfileEditDto);
        return "organization/edit";
    }
}
