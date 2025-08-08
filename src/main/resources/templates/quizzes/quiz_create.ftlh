<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "${lesson.courseModule.courseInstance.title}", "url": "/teacher/course/${lesson.courseModule.courseInstance.id}"},
    {"label": "Урок #${lesson.title}", "url": "/lessons/${lesson.id}"},
    {"label": "Создание теста", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Тест по итогам урока</h1>
    </div>
    <form method="post" action="/quiz/create" id="create-quiz">


        <div class="row justify-content-center" id="test">
            <div class="col-lg-8 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="lessonQuiz.title" class="form-label fw-bold">Название теста <span class="text-danger">*</span></label>
                        <@spring.formInput "lessonQuiz.title" 'class="form-control" id="lessonQuiz.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.description" class="form-label fw-bold">Описание теста <span class="text-danger">*</span></label>
                        <@spring.formTextarea "lessonQuiz.description" 'class="form-control" rows="3" id="lessonQuiz.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.questionTimeLimit" class="form-label fw-bold">Время на прохождение теста (В минутах) <span class="text-danger">*</span></label>
                        <@spring.formInput "lessonQuiz.questionTimeLimit" 'class="form-control" id="lessonQuiz.questionTimeLimit"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                </div>
            </div>
            <h3 class="text-center mb-4">Список вопросов</h3>
            <#if lessonQuiz.questions?has_content && 0 < lessonQuiz.questions?size>
                <#list (lessonQuiz.questions)![] as question>
                    <div class="col-lg-8 col-md-10" id="questionId-${question?index}">
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
                                    текст вопроса <span class="text-danger">*</span></label>
                                <@spring.formInput "lessonQuiz.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
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
                                                            placeholder="Вариант ответа *"
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
                                                <div class="flex-grow-1 me-0">
                                                    <@spring.formInput "lessonQuiz.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                            placeholder="Вариант ответа *"
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
                <div class="col-lg-8 col-md-10" id="questionId-0">
                    <div class="feature-card">
                        <div class="mb-3">
                            <label for="questions[0].question" class="form-label fw-bold">Введите текст
                                вопроса  <span class="text-danger">*</span></label>
                            <@spring.formInput "lessonQuiz.questions[0].question" 'class="form-control" id="questions[0].question"' />
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
                                <div class="flex-grow-1 me-0">
                                    <@spring.formInput "lessonQuiz.questions[0].options[0].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа *"
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
                                <div class="flex-grow-1 me-0">
                                    <@spring.formInput "lessonQuiz.questions[0].options[1].optionText" 'class="form-control me-2"
                                    placeholder="Вариант ответа *"
                                    id="questions[0].options[1].optionText"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                            </div>
                            <div id="questionId-0-optionId-2" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="2"
                                           id="questions[0].options[2]"
                                           class="form-check-input fs-4"
                                    />
                                </div>
                                <div class="d-flex flex-grow-1 align-items-center">
                                    <@spring.formInput "lessonQuiz.questions[0].options[2].optionText" 'class="form-control me-3"
                                                            placeholder="Вариант ответа *"
                                                            aria-describedby="button-addon2"
                                                            id="questions[0].options[2].optionText"' />
                                    <button class="btn btn-outline-danger"
                                            type="button"
                                            id="button-addon2"
                                            onclick="deleteOption('questionId-0-optionId-2', 'option-2-error', 0)">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div id="questionId-0-optionId-3" class="d-flex align-items-center mt-3">
                                <div class="form-check d-flex align-items-center mb-0">
                                    <input type="radio"
                                           name="questions[0].correctOptionIndex"
                                           value="3"
                                           id="questions[0].options[3]"
                                           class="form-check-input fs-4"
                                    />
                                </div>
                                <div class="d-flex flex-grow-1 align-items-center">
                                    <@spring.formInput "lessonQuiz.questions[0].options[3].optionText" 'class="form-control me-3"
                                                            placeholder="Вариант ответа *"
                                                            aria-describedby="button-addon2"
                                                            id="questions[0].options[3].optionText"' />
                                    <button class="btn btn-outline-danger"
                                            type="button"
                                            id="button-addon2"
                                            onclick="deleteOption('questionId-0-optionId-3', 'option-3-error', 0)">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3" id="createOption">
                            <button type="button" class="btn btn-primary-custom" onclick="createOption(0)" id="add-options-button-question-0">
                                Добавить вариант ответа
                            </button>
                        </div>
                    </div>
                </div>
            </#if>

            <div class=" mb-3 col-lg-8 col-md-10 dropdown" id="createQuestionContainer">
                <div class="row align-items-center">
                    <div class="col-12 col-md-6 col-lg-3 mb-3 d-flex align-items-center">
                        <@spring.formCheckbox "lessonQuiz.isActive" 'class="form-check-input fs-4 me-2"'/>
                        <label class="form-check-label fw-bold" for="lessonQuiz.isActive">Активный?</label>
                    </div>
                    <div class="col-12 col-md-6 col-lg-9 mb-3 d-flex justify-content-end flex-wrap gap-2">
                        <div class="dropdown">
                            <button type="button" class="btn btn-primary-custom dropdown-toggle" id="createQuestion" data-bs-toggle="dropdown" aria-expanded="false">
                                Добавить вопросы
                            </button>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item" onclick="createQuestionBlock(1)">1</li>
                                <li class="dropdown-item" onclick="createQuestionBlock(3)">3</li>
                                <li class="dropdown-item" onclick="createQuestionBlock(5)">5</li>
                                <li class="dropdown-item" onclick="createQuestionBlock(10)">10</li>
                                <li class="dropdown-item" onclick="createQuestionBlock(15)">15</li>
                                <li class="dropdown-item" onclick="createQuestionBlock(20)">20</li>
                            </ul>
                        </div>
                        <button type="submit" class="btn btn-primary-custom">Создать тест</button>
                    </div>
                </div>
            </div>
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="lessonId" value="${lesson.id}">
        </div>
    </form>
    <script>
        let timeInput = document.getElementById("questionTimeLimit")
        let form = document.getElementById("create-quiz")
    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/quiz_form_validation.js"></script>
    <script src="/static/js/quiz_create.js"></script>
</@page>