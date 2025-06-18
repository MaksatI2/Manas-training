document.addEventListener('DOMContentLoaded', function () {
    const participantForm = document.getElementById('participant-form');
    const saveButton = document.querySelector('button[type="submit"]');

    participantForm.addEventListener('submit', function (e) {
        const selectedEmployees = document.querySelectorAll('input[name="pendingEmployeeIds"]:checked');
        if (selectedEmployees.length === 0) {
            e.preventDefault();
            alert('Выберите хотя бы одного участника для добавления');
        }
    });

    function updateSaveButton() {
        const selectedEmployees = document.querySelectorAll('input[name="pendingEmployeeIds"]:checked');
        saveButton.disabled = selectedEmployees.length === 0;
        saveButton.classList.toggle('btn-success', selectedEmployees.length > 0);
        saveButton.classList.toggle('btn-secondary', selectedEmployees.length === 0);
    }

    document.querySelectorAll('input[name="pendingEmployeeIds"]').forEach(checkbox => {
        checkbox.addEventListener('change', updateSaveButton);
    });

    updateSaveButton();
});