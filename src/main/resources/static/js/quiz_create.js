let createQuestionButtonContainer = document.getElementById("createQuestionContainer");

function createQuestionBlock(count, lessonQuizId) {
    let all = document.querySelectorAll('[id^="questionId-"]');
    let questions = Array.from(all).filter(el => /^questionId-\d+$/.test(el.id));
    let index = questions.length;
    for (let i = 0; i < count; i++) {
        let questionIndex = index + i;
        let question = `
                <div class="col-lg-8 col-md-10" id="questionId-${questionIndex}" data-new="true">
                    <div class="feature-card">
                        <div class="text-end">
                             <button type="button" class="btn btn-outline-danger fs-5"
                                     onclick="deleteQuestion('questionId-${questionIndex}')">
                                  <i class="fa-solid fa-trash"></i>
                             </button>
                        </div>
                        <div class="mb-3">
                            <label for="questions[${questionIndex}].question" class="form-label fw-bold">
                                ${window.APP_MESSAGES['js.lesson-materials.label.enterQuestion']} <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   name="questions[${questionIndex}].question"
                                   id="questions[${questionIndex}].question"
                                   class="form-control me-2">
                        </div>
                        <div class="mt-3 border rounded-4 px-4 py-3 mb-3" id="options-questionId-${questionIndex}">
                            <div id="questionId-${questionIndex}-optionId-0" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[${questionIndex}].correctOptionIndex"
                                           value="0"
                                           id="questions[${questionIndex}].options[0]"
                                           class="form-check-input fs-4"
                                           checked/>
                                </div>
                                <div class="flex-grow-1 me-0">
                                    <input type="text"
                                           name="questions[${questionIndex}].options[0].optionText"
                                           id="questions[${questionIndex}].options[0].optionText"
                                           placeholder="${window.APP_MESSAGES['js.lesson-materials.placeholder.answerOption']}"
                                           aria-describedby="button-addon2"
                                           class="form-control me-3">
                                </div>
                            </div>
                            <div id="questionId-${questionIndex}-optionId-1" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[${questionIndex}].correctOptionIndex"
                                           value="1"
                                           id="questions[${questionIndex}].options[1]"
                                           class="form-check-input fs-4">
                                </div>
                                <div class="flex-grow-1 me-0">
                                    <input type="text"
                                           name="questions[${questionIndex}].options[1].optionText"
                                           id="questions[${questionIndex}].options[1].optionText"
                                           placeholder="${window.APP_MESSAGES['js.lesson-materials.placeholder.answerOption']}"
                                           aria-describedby="button-addon2"
                                           class="form-control me-3">
                                </div>
                            </div>
                            <div id="questionId-${questionIndex}-optionId-2" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[${questionIndex}].correctOptionIndex"
                                           value="2"
                                           id="questions[${questionIndex}].options[2]"
                                           class="form-check-input fs-4">
                                </div>
                                <div class="d-flex flex-grow-1 align-items-center">
                                    <input type="text"
                                           name="questions[${questionIndex}].options[2].optionText"
                                           id="questions[${questionIndex}].options[2].optionText"
                                           placeholder="${window.APP_MESSAGES['js.lesson-materials.placeholder.answerOption']}"
                                           aria-describedby="button-addon2"
                                           class="form-control me-3">
                                    <button class="btn btn-outline-danger"
                                            type="button"
                                            id="button-addon2"
                                            onclick="deleteOption('questionId-${questionIndex}-optionId-2', 'option-2-error', ${questionIndex})">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div id="questionId-${questionIndex}-optionId-3" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[${questionIndex}].correctOptionIndex"
                                           value="3"
                                           id="questions[${questionIndex}].options[3]"
                                           class="form-check-input fs-4">
                                </div>
                                <div class="d-flex flex-grow-1 align-items-center">
                                    <input type="text"
                                           name="questions[${questionIndex}].options[3].optionText" 
                                           id="questions[${questionIndex}].options[3].optionText"
                                           placeholder="${window.APP_MESSAGES['js.lesson-materials.placeholder.answerOption']}"
                                           aria-describedby="button-addon2"
                                           class="form-control me-3">
                                    <button class="btn btn-outline-danger"
                                            type="button"
                                            id="button-addon2"
                                            onclick="deleteOption('questionId-${questionIndex}-optionId-3', 'option-3-error', ${questionIndex})">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3" id="createOption">
                            <button type="button" class="btn btn-primary-custom" onclick="createOption(${questionIndex})" id="add-options-button-question-${questionIndex}" disabled>
                                ${window.APP_MESSAGES['js.lesson-materials.button.addOption']}
                            </button>
                        </div>
                    </div>
                </div>
        `;
        createQuestionButtonContainer.insertAdjacentHTML("beforebegin", question);
        if (lessonQuizId) {
            let hiddenInput = `<input type="hidden" name="questions[${questionIndex}].lessonQuizId" value="${lessonQuizId}">`;
            document.getElementById(`questionId-${questionIndex}`).insertAdjacentHTML("beforeend", hiddenInput);
        }
    }
}

