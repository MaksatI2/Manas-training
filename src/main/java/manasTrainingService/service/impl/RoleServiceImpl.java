package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.Role;
import manasTrainingService.exceptions.nsee.user.RoleNotFoundException;
import manasTrainingService.repositories.user.RoleRepository;
import manasTrainingService.service.user.RoleService;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;
    private final MessageSource messageSource;

    @Override
    public Role getCompanyTypeId(){
        return roleRepository.findByName("ORGANIZATION")
                .orElseThrow(() -> new RoleNotFoundException(getMessage("role.organization.not.found")));
    }

    @Override
    public Role getStudentRoleId(){
        return roleRepository.findByName("STUDENT")
                .orElseThrow(() -> new RoleNotFoundException(getMessage("role.student.not.found")));
    }

    @Override
    public Role getTeacherRoleId(){
        return roleRepository.findByName("TEACHER")
                .orElseThrow(() -> new RoleNotFoundException(getMessage("role.teacher.not.found")));
    }

    public List<String> getAllRoles() {
        return roleRepository.findAll()
                .stream()
                .map(Role::getName)
                .distinct()
                .sorted()
                .collect(Collectors.toList());
    }

    private String getMessage(String code) {
        return messageSource.getMessage(code, null, LocaleContextHolder.getLocale());
    }
}