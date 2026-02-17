(function () {
    const M = window.APP_MESSAGES || {};

    pointsInput.forEach(input => {
        input.addEventListener('input', () => {
            input.value = input.value.replace(/[^0-9]/g, '');
            if (parseInt(input.value) > 100) {
                input.value = '100';
            }
        });
    });

    if (!form) return;

    form.addEventListener("submit", event => {
        let hasError = false;

        document.querySelectorAll(".error-message").forEach(er => er.remove());
        document.querySelectorAll(".is-invalid").forEach(i => i.classList.remove("is-invalid"));

        const formData = new FormData(form);
        const data = Object.fromEntries(formData.entries());

        if (!data.title) {
            hasError = true;
            isInvalid("title").insertAdjacentElement('afterend', errorMessage("title", M['test_form_validation.title.required']));
        }
        if (!data.passingScore) {
            hasError = true;
            isInvalid("passingScore").insertAdjacentElement('afterend', errorMessage("passingScore", M['test_form_validation.passingScore.required']));
        }

        const questionBlocks = document.querySelectorAll('[id^="questionId-"]');
        questionBlocks.forEach((block, index) => {
            const questionInput = document.getElementById(`questions[${index}].question`);
            if (questionInput && !questionInput.readOnly && !questionInput.value.trim()) {
                hasError = true;
                questionInput.classList.add("is-invalid");
                questionInput.parentNode.insertBefore(
                    errorMessage(`questions[${index}].question`, M['test_form_validation.question.required'], `invalid-questionId-${index}`),
                    questionInput.nextSibling
                );
            }

            const optionsContainer = document.getElementById(`options-questionId-${index}`);
            if (optionsContainer) {
                const optionInputs = optionsContainer.querySelectorAll('[id$=".optionText"]');
                optionInputs.forEach((input, optionIndex) => {
                    if (!input.readOnly && !input.value.trim()) {
                        hasError = true;
                        input.classList.add("is-invalid");
                        const optionDiv = document.getElementById(`questionId-${index}-optionId-${optionIndex}`);
                        if (optionDiv) {
                            optionDiv.parentNode.insertBefore(
                                errorMessage(
                                    `questions[${index}].options[${optionIndex}].optionText`,
                                    M['test_form_validation.option.required'],
                                    `invalid-questionId-${index}-optionId-${optionIndex}`
                                ),
                                optionDiv.nextSibling
                            );
                        }
                    }
                });
            }
        });

        if (hasError) {
            event.preventDefault();
        }
    });
})();
