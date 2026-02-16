package manasTrainingService.dto.instance;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
public class ParticipantFormDTO {
    @NotEmpty(message = "{participantForm.pendingEmployeeIds.notEmpty}")
    private List<Integer> pendingEmployeeIds = new ArrayList<>();
}