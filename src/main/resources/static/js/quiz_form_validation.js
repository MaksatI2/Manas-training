form.addEventListener("submit", event => {
    let hasError = false;
    if (document.querySelectorAll(".error-message")){
        let errors = document.querySelectorAll(".error-message")
        errors.forEach(er => {
            er.remove()
        })
    }
    if (document.querySelectorAll(".is-invalid")){
        let inputs = document.querySelectorAll(".is-invalid")
        inputs.forEach(i => {
            i.classList.remove("is-invalid")
        })
    }
    let form = event.target
    let formData = new FormData(form);
    let data = Object.fromEntries(formData.entries())
    console.log(data)
    const testQuestions = new Map();
    for (let [key, value] of formData.entries()) {
        const qMatch = key.match(/^questions\[(\d+)]\.question$/);
        const oMatch = key.match(/^questions\[(\d+)]\.options\[(\d+)]\.optionText$/);

        if (qMatch) {
            const qIndex = parseInt(qMatch[1]);
            if (!testQuestions.has(qIndex)) testQuestions.set(qIndex, { question: "", options: [] });
            testQuestions.get(qIndex).question = value.trim();
        }

        if (oMatch) {
            const qIndex = parseInt(oMatch[1]);
            const oIndex = parseInt(oMatch[2]);
            if (!testQuestions.has(qIndex)) testQuestions.set(qIndex, { question: "", options: [] });
            testQuestions.get(qIndex).options[oIndex] = value.trim();
        }
    }

    if(!data.title){
        hasError = true;
        isInvalid("title").insertAdjacentElement('afterend', errorMessage("title", "Заполните название теста"));
    }
    if(!data.description){
        hasError  =true;
        isInvalid("description").insertAdjacentElement('afterend', errorMessage("description", "Заполните описание теста"));
    }
    if(!data.questionTimeLimit){
        hasError = true;
        isInvalid("questionTimeLimit").insertAdjacentElement('afterend', errorMessage("questionTimeLimit", "Заполните время прохождени теста"));
    }
    const questionBlocks = document.querySelectorAll('[id^="questionId-"]');
    questionBlocks.forEach((block, index) => {
        const questionInput = document.getElementById(`questions[${index}].question`);
        if (questionInput && !questionInput.readOnly && !questionInput.value.trim()) {
            hasError = true;
            questionInput.classList.add("is-invalid");
            questionInput.parentNode.insertBefore(
                errorMessage(`questions[${index}].question`, "Заполните текст вопроса", `invalid-questionId-${index}`),
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
                                "Заполните вариант ответа",
                                `invalid-questionId-${index}-optionId-${optionIndex}`
                            ),
                            optionDiv.nextSibling
                        );
                    }
                }
            });
        }
    });
    if(hasError){
        event.preventDefault();
    }
})

timeInput.addEventListener('input', () => {
    timeInput.value = timeInput.value.replace(/[^0-9]/g, '');
    if (parseInt(timeInput.value) > 60) {
        timeInput.value = '60';
    }
});