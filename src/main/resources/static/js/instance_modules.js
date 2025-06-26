document.addEventListener('DOMContentLoaded', () => {
    const addModuleBtn = document.getElementById('add-module-btn');
    const newModulesContainer = document.getElementById('new-modules-container');
    const moduleForm = document.getElementById('module-form');
    const saveButton = moduleForm.querySelector('button[type="submit"]');
    const MAX_TOTAL_HOURS = parseInt(newModulesContainer?.dataset.remainingHours || '0', 10);
    const hoursInfo = document.getElementById('remaining-hours-text');
    const limitInfo = document.getElementById('limit-reached-info');

    let moduleCount = 0;

    const calculateTotalHours = () => {
        const inputs = newModulesContainer.querySelectorAll('input[name$=".durationHours"]');
        return Array.from(inputs).reduce((sum, input) => {
            const value = parseInt(input.value || '0', 10);
            return sum + (isNaN(value) ? 0 : value);
        }, 0);
    };

    const updateButtonState = (button, isDisabled, activeClass, inactiveClass) => {
        button.disabled = isDisabled;
        button.classList.toggle(activeClass, !isDisabled);
        button.classList.toggle(inactiveClass, isDisabled);
    };

    const updateHoursStatus = () => {
        const total = calculateTotalHours();
        const remaining = MAX_TOTAL_HOURS - total;

        if (hoursInfo) {
            hoursInfo.textContent = Math.max(0, remaining);
        }

        updateButtonState(addModuleBtn, remaining < 0, 'btn-primary-custom', 'btn-secondary');

        const overLimit = total > MAX_TOTAL_HOURS;
        updateButtonState(saveButton, overLimit, 'btn-primary-custom', 'btn-danger');

        if (limitInfo) {
            limitInfo.style.display = remaining < 0 ? 'block' : 'none';
        }
    };

    newModulesContainer.addEventListener('click', (event) => {
        if (event.target.classList.contains('remove-module-btn')) {
            const section = event.target.closest('.new-module-section');
            if (section) {
                removeSection(section, 'new-module-section');
            }
        }
    });

    const addNewModuleForm = () => {
        const moduleDiv = document.createElement('div');
        moduleDiv.className = 'new-module-section mb-3 p-3 border rounded';

        moduleDiv.innerHTML = `
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label">Название</label>
                    <input type="text" class="form-control" name="modules[${moduleCount}].title" maxlength="200">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Часы</label>
                    <input type="number" class="form-control" name="modules[${moduleCount}].durationHours" min="1">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Описание</label>
                    <textarea class="form-control" name="modules[${moduleCount}].description"></textarea>
                </div>
            </div>
            <button type="button" class="btn btn-danger btn-sm mt-2 remove-module-btn">Удалить</button>
        `;

        newModulesContainer.appendChild(moduleDiv);


        moduleDiv.querySelector('input[name$=".durationHours"]')
            .addEventListener('input', updateHoursStatus);

        moduleCount++;
        updateHoursStatus();
    };

    const removeSection = (sectionElement, sectionClass) => {
        sectionElement.remove();

        if (sectionElement.classList.contains(sectionClass)) {
            renumberModules();
            updateHoursStatus();
        }
    };

    const renumberModules = () => {
        const modules = document.querySelectorAll('.new-module-section');
        modules.forEach((module, index) => {
            module.querySelectorAll('input, textarea').forEach(input => {
                input.name = input.name.replace(/modules\[\d+]/, `modules[${index}]`);
            });
        });
        moduleCount = modules.length;
    };


    const handleFormSubmit = () => {
        moduleForm.addEventListener('submit', e => {
            const newModules = newModulesContainer.querySelectorAll('.new-module-section');
            const total = calculateTotalHours();

            if (newModules.length === 0) {
                e.preventDefault();
                alert('Должен быть добавлен хотя бы один модуль');
                return;
            }

            if (total > MAX_TOTAL_HOURS) {
                e.preventDefault();
                alert(`Общее количество часов (${total}) превышает допустимый лимит: ${MAX_TOTAL_HOURS}`);
            }
        });
    };

    addModuleBtn?.addEventListener('click', addNewModuleForm);
    handleFormSubmit();
    updateHoursStatus();


    const moduleTable = document.getElementById('existing-modules');

    moduleTable?.addEventListener('click', (event) => {

        const deleteBtn = event.target.closest('.delete-module-btn');
        if (!deleteBtn) return;

        const moduleId = deleteBtn.dataset.moduleId;
        const lessonsCount = parseInt(deleteBtn.dataset.lessonsCount || '0', 10);

        const confirmBtn = document.getElementById('confirmDeleteModuleBtn');
        const modalBody = document.getElementById('deleteModuleModalBody');

        if (lessonsCount > 0) {
            modalBody.innerHTML = `
            <p>Этот модуль содержит <strong>${lessonsCount}</strong> уроков и не может быть удалён.</p>
        `;
            confirmBtn.disabled = true;
            confirmBtn.textContent = 'Удаление невозможно';
        } else {
            modalBody.innerHTML = `<p>Вы уверены, что хотите удалить модуль?</p>`;
            confirmBtn.disabled = false;
            confirmBtn.textContent = 'Удалить модуль';

            const csrfToken = $('meta[name="_csrf"]').attr('content');
            const form = document.getElementById('deleteModuleForm');
            form.action = `/admin/course-instances/${courseInstanceId}/modules/${moduleId}/delete`;
            form.querySelector('input[name="_csrf"]').value = csrfToken;

            $('#deleteFormContainer').html(form);
            confirmBtn.onclick = () => {
                const form = document.getElementById('deleteCourseInstanceForm');
                if (form) {
                    form.submit();
                }
            };


        }

        const modal = new bootstrap.Modal(document.getElementById('deleteModuleModal'));
        modal.show();
    });

});
