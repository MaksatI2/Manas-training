(function () {
    const getMsg = k => (window.APP_MESSAGES && window.APP_MESSAGES[k]) || "";

    const errorMessage = window.errorMessage || function (field, text, labelId) {
        const error = document.createElement("label");
        error.setAttribute("for", field);
        error.setAttribute("class", "text-danger error-message");
        if (labelId) error.setAttribute("id", labelId);
        error.innerText = text;
        return error;
    };
    const isInvalid = window.isInvalid || function (id) {
        const input = document.getElementById(id);
        if (input) input.classList.add("is-invalid");
        return input;
    };

    const form = document.getElementById('test-instance-create') || document.getElementById('instance-test-form') || document.querySelector('form');

    if (form) {
        form.addEventListener("submit", event => {
            let hasError = false;

            document.querySelectorAll(".error-message").forEach(er => er.remove());
            document.querySelectorAll(".is-invalid").forEach(i => i.classList.remove("is-invalid"));

            const formData = new FormData(event.target);
            const data = Object.fromEntries(formData.entries());

            if (!data.testId) {
                hasError = true;
                isInvalid("testId")?.insertAdjacentElement('afterend', errorMessage("testId", getMsg('test_instance_form.test.required')));
            }
            if (!data.startDate) {
                hasError = true;
                isInvalid("startDate")?.insertAdjacentElement('afterend', errorMessage("startDate", getMsg('test_instance_form.startDate.required')));
            }
            if (!data.endDate) {
                hasError = true;
                isInvalid("endDate")?.insertAdjacentElement('afterend', errorMessage("endDate", getMsg('test_instance_form.endDate.required')));
            }
            if (!data.startTime) {
                hasError = true;
                isInvalid("startTime")?.insertAdjacentElement('afterend', errorMessage("startTime", getMsg('test_instance_form.startTime.required')));
            }
            if (!data.endTime) {
                hasError = true;
                isInvalid("endTime")?.insertAdjacentElement('afterend', errorMessage("endTime", getMsg('test_instance_form.endTime.required')));
            }

            if (hasError) event.preventDefault();
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".input-date").forEach(input => {
            input.setAttribute("type", "date");
            const today = new Date().toISOString().split("T")[0];
            input.setAttribute("min", today);
        });
        document.querySelectorAll(".input-time").forEach(input => {
            input.setAttribute("type", "time");
        });
    });
})();
