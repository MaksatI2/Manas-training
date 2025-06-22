<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<@page>
    <#if test.questions?? && 0 < test.questions?size>
        <#assign questionlastIndex = test.questions?size - 1>
    <#else>
        <#assign questionlastIndex = 0>
    </#if>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-ballot-check"></i>Созданеие теста</h1>
        <p class="hero-subtitle">Создайте тестирующее задание</p>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-10 col-md-10">
            <div class="feature-card">
                <form method="post" action="/test/create" id="test">
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
                        <@spring.formInput "test.passingScore" 'class="form-control" id="test.passingScore"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <h3 class="mb-3">Время доступа к прохождению теста</h3>
                    <div class="mb-3">
                        <label for="dateRange" class="form-label fw-bold">Диапозон доступа к тесту</label>
                        <input type="text" id="dateRange" class="form-control" placeholder="Выберите диапазон"
                               name="range" value="${test.range!}"/>
                        <#if error??>
                            <span class="error text-danger">${error}</span>
                        </#if>
                    </div>
                    <#if 0 < test.questions?size>
                        <#list (test.questions)![] as question>
                            <div class="feature-card" id="questionId-${question?index}">
                                <div class="mb-3">
                                    <label for="questions[${question?index}].question" class="form-label fw-bold">Введите
                                        текст вопроса</label>
                                    <@spring.formInput "test.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                                <div class="mb-3">
                                    <label for="questions[${question?index}].points" class="form-label fw-bold">Количество
                                        баллов за правильный
                                        ответ</label>
                                    <@spring.formInput "test.questions[${question?index}].points" 'class="form-control" id="questions[${question?index}].points"' />
                                    <@spring.showErrors "<br>" "error text-danger" />
                                </div>
                                <#if question.options??>
                                    <#list (question.options)![] as option>
                                        <div class="mt-3" id="options-questionId-${question?index}">
                                            <div class="feature-card"
                                                 id="questionId-${question?index}-optionId-${option?index}">
                                                <div class="mb-3">
                                                    <label for="questions[${question?index}].options[${option?index}].optionText"
                                                           class="form-label fw-bold">Вариант ответа</label>
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control" id="questions[${question?index}].options[${option?index}].optionText"' />
                                                    <@spring.showErrors "<br>" "error text-danger" />
                                                </div>
                                                <div class="mb-3">
                                                    <@spring.formCheckbox "test.questions[${question?index}].options[${option?index}].isCorrect" 'class="form-check-input fs-4"'/>
                                                    <label for="questions[${question?index}].options[${option?index}].isCorrect"
                                                           class="form-label fw-bold">Верный ответ?</label>
                                                </div>
                                                <#if option?index != 0>
                                                    <div class="mb-3">
                                                        <button type="button"
                                                                class="btn btn-danger ms-2 px-4 py-2 rounded-5"
                                                                onclick="deleteOption('questionId-${question?index}-optionId-${option?index}')">
                                                            Удалить вариант ответа
                                                        </button>
                                                    </div>
                                                </#if>
                                            </div>
                                        </div>
                                    </#list>
                                    <div class="mb-3" id="createOption-questionId-${question?index}">
                                        <button type="button" class="btn btn-primary-custom"
                                                onclick="addOption(${question?index})">
                                            Добавить вариант ответа
                                        </button>
                                    </div>
                                </#if>
                                <div class="mb-3">
                                    <@spring.formCheckbox "test.questions[${question?index}].isRequired" 'class="form-check-input fs-4"'/>
                                    <label for="questions[${question?index}].isRequired" class="form-label fw-bold">Обязательный?</label>
                                </div>
                                <#if question?index != 0>
                                    <div class="mb-3">
                                        <button type="button" class="btn btn-danger ms-2 px-4 py-2 rounded-5"
                                                onclick="deleteQuestion('questionId-${question?index}')">Удалить вопрос
                                        </button>
                                    </div>
                                </#if>
                            </div>
                        </#list>
                    <#else>
                        <div class="feature-card" id="questionId-0">
                            <div class="mb-3">
                                <label for="questions[0].question" class="form-label fw-bold">Введите текст
                                    вопроса</label>
                                <@spring.formInput "test.questions[0].question" 'class="form-control" id="questions[0].question"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="mb-3">
                                <label for="questions[0].points" class="form-label fw-bold">Количество баллов за
                                    правильный ответ</label>
                                <@spring.formInput "test.questions[0].points" 'class="form-control" id="questions[0].points"' />
                                <@spring.showErrors "<br>" "error text-danger" />
                            </div>
                            <div class="mt-3" id="options-questionId-0">
                                <div class="feature-card" id="questionId-0-optionId-0">
                                    <div class="mb-3">
                                        <label for="questions[0].options[0].optionText" class="form-label fw-bold">Вариант
                                            ответа</label>
                                        <@spring.formInput "test.questions[0].options[0].optionText" 'class="form-control" id="questions[0].options[0].optionText"' />
                                        <@spring.showErrors "<br>" "error text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <@spring.formCheckbox "test.questions[0].options[0].isCorrect" 'class="form-check-input fs-4"'/>
                                        <label for="questions[0].options[0].isCorrect" class="form-label fw-bold">Верный
                                            ответ?</label>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3" id="createOption">
                                <button type="button" class="btn btn-primary-custom" onclick="addOption(0)">
                                    Добавить вариант ответа
                                </button>
                            </div>
                            <div class="mb-3">
                                <@spring.formCheckbox "test.questions[0].isRequired" 'class="form-check-input fs-4"'/>
                                <label for="questions[0].isRequired" class="form-label fw-bold">Обязательный?</label>
                            </div>
                        </div>
                    </#if>
                    <div class="mb-3" id="createQuestion">
                        <button type="button" class="btn btn-primary-custom">Добавить вопрос</button>
                    </div>
                    <div class="mb-3 form-check">
                        <@spring.formCheckbox "test.isActive" 'class="form-check-input fs-4"'/>
                        <label class="form-check-label fw-bold" for="test.isActive">Активный?</label>
                    </div>
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>
                    <input type="hidden" name="courseInstanceId" value="${test.courseInstanceId}">
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary-custom w-75">Создать тест</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        let questionIndex = ${questionlastIndex}
    </script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ru.js"></script>
    <script src="/static/js/test_create.js"></script>
</@page>