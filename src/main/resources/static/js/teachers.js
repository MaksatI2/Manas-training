document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('#teacher-form');
    const submitButton = form.querySelector('button[type="submit"]');
    const checkboxes = form.querySelectorAll('input[name="teacherIds"]');

    function updateSubmitButton() {
        const isValid = Array.from(checkboxes).some(checkbox => checkbox.checked);
        submitButton.disabled = !isValid;
        submitButton.classList.toggle('btn-primary', isValid);
        submitButton.classList.toggle('btn-secondary', !isValid);
    }

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateSubmitButton);
    });

    updateSubmitButton();

    form.addEventListener('submit', function (event) {
        if (!Array.from(checkboxes).some(checkbox => checkbox.checked)) {
            event.preventDefault();
            alert('Пожалуйста, выберите хотя бы одного преподавателя.');
        }
    });
});