function createOption(questionIndex, questionId) {
    let optionsContainer = document.getElementById('options-questionId-' + questionIndex);
    let allOptions = optionsContainer.querySelectorAll(`[id^="questionId-${questionIndex}-optionId-"]`);
    let index = allOptions.length > 0
        ? Math.max(...Array.from(allOptions)
        .filter(el => /^questionId-\d+-optionId-\d+$/.test(el.id))
        .map(el => parseInt(el.id.match(/\d+$/)[0], 10))) + 1
        : 0;
    let option = `
        <div id="questionId-${questionIndex}-optionId-${index}" class="d-flex align-items-center mt-3" data-new="true">
             <div class="form-check d-flex align-items-center mb-0">
                  <input type="radio"
                         name="questions[${questionIndex}].correctOptionIndex"
                         value="${index}"
                         id="questions[${questionIndex}].options[${index}]"
                         class="form-check-input fs-4">
             </div>
             <div class="d-flex flex-grow-1 align-items-center">
                  <input type="text"
                         name="questions[${questionIndex}].options[${index}].optionText" 
                         id="questions[${questionIndex}].options[${index}].optionText"
                         placeholder="${window.APP_MESSAGES['js.lesson-materials.placeholder.answerOption']}"
                         aria-describedby="button-addon2"
                         class="form-control me-3">
                  <button class="btn btn-outline-danger"
                         type="button"
                         id="button-addon2"
                         onclick="deleteOption('questionId-${questionIndex}-optionId-${index}', 'option-${index}-error', ${questionIndex})">
                             <i class="fa-solid fa-trash"></i>
                  </button>
             </div>
        </div>
    `;
    optionsContainer.insertAdjacentHTML("beforeend", option);
    if (questionId) {
        let hiddenInput = `<input type="hidden" name="questions[${questionIndex}].options[${index}].questionId" value="${questionId}">`;
        document.getElementById(`options-questionId-${questionIndex}`).insertAdjacentHTML("beforeend", hiddenInput);
    }
    if (checkOptionsCount(questionIndex) === 4) {
        let addOptionButton = document.getElementById("add-options-button-question-" + questionIndex);
        addOptionButton.disabled = true;
    }
}

function checkOptionsCount(questionIndex) {
    let question = document.getElementById("questionId-" + questionIndex);
    let all = question.querySelectorAll('[id^="questionId-' + questionIndex + '-optionId-"]');
    let options = Array.from(all)
        .filter(el => /^questionId-\d+-optionId-\d+$/.test(el.id))
        .filter(el => el.getAttribute("deleted") !== 'true');
    return options.length;
}

function deleteQuestion(id) {
    let button = document.getElementById(id);
    let div = document.getElementById(id);
    button.addEventListener('click', () => {
        div.remove();
    });
}

function deleteOption(id, errorId, questionId) {
    let button = document.getElementById(id);
    let optionId = id.split('-').at(-1);
    let div = document.getElementById(id);
    let err;
    if (errorId) {
        err = document.querySelectorAll("." + errorId);
        err.forEach(e => e.remove());
    }
    let errorMessage = document.getElementById("invalid-" + id);
    if (errorMessage) {
        errorMessage.remove();
    }
    button.addEventListener('click', () => {
        const deletedRadio = document.getElementById("questions[" + questionId + "].options[" + optionId + "]");
        if (deletedRadio && deletedRadio.checked) {
            let radio = document.getElementById("questions[" + questionId + "].options[" + 0 + "]");
            if (radio) {
                radio.checked = true;
            }
        }
        div.remove();
        if (getOptionsCount(questionId) < 4) {
            document.getElementById("add-options-button-question-" + questionId).disabled = false;
        }
    });
    let hiddenInput = document.createElement("input")
    hiddenInput.setAttribute("type", "hidden")
    hiddenInput.setAttribute("name", "questions["+questionId+"].options["+optionId+"].isRemoved")
    hiddenInput.setAttribute("value", "true")
    const optionsBlock =  document.getElementById("options-questionId-"+questionId)
    optionsBlock.append(hiddenInput);
}

function deleteQuestionFromEdit(id, index) {
    let div = document.getElementById(id);
    let input = document.createElement("input");
    input.setAttribute("type", "hidden");
    input.setAttribute("name", "questions[" + index + "].isRemoved");
    input.setAttribute("value", "true");

    let deleteButton = document.getElementById("delete-question-" + index);
    deleteButton.remove();

    div.querySelectorAll("input").forEach(input => input.readOnly = true);
    div.querySelectorAll("button").forEach(button => button.disabled = true);

    let btn = document.createElement("button");
    btn.setAttribute("type", "button");
    btn.setAttribute("class", "btn btn-outline-warning");
    btn.innerHTML = `<i class="fa-solid fa-rotate-left"></i>`;

    btn.addEventListener("click", () => {
        input.remove();
        div.querySelectorAll("input").forEach(input => input.readOnly = false);
        div.querySelectorAll("button").forEach(button => button.disabled = false);
        div.setAttribute("class", "col-lg-8 col-md-8");
        btn.remove();
        btnDiv.append(deleteButton);
    });

    let btnDiv = document.getElementById("question-" + index + "-btnDiv");

    div.append(input);
    div.setAttribute("class", "col-lg-8 col-md-8 opacity-50");
    div.append(btn);
    btnDiv.append(btn);
}

