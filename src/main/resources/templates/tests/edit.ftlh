<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "Редактировать тест", "url": ""}
    ] />
    <#if test.questions?? && 0 < test.questions?size>
        <#assign questionlastIndex = test.questions?size - 1>
    <#else>
        <#assign questionlastIndex = 0>
    </#if>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Редактирование итогового теста</h1>
    </div>
    <form method="post" action="/test/edit" id="edit-test">


        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="test.title" class="form-label fw-bold">Название теста <span class="text-danger">*</span></label>
                        <@spring.formInput "test.title" 'class="form-control" id="test.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.description" class="form-label fw-bold">Описание теста <span class="text-danger">*</span></label>
                        <@spring.formTextarea "test.description" 'class="form-control" rows="3" id="test.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.passingScore" class="form-label fw-bold">Проходной балл <span class="text-danger">*</span></label>
                        <@spring.formInput "test.passingScore" 'class="form-control points" id="test.passingScore"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                </div>
            </div>
            <h3 class="text-center mb-4">Список вопросов</h3>
            <#if 0 < test.questions?size>
                <#list (test.questions)![] as question>
                    <div class="col-lg-10 col-md-10" id="questionId-${question?index}">
                        <div class="feature-card">
                            <#if question?index != 0>
                                <div class="text-end" id="question-${question?index}-btnDiv">
                                    <button type="button" class="btn btn-outline-danger"
                                            onclick="deleteQuestionFromEdit('questionId-${question?index}', ${question?index})"
                                            id="delete-question-${question?index}">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <label for="questions[${question?index}].question" class="form-label fw-bold">Введите
                                    текст вопроса <span class="text-danger">*</span></label>
                                <@spring.formInput "test.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <#if question.options??>
                                <div class="mt-3 border <#if .globals['org.springframework.validation.BindingResult.test']?? && .globals['org.springframework.validation.BindingResult.test'].hasFieldErrors('questions[${question?index}].correctOptionIndex')>border-danger</#if> rounded-4 px-4 py-3 mb-3"
                                     id="options-questionId-${question?index}">
                                    <#if .globals['org.springframework.validation.BindingResult.test']?? && .globals['org.springframework.validation.BindingResult.test'].hasFieldErrors('questions[${question?index}].correctOptionIndex')>
                                        <#list .globals['org.springframework.validation.BindingResult.test'].getFieldErrors('questions[${question?index}].correctOptionIndex') as validationError>
                                            <span class="text-danger">${validationError.defaultMessage}</span>
                                        </#list>
                                    </#if>
                                    <#list (question.options)![] as option>
                                        <div class="d-flex align-items-center mt-3"
                                             id="questionId-${question?index}-optionId-${option?index}"
                                             <#if option.id?has_content == false>data-new="true"</#if>>
                                            <div class="form-check d-flex align-items-center mb-0">
                                                <#if (question.correctOptionIndex?? && question.correctOptionIndex == option?index) || (option.isCorrect?? && option.isCorrect == true)>
                                                    <input type="radio"
                                                           name="questions[${question?index}].correctOptionIndex"
                                                           value="${option?index}"
                                                           id="questions[${question?index}].options[${option?index}]"
                                                           class="form-check-input fs-4"
                                                           checked/>
                                                <#else>
                                                    <input type="radio"
                                                           name="questions[${question?index}].correctOptionIndex"
                                                           value="${option?index}"
                                                           id="questions[${question?index}].options[${option?index}]"
                                                           class="form-check-input fs-4"/>
                                                </#if>
                                            </div>
                                            <#if 1 < option?index>
                                                <div class="d-flex flex-grow-1 align-items-center"
                                                     id="question-${question?index}-option-${option?index}-inputBlock">
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                placeholder="Вариант ответа"
                                                aria-describedby="delete-question-${question?index}-option-${option?index}"
                                                id="questions[${question?index}].options[${option?index}].optionText"' />
                                                    <button class="btn btn-outline-danger"
                                                            type="button"
                                                            id="delete-question-${question?index}-option-${option?index}"
                                                            onclick="deleteOptionFromEdit('questionId-${question?index}-optionId-${option?index}', ${question?index}, ${option?index}, 'option-${option?index}-error')">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </div>
                                            <#else>
                                                <div class="flex-grow-1 me-5"
                                                     id="question-${question?index}-option-${option?index}-inputBlock">
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                placeholder="Вариант ответа *"
                                                aria-describedby="delete-question-${question?index}-option-${option?index}"
                                                id="questions[${question?index}].options[${option?index}].optionText"' />
                                                </div>
                                            </#if>
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger option-${option?index}-error" />
                                        <input type="hidden"
                                               name="questions[${question?index}].options[${option?index}].id"
                                               value="${option.id!}">
                                        <input type="hidden"
                                               name="questions[${question?index}].options[${option?index}].questionId"
                                               value="${option.questionId!}">

                                    </#list>
                                </div>
                                <div class="mb-3" id="createOption-questionId-${question?index}">
                                    <button type="button" class="btn btn-primary-custom"
                                            onclick="addOptionFromEdit(${question?index}, ${question.id!})"
                                            id="add-options-button-question-${question?index}">
                                        Добавить вариант ответа
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <@spring.formCheckbox "test.questions[${question?index}].isRequired" 'class="form-check-input fs-4"'/>
                                <label for="questions[${question?index}].isRequired" class="form-label fw-bold mx-2">Активный?</label>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="questions[${question?index}].id" value="${question.id!}">
                    <input type="hidden" name="questions[${question?index}].testId" value="${question.testId!}">
                </#list>
            </#if>

            <div class=" mb-3 col-lg-10 col-md-10" id="createQuestion">
                <button type="button" class="btn btn-primary-custom"
                        onclick="createQuestionBlockFromEdit(${test.questions?size?c}, ${test.id})">Добавить вопрос
                </button>
            </div>
            <input type="hidden" name="id" value="${test.id}">
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="courseInstanceId" value="${test.courseInstanceId}">
            <div class="text-center">
                <button type="submit" class="btn btn-primary-custom w-75">Сохранить изменения</button>
            </div>
        </div>
    </form>
    <script>
        let questionIndex = ${test.questions?size?c};
        let pointsInput = document.querySelectorAll(".points")
        let createQuestionButtonFromEdit = document.getElementById("createQuestion");
        let testId = ${test.id}
        let form = document.getElementById("edit-test")

        pointsInput.forEach(input => {
            input.addEventListener('input', () => {
                input.value = input.value.replace(/[^0-9]/g, '');
                if (parseInt(input.value) > 100) {
                    input.value = '100';
                }
            });
        })

        function createQuestionBlockFromEdit(questionIndex, testId) {
            const optionIdRef = {value: 0};
            let colDiv = document.createElement("div")
            colDiv.setAttribute("class", "col-lg-10 col-md-10")
            colDiv.setAttribute("id", "questionId-" + questionIndex);

            let div = document.createElement("div");
            div.setAttribute("class", "feature-card");

            div.append(createRemoveQuestionButton("questionId-" + questionIndex))
            div.append(createInputContainer(
                "questions[" + questionId + "].question",
                `Введите текст вопроса <span class="text-danger">*</span>`,
                "questions[" + questionId + "].question",
                "questions" + questionId +".question",
                "text",
                "form-control"
            ))

            let optionsContainer = document.createElement("div");
            optionsContainer.setAttribute("class", "border rounded-4 px-4 py-3 mb-3");
            optionsContainer.setAttribute("id", "options-questionId-" + questionIndex);

            optionsContainer.append(createQuestionOption(questionIndex, optionIdRef.value, true));
            optionIdRef.value++;
            optionsContainer.append(createQuestionOption(questionIndex, optionIdRef.value, false));
            optionIdRef.value++;

            const addButton = createAddButton(questionIndex, optionsContainer, optionIdRef);
            optionsContainer.append(addButton);

            div.append(optionsContainer);

            div.append(createEmptyContainer(
                createCheckBox("questions[" + questionIndex + "].isRequired"),
                createLabel("questions[" + questionIndex + "].isRequired", "Активный?")
            ))
            let input = document.createElement("input")
            input.setAttribute("type", "hidden")
            input.setAttribute("name", "questions[" + questionIndex + "].testId")
            input.setAttribute("value", testId)
            div.append(input)
            colDiv.append(div)

            return colDiv;
        }

        function deleteQuestionFromEdit(id, index) {
            let div = document.getElementById(id);
            let input = document.createElement("input")
            input.setAttribute("type", "hidden")
            input.setAttribute("name", "questions[" + index + "].isRemoved")
            input.setAttribute("value", "true")

            let deleteButton = document.getElementById("delete-question-" + index)
            deleteButton.remove()

            div.querySelectorAll('input').forEach(input => input.readOnly = true)
            div.querySelectorAll("button").forEach(button => button.disabled = true)

            let btn = document.createElement("button")
            btn.setAttribute("type", "button")
            btn.setAttribute("class", "btn btn-outline-warning")
            btn.innerHTML = `<i class="fa-solid fa-rotate-left"></i>`

            btn.addEventListener("click", () => {
                input.remove()
                div.querySelectorAll('input').forEach(input => input.readOnly = false)
                div.querySelectorAll("button").forEach(button => button.disabled = false)
                div.setAttribute("class", "col-lg-10 col-md-10")
                btn.remove()
                btnDiv.append(deleteButton)
            })

            let btnDiv = document.getElementById("question-" + index + "-btnDiv")

            div.append(input);
            div.setAttribute("class", "col-lg-10 col-md-10 opacity-50")
            div.append(btn)
            btnDiv.append(btn)
        }

        function deleteOptionFromEdit(id, questionIndex, optionIndex, errorId) {
            let div = document.getElementById(id);
            let input = document.createElement("input")
            let isNew = div.hasAttribute("data-new");
            input.setAttribute("type", "hidden")
            input.setAttribute("name", "questions[" + questionIndex + "].options[" + optionIndex + "].isRemoved")
            input.setAttribute("value", "true")

            let deleteButton = document.getElementById("delete-question-" + questionIndex + "-option-" + optionIndex)
            deleteButton.remove()

            let err;
            if(errorId){
                err = document.querySelectorAll("."+errorId)
                err.forEach(e => e.remove())
            }
            let errorMessage = document.getElementById("invalid-"+id)
            if(errorMessage){
                errorMessage.remove();
                div.querySelector(".is-invalid").classList.remove("is-invalid")
            }

            let btn = document.createElement("button")
            btn.setAttribute("type", "button")
            btn.setAttribute("class", "btn btn-outline-warning")
            btn.innerHTML = `<i class="fa-solid fa-rotate-left"></i>`
            btn.addEventListener("click", () => {
                input.remove()
                div.querySelectorAll('input[type="text"]').forEach(input => input.readOnly = false)
                div.querySelectorAll('input[type="radio"]').forEach(input => input.disabled = false)
                div.querySelectorAll("button").forEach(button => button.disabled = false)
                div.classList.remove("opacity-50")
                div.setAttribute("class", "d-flex flex-grow-1 align-items-center mt-3")
                if (getOptionsCountForEdit(questionIndex) > 4){
                    let optionBlock = document.getElementById("options-questionId-"+questionIndex)
                    let newOptions = optionBlock.querySelectorAll('[data-new="true"]');
                    if(newOptions.length !== 0){
                        newOptions[newOptions.length - 1].remove();
                    }
                }
                btn.remove()
                btnDiv.append(deleteButton)
                if(getOptionsCountForEdit(questionIndex) === 4){
                    document.getElementById("add-options-button-question-"+questionIndex).disabled = true;
                }
            })

            let btnDiv = document.getElementById("question-" + questionIndex + "-option-" + optionIndex + "-inputBlock")
            let deletedInput = document.getElementById("questions"+questionIndex+".options"+optionIndex+".optionText")
            if(!isNew || deletedInput.value.trim() !== ""){
                div.querySelectorAll('input[type="text"]').forEach(input => input.readOnly = true)
                div.querySelectorAll('input[type="radio"]').forEach(input => input.disabled = true)
                div.querySelectorAll("button").forEach(button => button.disabled = true)
                div.append(input);
                div.setAttribute("class", "d-flex flex-grow-1 align-items-center mt-3 opacity-50")
                btnDiv.append(btn)
                if(getOptionsCountForEdit(questionIndex) < 4){
                    document.getElementById("add-options-button-question-"+questionIndex).disabled = false;
                }
            } else {
              div.remove()
                if(getOptionsCountForEdit(questionIndex) < 4){
                    document.getElementById("add-options-button-question-"+questionIndex).disabled = false;
                }
            }
        }

        function addOptionFromEdit(questionIndex, questionId) {
            let optionIndex = getOptionsCount(questionIndex);
            let newOption = createQuestionOptionFromEdit(questionIndex, optionIndex, questionId);
            let optionsBlock = document.getElementById("options-questionId-" + questionIndex);
            if (questionIndex !== 0) {
                let button = document.getElementById("createOption-questionId-" + questionIndex);
                optionsBlock.appendChild(newOption, button);
            } else {
                let button = document.getElementById("createOption")
                optionsBlock.appendChild(newOption, button);
            }
            if(getOptionsCountForEdit(questionIndex) === 4){
                document.getElementById("add-options-button-question-"+questionIndex).disabled = true;
            }
        }

        function createQuestionOptionFromEdit(questionIndex, optionIndex, questionId, isChecked) {
            let id = "questionId-" + questionIndex + "-optionId-" + optionIndex;
            let div = document.createElement("div");
            div.setAttribute("class", "mt-3 d-flex align-items-center");
            div.setAttribute("id", id);
            div.setAttribute("data-new", "true");

            div.append(createEmptyContainer(
                createRadio("questions[" + questionIndex + "].correctOptionIndex", questionIndex, optionIndex, isChecked),
            ))
            let optionContainer;
            if (optionIndex > 1) {
                optionContainer = createOptionInputContainer(
                    "questions[" + questionIndex + "].options[" + optionIndex + "].optionText",
                    "questions" + questionIndex +".options" + optionIndex + ".optionText",
                    "text",
                    "d-flex flex-grow-1 align-items-center"
                )
            } else {
                optionContainer = createOptionInputContainer(
                    "questions[" + questionIndex + "].options[" + optionIndex + "].optionText",
                    "questions" + questionIndex +".options" + optionIndex + ".optionText",
                    "text",
                    "flex-grow-1 me-5"
                )
            }
            if (optionIndex > 1) {
                optionContainer.append(createOptionRemoveButtonFromEdit(id, questionIndex))
            }

            let input = document.createElement("input")
            input.setAttribute("type", "hidden")
            input.setAttribute("name", "questions[" + questionIndex + "].options[" + optionIndex + "].questionId")
            input.setAttribute("value", questionId)
            optionContainer.append(input);

            div.append(optionContainer)
            return div;
        }

        createQuestionButtonFromEdit.addEventListener("click", () => {
            const newQuestion = createQuestionBlockFromEdit(questionId, testId);
            testFormDiv.insertBefore(newQuestion, createQuestionButtonFromEdit);
            questionId++;
        });

        function createOptionRemoveButtonFromEdit(id, questionId) {
            let button = document.createElement("button");
            button.setAttribute("type", "button");
            button.setAttribute("class", "btn btn-outline-danger");
            button.setAttribute("id", "button-addon2");
            button.innerHTML = `<i class="fa-solid fa-trash"></i>`;
            button.addEventListener("click", () => {
                const element = document.getElementById(id);
                if (element) element.remove();
                const errorMessage = document.getElementById("invalid-"+id)
                if(errorMessage) errorMessage.remove();
                if(getOptionsCountForEdit(questionId) < 4){
                    document.getElementById("add-options-button-question-"+questionId).disabled = false;
                }
            });
            return button;
        }

        function getOptionsCountForEdit(questionId){
            let questionBlock = document.getElementById("options-questionId-"+questionId);
            const pattern = /^questionId-\d+-optionId-\d+$/;
            let questionOptionCount = questionBlock.querySelectorAll('[id]');
            const filtredElements = Array.from(questionOptionCount).filter(e => pattern.test(e.id) && !e.classList.contains("opacity-50"));
            console.log(filtredElements.length)
            return (filtredElements.length);
        }

    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/test_form.js"></script>
    <script src="/static/js/test_create.js"></script>
</@page>