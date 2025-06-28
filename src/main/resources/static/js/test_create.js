let createQuestionButton = document.getElementById("createQuestion");
let testFormDiv = document.getElementById("test");
let questionId = questionIndex;

const optionCounters = {};

function getNextOptionId(questionId) {
    if (!(questionId in optionCounters)) {
        optionCounters[questionId] = 1;
    } else {
        optionCounters[questionId]++;
    }
    return optionCounters[questionId];
}

flatpickr("#dateRange", {
    mode: "range",
    enableTime: true,
    time_24hr: true,
    dateFormat: "Y-m-d H:i",
    locale: "ru",
    onChange: function(selectedDates, dateStr, instance) {
        if (selectedDates.length === 2) {
            const formatted = selectedDates.map(d =>
                instance.formatDate(d, "Y-m-d H:i")
            ).join(" - ");
            instance._input.value = formatted;
        }
    }
});

function createLabel(name, text) {
    let label = document.createElement("label");
    label.setAttribute("for", name);
    label.setAttribute("class", "form-label fw-bold");
    label.innerText = text;
    return label;
}

function createInput(name, type, className) {
    let input = document.createElement("input");
    input.setAttribute("type", type);
    input.setAttribute("class", className);
    input.setAttribute("name", name);
    input.setAttribute("id", name);
    if (className.includes('points')){
        input.addEventListener("input", () => {
            input.value = input.value.replace(/[^0-9]/g, '');
            if (parseInt(input.value) > 100) {
                input.value = '100';
            }
        })
    }
    return input;
}

function createOptionInput(name, type) {
    let input = document.createElement("input");
    input.setAttribute("type", type);
    input.setAttribute("class", "form-control me-2");
    input.setAttribute("placeholder", "Вариант ответа")
    input.setAttribute("aria-describedby", "button-addon2")
    input.setAttribute("name", name);
    input.setAttribute("id", name);
    return input;
}

function createInputContainer(labelName, labelText, inputName, inputType, inputClassName){
    let div = document.createElement("div")
    div.setAttribute("class", "mb-3")
    div.append(createLabel(labelName, labelText));
    div.append(createInput(inputName, inputType, inputClassName));
    return div;
}

function createOptionInputContainer(inputName, inputType, className){
    let div = document.createElement("div")
    div.setAttribute("class", className)
    div.append(createOptionInput(inputName, inputType));
    return div;
}

function createEmptyContainer(element1, element2){
    let div = document.createElement("div")
    div.setAttribute("class", "form-check d-flex align-items-center mb-0")
    div.append(element1)
    if(element2){
        div.append(element2)
    }
    return div;
}

function createCheckBox(name) {
    let checkBox = document.createElement("input");
    checkBox.setAttribute("type", "checkbox");
    checkBox.setAttribute("class", "form-check-input fs-4 me-2");
    checkBox.setAttribute("name", name);
    checkBox.setAttribute("id", name);
    checkBox.setAttribute("checked", "true");
    return checkBox;
}

function createRadio(name, questionId, optionId, isChecked) {
    let radio = document.createElement("input");
    radio.setAttribute("type", "radio");
    radio.setAttribute("class", "form-check-input fs-4 me-2");
    radio.setAttribute("name", name);
    radio.setAttribute("id", "questions[" + questionId + "].options[" + optionId + "]");
    radio.setAttribute("value", optionId)
    if(isChecked && isChecked === true){
        radio.setAttribute("checked", "true")
    }
    return radio;
}

function createRemoveQuestionButton(id) {
    let div = document.createElement("div")
    div.setAttribute("class", "text-end")
    let button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "btn btn-outline-danger");
    button.innerHTML = `<i class="fa-solid fa-trash"></i>`;
    button.addEventListener("click", () => {
        const element = document.getElementById(id);
        if (element) element.remove();
    });
    div.append(button)
    return div;
}

function createOptionRemoveButton(id) {
    let button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "btn btn-outline-danger");
    button.setAttribute("id", "button-addon2");
    button.innerHTML = `<i class="fa-solid fa-trash"></i>`;
    button.addEventListener("click", () => {
        const element = document.getElementById(id);
        if (element) element.remove();
    });
    return button;
}

function createQuestionOption(questionId, optionId, isChecked) {
    let optionsCount = document.querySelectorAll(`[id^="questionId"][id*="optionId-"]`).length;
    let id = `questionId-${questionId}-optionId-${optionsCount}`;
    let div = document.createElement("div");
    div.setAttribute("class", "d-flex align-items-center mt-3");
    div.setAttribute("id", id);

    div.append(createEmptyContainer(
        createRadio("questions[" + questionId + "].correctOptionIndex", questionId, optionId, isChecked),
    ))
    let optionContainer;
    if (optionId > 0){
        optionContainer = createOptionInputContainer(
            "questions[" + questionId + "].options[" + optionId + "].optionText",
            "text",
            "d-flex flex-grow-1 align-items-center"
            )
    }else {
        optionContainer = createOptionInputContainer(
            "questions[" + questionId + "].options[" + optionId + "].optionText",
            "text",
            "flex-grow-1 me-5"
        )
    }
    if (optionId > 0){
        optionContainer.append(createOptionRemoveButton(id))
    }

    div.append(optionContainer)
    return div;
}

function addOption(questionId) {
    let optionId = getNextOptionId(questionId);
    let newOption = createQuestionOption(questionId, optionId);
    let optionsBlock = document.getElementById("options-questionId-" + questionId);
    if(questionId !== 0){
        let button = document.getElementById("createOption-questionId-"+questionId);
        optionsBlock.appendChild(newOption, button);
    }else {
        let button = document.getElementById("createOption")
        optionsBlock.appendChild(newOption, button);
    }
}

function createAddButton(questionId, optionsContainer, optionIdRef) {
    let button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "btn btn-primary-custom");
    button.innerText = "Добавить вариант ответа";

    let div = document.createElement("div")
    div.setAttribute("class", "my-3")

    button.addEventListener("click", () => {
        const newOption = createQuestionOption(questionId, optionIdRef.value);
        optionsContainer.insertBefore(newOption, div);
        optionIdRef.value++;
    });

    div.append(button)

    return div;
}

function deleteQuestion(id){
    let button = document.getElementById(id);
    let div = document.getElementById(id);
    button.addEventListener('click', () => {
        div.remove();
    });
}

function deleteOption(id, errorId){
    let button = document.getElementById(id);
    let div = document.getElementById(id);
    let err;
    if(errorId){
        err = document.querySelectorAll("."+errorId)
        err.forEach(e => e.remove())
    }
    button.addEventListener('click', () => {
        div.remove();
    });
}

createQuestionButton.addEventListener("click", () => {
    const newQuestion = createQuestionBlock(questionId);
    testFormDiv.insertBefore(newQuestion, createQuestionButton);
    questionId++;
});