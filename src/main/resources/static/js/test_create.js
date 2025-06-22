let createQuestionButton = document.getElementById("createQuestion");
let testForm = document.getElementById("test");
let questionId = questionIndex+1;

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

function createInput(name, type) {
    let input = document.createElement("input");
    input.setAttribute("type", type);
    input.setAttribute("class", "form-control");
    input.setAttribute("name", name);
    input.setAttribute("id", name);
    return input;
}

function createInputContainer(labelName, labelText, inputName, inputType){
    let div = document.createElement("div")
    div.setAttribute("class", "mb-3")
    div.append(createLabel(labelName, labelText));
    div.append(createInput(inputName, inputType));
    return div;
}

function createEmptyContainer(element1, element2){
    let div = document.createElement("div")
    div.setAttribute("class", "mb-3")
    div.append(element1)
    if(element2){
        div.append(element2)
    }
    return div;
}

function createCheckBox(name) {
    let checkBox = document.createElement("input");
    checkBox.setAttribute("type", "checkbox");
    checkBox.setAttribute("class", "form-check-input fs-4");
    checkBox.setAttribute("name", name);
    checkBox.setAttribute("id", name);
    return checkBox;
}

function createRemoveButton(id, text) {
    let button = document.createElement("button");
    button.setAttribute("type", "button");
    button.setAttribute("class", "btn btn-danger ms-2 px-4 py-2 rounded-5");
    button.innerText = text;
    button.addEventListener("click", () => {
        const element = document.getElementById(id);
        if (element) element.remove();
    });
    return button;
}

function createQuestionOption(questionId, optionId) {
    let optionsCount = document.querySelectorAll(`[id^="questionId"][id*="optionId-"]`).length;
    let id = `questionId-${questionId}-optionId-${optionsCount}`;
    let div = document.createElement("div");
    div.setAttribute("class", "feature-card");
    div.setAttribute("id", id);

    div.append(createInputContainer(
        "questions[" + questionId + "].options[" + optionId + "].optionText",
        "Вариант ответа",
        "questions[" + questionId + "].options[" + optionId + "].optionText",
        "text",
    ))
    div.append(createEmptyContainer(
        createCheckBox("questions[" + questionId + "].options[" + optionId + "].isCorrect"),
        createLabel("questions[" + questionId + "].options[" + optionId + "].isCorrect", "Верный ответ?")
    ))
    if (optionId > 0){
        div.append(createEmptyContainer(createRemoveButton(id, "Удалить вариант ответа")));
    }
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

    button.addEventListener("click", () => {
        const newOption = createQuestionOption(questionId, optionIdRef.value);
        optionsContainer.insertBefore(newOption, button);
        optionIdRef.value++;
    });

    return button;
}

function createQuestionBlock(questionId) {
    const optionIdRef = { value: 0 }; // локальный "счетчик" для вариантов
    let div = document.createElement("div");
    div.setAttribute("class", "feature-card");
    div.setAttribute("id", `questionId-${questionId}`);

    div.append(createInputContainer(
        "questions[" + questionId + "].question",
        "Введите текст вопроса",
        "questions[" + questionId + "].question",
        "text"
        ))
    div.append(createInputContainer(
        "questions[" + questionId + "].points",
        "Количество баллов за правильный ответ",
        "questions[" + questionId + "].points",
        "number"
    ))

    let optionsContainer = document.createElement("div");
    optionsContainer.setAttribute("class", "mt-3");
    optionsContainer.setAttribute("id", `options-questionId-${questionId}`);

    optionsContainer.append(createQuestionOption(questionId, optionIdRef.value));
    optionIdRef.value++;

    const addButton = createAddButton(questionId, optionsContainer, optionIdRef);
    optionsContainer.append(addButton);

    div.append(optionsContainer);
    div.append(createEmptyContainer(
        createCheckBox("questions[" + questionId + "].isRequired"),
        createLabel("questions[" + questionId + "].isRequired", "Обязательный?")
    ))
    div.append(createEmptyContainer(
        createRemoveButton(`questionId-${questionId}`, "Удалить вопрос")
    ))

    return div;
}

function deleteQuestion(id){
    let button = document.getElementById(id);
    let div = document.getElementById(id);
    button.addEventListener('click', () => {
        div.remove();
    });
}

function deleteOption(id){
    let button = document.getElementById(id);
    let div = document.getElementById(id);
    button.addEventListener('click', () => {
        div.remove();
    });
}

createQuestionButton.addEventListener("click", () => {
    const newQuestion = createQuestionBlock(questionId);
    testForm.insertBefore(newQuestion, createQuestionButton);
    questionId++;
});