document.addEventListener('DOMContentLoaded', function () {
    const addModuleBtn = document.getElementById('add-module-btn');
    const newModulesContainer = document.getElementById('new-modules-container');
    const moduleForm = document.getElementById('module-form');
    const saveButton = document.querySelector('button[type="submit"]');
    const MAX_TOTAL_HOURS = parseInt(newModulesContainer.dataset.remainingHours || 0);
    const hoursInfo = document.getElementById('remaining-hours-text');
    let moduleCount = 0;

    const existingModules = document.querySelectorAll('#existing-modules tr');
    let maxOrderIndex = Array.from(existingModules).reduce((max, row) => {
        const orderIndex = parseInt(row.dataset.orderIndex || 0);
        return Math.max(max, orderIndex);
    }, 0);

    function calculateTotalHours() {
        const inputs = newModulesContainer.querySelectorAll('input[name$=".durationHours"]');
        return Array.from(inputs).reduce((sum, input) => sum + (parseInt(input.value) || 0), 0);
    }

    function updateHoursStatus() {
        const total = calculateTotalHours();
        const remaining = MAX_TOTAL_HOURS - total;

        if (hoursInfo) {
            hoursInfo.textContent = remaining >= 0 ? remaining : 0;
        }

        if (remaining <= 0) {
            addModuleBtn.disabled = true;
            addModuleBtn.classList.add('btn-secondary');
            addModuleBtn.classList.remove('btn-primary-custom');

            saveButton.disabled = total > MAX_TOTAL_HOURS;
            saveButton.classList.toggle('btn-danger', total > MAX_TOTAL_HOURS);
            saveButton.classList.toggle('btn-primary-custom', total <= MAX_TOTAL_HOURS);
        } else {
            addModuleBtn.disabled = false;
            addModuleBtn.classList.add('btn-primary-custom');
            addModuleBtn.classList.remove('btn-secondary');

            saveButton.disabled = false;
            saveButton.classList.remove('btn-danger');
            saveButton.classList.add('btn-primary-custom');
        }
        const limitInfo = document.getElementById('limit-reached-info');
        if (limitInfo) {
            limitInfo.style.display = remaining <= 0 ? 'block' : 'none';
        }
    }

    function addNewModuleForm() {
        maxOrderIndex++;

        const moduleDiv = document.createElement('div');
        moduleDiv.className = 'new-module-section mb-3 p-3 border rounded';
        moduleDiv.innerHTML = `
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label">Название</label>
                    <input type="text" class="form-control" name="modules[${moduleCount}].title"  maxlength="200">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Часы</label>
                    <input type="number" class="form-control" name="modules[${moduleCount}].durationHours"  min="1">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Описание</label>
                    <textarea class="form-control" name="modules[${moduleCount}].description"></textarea>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Порядок</label>
                    <input type="number" class="form-control" name="modules[${moduleCount}].orderIndex" value="${maxOrderIndex}" readonly  min="0">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Активен</label>
                    <select class="form-select" name="modules[${moduleCount}].isActive">
                        <option value="true" selected>Да</option>
                        <option value="false">Нет</option>
                    </select>
                </div>
            </div>
            <button type="button" class="btn btn-danger btn-sm mt-2 remove-module-btn">Удалить</button>
        `;

        newModulesContainer.appendChild(moduleDiv);

        moduleDiv.querySelector('.remove-module-btn').addEventListener('click', function () {
            removeSection(this, 'new-module-section');
        });

        moduleDiv.querySelector('input[name$=".durationHours"]').addEventListener('input', updateHoursStatus);

        moduleCount++;
        updateHoursStatus();
    }

    addModuleBtn.addEventListener('click', addNewModuleForm);

    moduleForm.addEventListener('submit', function (e) {
        const newModules = document.querySelectorAll('.new-module-section');
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

    document.querySelectorAll('.edit-module-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const moduleId = this.dataset.moduleId;
            const row = document.querySelector(`tr[data-module-id="${moduleId}"]`);
            const cells = row.querySelectorAll('td');

            document.getElementById('edit-module-id').value = moduleId;
            document.getElementById('edit-module-title').value = cells[1].textContent;
            document.getElementById('edit-module-duration').value = cells[2].textContent;
            document.getElementById('edit-module-description').value = cells[3].textContent;
            document.getElementById('edit-module-order').value = cells[0].textContent;
            document.getElementById('edit-module-active').value = cells[4].textContent === 'Активен' ? 'true' : 'false';
        });
    });

    document.getElementById('save-module-changes').addEventListener('click', function () {
        const moduleId = document.getElementById('edit-module-id').value;
        const updatedModule = {
            id: moduleId,
            title: document.getElementById('edit-module-title').value,
            durationHours: parseInt(document.getElementById('edit-module-duration').value),
            description: document.getElementById('edit-module-description').value,
            orderIndex: parseInt(document.getElementById('edit-module-order').value),
            isActive: document.getElementById('edit-module-active').value === 'true'
        };

        fetch(`/admin/course-instances/${courseInstance.id}/modules/${moduleId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedModule)
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Ошибка при обновлении модуля');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Произошла ошибка при обновлении модуля');
            });
    });

    document.querySelectorAll('.delete-module-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            if (confirm('Вы уверены, что хотите удалить этот модуль?')) {
                const moduleId = this.dataset.moduleId;

                fetch(`/admin/course-instances/${courseInstance.id}/modules/${moduleId}`, {
                    method: 'DELETE'
                })
                    .then(response => {
                        if (response.ok) {
                            window.location.reload();
                        } else {
                            alert('Ошибка при удалении модуля');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Произошла ошибка при удалении модуля');
                    });
            }
        });
    });

    function renumberModules() {
        const modules = document.querySelectorAll('.new-module-section');
        modules.forEach((module, index) => {
            const inputs = module.querySelectorAll('input, textarea, select');
            inputs.forEach(input => {
                if (input.name) {
                    input.name = input.name.replace(/modules\[\d+]/, `modules[${index}]`);
                }
            });
        });
        moduleCount = modules.length;
    }

    function removeSection(button, sectionClass) {
        const section = button.closest(`.${sectionClass}`);
        section.remove();
        maxOrderIndex--;

        if (sectionClass === 'new-module-section') {
            renumberModules();
            updateHoursStatus();
        }
    }

});
