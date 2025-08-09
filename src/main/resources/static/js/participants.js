document.addEventListener('DOMContentLoaded', function () {
    const saveButton = document.querySelector('button[type="submit"]');

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