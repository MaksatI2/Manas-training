package manasTrainingService.service.impl;

import lombok.RequiredArgsConstructor;
import manasTrainingService.entity.Role;
import manasTrainingService.exceptions.nsee.RoleNotFoundException;
import manasTrainingService.repositories.RoleRepository;
import manasTrainingService.service.RoleService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;

    @Override
    public Role getCompanyTypeId(){
        return roleRepository.findByName("ORGANIZATION")
                .orElseThrow(()-> new RoleNotFoundException("Тип роли не найдена"));
    }

    @Override
    public Role getStudentRoleId(){
        return roleRepository.findByName("STUDENT")
                .orElseThrow(()-> new RoleNotFoundException("Тип роли не найдена"));
    }

}