<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Урок #${lessonQuiz.lessonId}", "url": "/lessons/${lessonQuiz.lessonId}"},
    {"label": "Создание теста", "url": ""}
    ] />
    <#if lessonQuiz.questions?? && 0 < lessonQuiz.questions?size>
        <#assign questionlastIndex = lessonQuiz.questions?size - 1>
    <#else>
        <#assign questionlastIndex = 0>
    </#if>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Тест по итогам урока</h1>
    </div>
    <form method="post" action="/quiz/create">


        <div class="row justify-content-center" id="test">
            <div class="col-lg-10 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="lessonQuiz.title" class="form-label fw-bold">Название теста</label>
                        <@spring.formInput "lessonQuiz.title" 'class="form-control" id="lessonQuiz.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.description" class="form-label fw-bold">Описание теста</label>
                        <@spring.formTextarea "lessonQuiz.description" 'class="form-control" rows="3" id="lessonQuiz.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.questionTimeLimit" class="form-label fw-bold">Время на прохождение</label>
                        <@spring.formInput "lessonQuiz.questionTimeLimit" 'class="form-control points" id="lessonQuiz.questionTimeLimit"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                </div>
            </div>
            <h3 class="text-center mb-4">Список вопросов</h3>
            <#if lessonQuiz.questions?has_content && 0 < lessonQuiz.questions?size>
                <#list (lessonQuiz.questions)![] as question>
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
                                <@spring.formInput "lessonQuiz.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <#if question.options??>
                                <div class="mt-3 border rounded-4 px-4 py-3 mb-3"
                                     id="options-questionId-${question?index}">
                                    <#list (question.options)![] as option>
                                        <div class="d-flex align-items-center mt-3"
                                             id="questionId-${question?index}-optionId-${option?index}">
                                            <div class="form-check d-flex align-items-center mb-0">
                                                <#if lessonQuiz.questions[question?index].correctOptionIndex?? && lessonQuiz.questions[question?index].correctOptionIndex == option?index>
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
                                                    <@spring.formInput "lessonQuiz.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
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
                                                    <@spring.formInput "lessonQuiz.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
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
                                            onclick="addOption(${question?index})"
                                            id="add-options-button-question-${question?index}">
                                        Добавить вариант ответа
                                    </button>
                                </div>
                            </#if>
                        </div>
                    </div>
                </#list>
            <#else>
                <div class="col-lg-10 col-md-10">
                    <div class="feature-card">
                        <div class="mb-3">
                            <label for="questions[0].question" class="form-label fw-bold">Введите текст
                                вопроса</label>
                            <@spring.formInput "lessonQuiz.questions[0].question" 'class="form-control" id="questions[0].question"' />
                            <@spring.showErrors "<br>" "error text-danger" />
                        </div>
                        <div class="mt-3 border rounded-4 px-4 py-3 mb-3" id="options-questionId-0">
                            <div id="questionId-0-optionId-0" class="mb-3 d-flex align-items-center">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="0"
                                           id="questions[0].options[0]"
                                           class="form-check-input fs-4"
                                           checked/>
                                </div>
                                <div class="flex-grow-1 me-5">
                                    <@spring.formInput "lessonQuiz.questions[0].options[0].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа"
                                    id="questions[0].options[0].optionText"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                            </div>
                            <div id="questionId-0-optionId-1" class="mb-3 d-flex align-items-center">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="0"
                                           id="questions[0].options[1]"
                                           class="form-check-input fs-4"
                                           checked/>
                                </div>
                                <div class="flex-grow-1 me-5">
                                    <@spring.formInput "lessonQuiz.questions[0].options[1].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа"
                                    id="questions[0].options[0].optionText"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                            </div>
                        </div>
                        <div class="mb-3" id="createOption">
                            <button type="button" class="btn btn-primary-custom" onclick="addOption(0)" id="add-options-button-question-0">
                                Добавить вариант ответа
                            </button>
                        </div>
                    </div>
                </div>
            </#if>

            <div class=" mb-3 col-lg-10 col-md-10" id="createQuestion">
                <button type="button" class="btn btn-primary-custom" onclick="createQuestionBlock(${lessonQuiz.questions?size?c})">Добавить вопрос</button>
            </div>
            <div class="mb-3 form-check col-lg-10 col-md-10" id="active-test-block">
                <@spring.formCheckbox "lessonQuiz.isActive" 'class="form-check-input fs-4"'/>
                <label class="form-check-label fw-bold" for="lessonQuiz.isActive">Активный?</label>
            </div>
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="lessonId" value="${lessonQuiz.lessonId}">
            <div class="text-center">
                <button type="submit" class="btn btn-primary-custom w-75">Создать тест</button>
            </div>
        </div>
    </form>
    <script>
        let questionIndex = ${lessonQuiz.questions?size?c};
        let pointsInput = document.querySelectorAll(".points")

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
                "text",
                "form-control"
            ))

            let optionsContainer = document.createElement("div");
            optionsContainer.setAttribute("class", "mt-3 border rounded-4 px-4 py-3 mb-3");
            optionsContainer.setAttribute("id", "options-questionId-" + questionId);

            optionsContainer.append(createQuestionOption(questionId, optionIdRef.value, true));
            optionIdRef.value++;
            optionsContainer.append(createQuestionOption(questionId, optionIdRef.value, false));
            optionIdRef.value++;

            const addButton = createAddButton(questionId, optionsContainer, optionIdRef);
            optionsContainer.append(addButton);

            div.append(optionsContainer);

            colDiv.append(div)

            return colDiv;
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ru.js"></script>
    <script src="/static/js/test_create.js"></script>
</@page>