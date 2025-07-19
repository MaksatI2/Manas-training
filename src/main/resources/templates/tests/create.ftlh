<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "Создать тест", "url": ""}
    ] />
    <#if test.questions?? && 0 < test.questions?size>
        <#assign questionlastIndex = test.questions?size - 1>
    <#else>
        <#assign questionlastIndex = 0>
    </#if>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Итоговый тест</h1>
    </div>
    <form method="post" action="/test/create" id="create-test">


        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="test.title" class="form-label fw-bold">Название теста</label>
                        <@spring.formInput "test.title" 'class="form-control" id="test.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.description" class="form-label fw-bold">Описание теста</label>
                        <@spring.formTextarea "test.description" 'class="form-control" rows="3" id="test.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.passingScore" class="form-label fw-bold">Проходной балл</label>
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
                                <div class="text-end">
                                    <button type="button" class="btn btn-outline-danger fs-5"
                                            onclick="deleteQuestion('questionId-${question?index}')">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <label for="questions[${question?index}].question" class="form-label fw-bold">Введите
                                    текст вопроса</label>
                                <@spring.formInput "test.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <#if question.options??>
                                <div class="mt-3 border rounded-4 px-4 py-3 mb-3"
                                     id="options-questionId-${question?index}">
                                    <#list (question.options)![] as option>
                                        <div class="d-flex align-items-center mt-3"
                                             id="questionId-${question?index}-optionId-${option?index}">
                                            <div class="form-check d-flex align-items-center mb-0">
                                                <#if test.questions[question?index].correctOptionIndex?? && test.questions[question?index].correctOptionIndex == option?index>
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
                                                <div class="d-flex flex-grow-1 align-items-center">
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                            placeholder="Вариант ответа"
                                                            aria-describedby="button-addon2"
                                                            id="questions[${question?index}].options[${option?index}].optionText"' />
                                                    <button class="btn btn-outline-danger"
                                                            type="button"
                                                            id="button-addon2"
                                                            onclick="deleteOption('questionId-${question?index}-optionId-${option?index}', 'option-${option?index}-error', ${question?index})">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </div>
                                            <#else>
                                                <div class="flex-grow-1 me-5">
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                            placeholder="Вариант ответа"
                                                            aria-describedby="button-addon2"
                                                            id="questions[${question?index}].options[${option?index}].optionText"' />
                                                </div>
                                            </#if>
                                        </div>
                                        <@spring.showErrors "<br>" "error text-danger option-${option?index}-error"/>
                                    </#list>
                                </div>
                                <div class="mb-3" id="createOption-questionId-${question?index}">
                                    <button type="button" class="btn btn-primary-custom"
                                            onclick="addOption(${question?index})" id="add-options-button-question-${question?index}">
                                        Добавить вариант ответа
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <@spring.formCheckbox "test.questions[${question?index}].isRequired" 'class="form-check-input fs-4"'/>
                                <label for="questions[${question?index}].isRequired" class="form-label fw-bold mx-2">Обязательный?</label>
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <div class="col-lg-10 col-md-10">
                    <div class="feature-card">
                        <div class="mb-3">
                            <label for="questions[0].question" class="form-label fw-bold">Введите текст
                                вопроса</label>
                            <@spring.formInput "test.questions[0].question" 'class="form-control me-2" id="questions[0].question"' />
                            <@spring.showErrors "<br>" "error text-danger" />
                        </div>
                        <div class="mt-3 border rounded-4 px-4 py-3 mb-3" id="options-questionId-0">
                            <div id="questionId-0-optionId-0" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="0"
                                           id="questions[0].options[0]"
                                           class="form-check-input fs-4"
                                           checked/>
                                </div>
                                <div class="flex-grow-1 me-5">
                                    <@spring.formInput "test.questions[0].options[0].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа"
                                    id="questions[0].options[0].optionText"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                            </div>
                            <div id="questionId-0-optionId-1" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="1"
                                           id="questions[0].options[1]"
                                           class="form-check-input fs-4"
                                    />
                                </div>
                                <div class="flex-grow-1 me-5">
                                    <@spring.formInput "test.questions[0].options[1].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа"
                                    id="questions[0].options[1].optionText"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                            </div>
                        </div>
                        <div class="mb-3" id="createOption">
                            <button type="button" class="btn btn-primary-custom" onclick="addOption(0)" id="add-options-button-question-0">
                                Добавить вариант ответа
                            </button>
                        </div>
                        <div class="mb-3">
                            <@spring.formCheckbox "test.questions[0].isRequired" 'class="form-check-input fs-4" checked'/>
                            <label for="questions[0].isRequired"
                                   class="form-label fw-bold mx-2">Обязательный?</label>
                        </div>
                    </div>
                </div>
            </#if>

            <div class=" mb-3 col-lg-10 col-md-10" id="createQuestion">
                <button type="button" class="btn btn-primary-custom"
                        onclick="createQuestionBlock(${test.questions?size?c})">Добавить вопрос
                </button>
            </div>
            <div class="mb-3 form-check col-lg-10 col-md-10" id="active-test-block">
                <@spring.formCheckbox "test.isActive" 'class="form-check-input fs-4" checked'/>
                <label class="form-check-label fw-bold" for="test.isActive">Активный?</label>
            </div>
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="courseInstanceId" value="${test.courseInstanceId}">
            <div class="text-center">
                <button type="submit" class="btn btn-primary-custom w-75">Создать тест</button>
            </div>
        </div>
    </form>
    <script>
        let questionIndex = ${test.questions?size?c};
        let pointsInput = document.querySelectorAll(".points")

        let createForm = document.getElementById("create-test")
        createForm.addEventListener("submit", event => {
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

            const questionsArray = Array.from(testQuestions.entries())
                .map(([_, value]) => ({
                    question: value.question,
                    options: value.options
                }));
            console.log(questionsArray)
            const questionsCount = questionsArray.length;
            for(let i = 0; i < questionsCount; i++){
                if(!questionsArray[i].question){
                    hasError = true
                    let input = document.getElementById("questions"+i+".question")
                    if (input){
                        input.classList.add("is-invalid")
                        let error = document.createElement("label")
                        error.setAttribute("for", "questions"+i+".question")
                        error.setAttribute("class", "text-danger error-message")
                        error.innerText = "Заполните текст вопроса"
                        input.parentNode.insertBefore(error, input.nextSibling);
                    }
                }
                const optionCount = questionsArray[i].options.length
                for(let a = 0; a < optionCount; a++){
                    if(!questionsArray[i].options[a]){
                        hasError = true
                        let input = document.getElementById("questions"+i+".options"+a+".optionText")
                        if (input){
                            input.classList.add("is-invalid")
                            let error = document.createElement("label")
                            error.setAttribute("for", "questions"+i+".options"+a+".optionText")
                            error.setAttribute("class", "text-danger error-message")
                            error.innerText = "Заполните вариант ответа"
                            let div = document.getElementById("questionId-"+i+"-optionId-"+a)
                            div.parentNode.insertBefore(error, div.nextSibling);
                        }
                    }
                }
            }
            if(hasError){
                event.preventDefault();
            }
        })

        pointsInput.forEach(input => {
            input.addEventListener('input', () => {
                input.value = input.value.replace(/[^0-9]/g, '');
                if (parseInt(input.value) > 100) {
                    input.value = '100';
                }
            });
        })

        function createQuestionBlock(questionId) {
            const optionIdRef = {value: 0};
            let colDiv = document.createElement("div")
            colDiv.setAttribute("class", "col-lg-10 col-md-10")
            colDiv.setAttribute("id", "questionId-" + questionId);

            let div = document.createElement("div");
            div.setAttribute("class", "feature-card");

            div.append(createRemoveQuestionButton("questionId-" + questionId))
            div.append(createInputContainer(
                "questions[" + questionId + "].question",
                "Введите текст вопроса",
                "questions[" + questionId + "].question",
                "questions" + questionId +".question",
                "text",
                "form-control"
            ))

            let optionsContainer = document.createElement("div");
            optionsContainer.setAttribute("class", "mt-3 border rounded-4 px-4 py-3");
            optionsContainer.setAttribute("id", "options-questionId-" + questionId);

            optionsContainer.append(createQuestionOption(questionId, optionIdRef.value, true));
            optionIdRef.value++;
            optionsContainer.append(createQuestionOption(questionId, optionIdRef.value, false));
            optionIdRef.value++;

            const addButton = createAddButton(questionId, optionsContainer, optionIdRef);
            optionsContainer.append(addButton);

            div.append(optionsContainer);

            div.append(createEmptyContainer(
                createCheckBox("questions[" + questionId + "].isRequired"),
                createLabel("questions[" + questionId + "].isRequired", "Обязательный?")
            ))

            colDiv.append(div)

            return colDiv;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ru.js"></script>
    <script src="/static/js/test_create.js"></script>
</@page>