function deleteOptionFromEdit(id, questionIndex, optionIndex, errorId) {
    let div = document.getElementById(id);
    let input = document.createElement("input");
    let isNew = div.hasAttribute("data-new");
    input.setAttribute("type", "hidden");
    input.setAttribute("name", "questions[" + questionIndex + "].options[" + optionIndex + "].isRemoved");
    input.setAttribute("value", "true");

    let deleteButton = document.getElementById("delete-question-" + questionIndex + "-option-" + optionIndex);
    deleteButton.remove();

    let err;
    if (errorId) {
        err = document.querySelectorAll("." + errorId);
        err.forEach(e => e.remove());
    }

    let btn = document.createElement("button");
    btn.setAttribute("type", "button");
    btn.setAttribute("class", "btn btn-outline-warning");
    btn.innerHTML = `<i class="fa-solid fa-rotate-left"></i>`;
    btn.addEventListener("click", () => {
        input.remove();
        div.querySelectorAll("input").forEach(input => input.readOnly = false);
        div.querySelectorAll("button").forEach(button => button.disabled = false);
        div.classList.remove("opacity-50");
        div.setAttribute("class", "d-flex flex-grow-1 align-items-center mt-3");
        if (getOptionsCountForEdit(questionIndex) > 4) {
            let optionBlock = document.getElementById("options-questionId-" + questionIndex);
            let newOptions = optionBlock.querySelectorAll('[data-new="true"]');
            if (newOptions.length !== 0) {
                newOptions[newOptions.length - 1].remove();
            }
        }
        btn.remove();
        btnDiv.append(deleteButton);
        if (getOptionsCountForEdit(questionIndex) === 4) {
            document.getElementById("add-options-button-question-" + questionIndex).disabled = true;
        }
    });

    let btnDiv = document.getElementById("question-" + questionIndex + "-option-" + optionIndex + "-inputBlock");
    let deletedInput = document.getElementById("questions" + questionIndex + ".options" + optionIndex + ".optionText");
    if (!isNew || deletedInput.value.trim() !== "") {
        div.querySelectorAll("input").forEach(input => input.readOnly = true);
        div.querySelectorAll("button").forEach(button => button.disabled = true);
        div.append(input);
        const deletedRadio = document.getElementById("questions[" + questionIndex + "].options[" + optionIndex + "]");
        if (deletedRadio && deletedRadio.checked) {
            let radio = document.getElementById("questions[" + questionIndex + "].options[" + 0 + "]");
            if (radio) {
                radio.checked = true;
            }
        }
        div.setAttribute("class", "d-flex flex-grow-1 align-items-center mt-3 opacity-50");
        btnDiv.append(btn);
        if (getOptionsCountForEdit(questionIndex) < 4) {
            document.getElementById("add-options-button-question-" + questionIndex).disabled = false;
        }
    } else {
        const deletedRadio = document.getElementById("questions[" + questionIndex + "].options[" + optionIndex + "]");
        if (deletedRadio && deletedRadio.checked) {
            let radio = document.getElementById("questions[" + questionIndex + "].options[" + 0 + "]");
            if (radio) {
                radio.checked = true;
            }
        }
        div.remove();
        if (getOptionsCountForEdit(questionIndex) < 4) {
            document.getElementById("add-options-button-question-" + questionIndex).disabled = false;
        }
    }
}

function getOptionsCount(questionId) {
    let questionBlock = document.getElementById("options-questionId-" + questionId);
    const pattern = /^questionId-\d+-optionId-\d+$/;
    let questionOptionCount = questionBlock.querySelectorAll('[id]');
    const filtredElements = Array.from(questionOptionCount).filter(e => pattern.test(e.id));
    return filtredElements.length;
}

function getOptionsCountForEdit(questionId) {
    let questionBlock = document.getElementById("options-questionId-" + questionId);
    const pattern = /^questionId-\d+-optionId-\d+$/;
    let questionOptionCount = questionBlock.querySelectorAll('[id]');
    const filtredElements = Array.from(questionOptionCount).filter(e => pattern.test(e.id) && !e.classList.contains("opacity-50"));
    return filtredElements.length;
}

document.addEventListener("DOMContentLoaded", () => {
    const pattern = /^questionId-\d+$/;
    let questions = document.querySelectorAll('[id]');
    const filtredElements = Array.from(questions).filter(e => pattern.test(e.id));
    for (let question of filtredElements) {
        let index = question.id.split('-')[1];
        if (getOptionsCount(index) === 4 || getOptionsCount(index) > 4) {
            document.getElementById("add-options-button-question-" + index).disabled = true;
        }
    }
});
