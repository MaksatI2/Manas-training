package manasTrainingService.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import manasTrainingService.dto.edit.OrganizationProfileEditDto;
import manasTrainingService.exceptions.nsee.user.PhoneAlreadyExistsException;
import manasTrainingService.service.user.OrganizationService;
import manasTrainingService.service.user.UserService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Locale;

@Controller
@RequestMapping("organization")
@RequiredArgsConstructor
public class OrganizationController {

    private final OrganizationService organizationService;
    private final UserService userService;
    private final MessageSource messageSource;

    @GetMapping("profile")
    public String organizationProfilePage(Model model) {
        model.addAttribute("organization", organizationService.getAuthorizedUserOrganization(userService.getAuthorizedUser()));
        return "organization/profile-view";
    }

    @GetMapping("profile/edit")
    public String organizationProfileEditPage(Model model) {
        model.addAttribute("organizationProfile", organizationService.getOrganizationUserInformationForEdit(userService.getAuthorizedUser()));
        return "organization/profile-edit";
    }

    @PostMapping("profile/edit")
    public String organizationProfileEdit(@Valid @ModelAttribute("organizationProfile") OrganizationProfileEditDto organizationProfileEditDto, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {
        Locale locale = LocaleContextHolder.getLocale();

        if (bindingResult.hasErrors()) {
            return "organization/profile-edit";
        }
        try {
            organizationService.editOrganizationInformation(organizationProfileEditDto);
            redirectAttributes.addFlashAttribute("successMessage",
                    messageSource.getMessage("organization.profile.edit.success", null, locale));
            return "redirect:/organization/profile";
        } catch (PhoneAlreadyExistsException e) {
            model.addAttribute("errorMessage",
                    messageSource.getMessage("organization.profile.edit.phone_exists", null, locale));
            model.addAttribute("organizationProfile", organizationProfileEditDto);
            return "organization/profile-edit";
        }
    }
}
