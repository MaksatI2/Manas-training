<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome><@spring.message code='teacher.lessonQuizEdit.breadcrumb.home'/></#assign>
<#assign bcMyCourses><@spring.message code='teacher.lessonQuizEdit.breadcrumb.myCourses'/></#assign>
<#assign bcCourse>${springMacroRequestContext.getMessage("teacher.lessonQuizEdit.breadcrumb.course", [], "Курс") + ": " + lesson.courseModule.courseInstance.title}</#assign>
<#assign bcLesson>${springMacroRequestContext.getMessage("teacher.lessonQuizEdit.breadcrumb.lesson", [], "Урок") + " #" + lesson.title}</#assign>
<#assign bcEdit>${springMacroRequestContext.getMessage("teacher.lessonQuizEdit.breadcrumb.editQuiz", [lessonQuiz.title], "Редактирование теста: " + lessonQuiz.title)}</#assign>

<@page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/teacher/my-courses"},
    {"label": bcCourse, "url": "/teacher/course/${lesson.courseModule.courseInstance.id}"},
    {"label": bcLesson, "url": "/lessons/${lesson.id}"},
    {"label": bcEdit, "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> <@spring.message code='teacher.lessonQuizEdit.pageTitle'/></h1>
    </div>
    <form method="post" action="/quiz/edit" id="edit-quiz">
        <div class="row justify-content-center" id="test">
            <div class="col-lg-8 col-md-10">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="lessonQuiz.title"
                               class="form-label fw-bold"><@spring.message code='teacher.lessonQuizEdit.label.title'/>
                            <span class="text-danger">*</span></label>
                        <@spring.formInput "lessonQuiz.title" 'class="form-control" id="lessonQuiz.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.description"
                               class="form-label fw-bold"><@spring.message code='teacher.lessonQuizEdit.label.description'/>
                            <span class="text-danger">*</span></label>
                        <@spring.formTextarea "lessonQuiz.description" 'class="form-control" rows="3" id="lessonQuiz.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="lessonQuiz.questionTimeLimit"
                               class="form-label fw-bold"><@spring.message code='teacher.lessonQuizEdit.label.timeLimit'/>
                            <span class="text-danger">*</span></label>
                        <@spring.formInput "lessonQuiz.questionTimeLimit" 'class="form-control" id="lessonQuiz.questionTimeLimit"' />
                        <#if .globals['org.springframework.validation.BindingResult.lessonQuiz']?? &&
                        .globals['org.springframework.validation.BindingResult.lessonQuiz'].hasFieldErrors('questionTimeLimit')>
                            <#list .globals['org.springframework.validation.BindingResult.lessonQuiz'].getFieldErrors('questionTimeLimit') as validationError>
                                <span class="text-danger">${validationError.defaultMessage}</span>
                            </#list>
                        </#if>
                    </div>
                </div>
            </div>
            <h3 class="text-center mb-4"><@spring.message code='teacher.lessonQuizEdit.questionsListTitle'/></h3>
            <#if 0 < lessonQuiz.questions?size>
                <#list (lessonQuiz.questions)![] as question>
                    <div class="col-lg-8 col-md-10" id="questionId-${question?index}">
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
                                <label for="questions[${question?index}].question"
                                       class="form-label fw-bold"><@spring.message code='teacher.lessonQuizEdit.label.questionText'/>
                                    <span class="text-danger">*</span></label>
                                <@spring.formInput "lessonQuiz.questions[${question?index}].question" 'class="form-control" id="questions[${question?index}].question"' />
                                <#if .globals['org.springframework.validation.BindingResult.lessonQuiz']?? &&
                                .globals['org.springframework.validation.BindingResult.lessonQuiz'].hasFieldErrors("questions[${question?index}].question")>
                                    <#list .globals['org.springframework.validation.BindingResult.lessonQuiz'].getFieldErrors("questions[${question?index}].question") as validationError>
                                        <span class="text-danger">${validationError.defaultMessage}</span>
                                    </#list>
                                </#if>
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
                                                    <@spring.formInput "lessonQuiz.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                placeholder="${springMacroRequestContext.getMessage("teacher.lessonQuizEdit.label.answerOption", [], "Вариант ответа")} *"
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
                                                <div class="flex-grow-1 me-0"
                                                     id="question-${question?index}-option-${option?index}-inputBlock">
                                                    <@spring.formInput "lessonQuiz.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3"
                                                placeholder="${springMacroRequestContext.getMessage("teacher.lessonQuizEdit.label.answerOption", [], "Вариант ответа")} *"
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
                                            onclick="createOption(${question?index}, ${question.id})"
                                            id="add-options-button-question-${question?index}">
                                        <@spring.message code='teacher.lessonQuizEdit.button.addAnswerOption'/>
                                    </button>
                                </div>
                            </#if>
                        </div>
                    </div>
                    <input type="hidden" name="questions[${question?index}].id" value="${question.id!}">
                    <input type="hidden" name="questions[${question?index}].quizId" value="${question.quizId!}">
                </#list>
            </#if>

            <div class=" mb-3 col-lg-8 col-md-10" id="createQuestionContainer">
                <div class="row">
                    <div class="col-12 col-md-6 col-lg-3 mb-3 d-flex align-items-center">
                        <@spring.formCheckbox "lessonQuiz.isActive" 'class="form-check-input fs-4 ms-3"'/>
                        <label class="form-check-label fw-bold"
                               for="lessonQuiz.isActive"><@spring.message code='teacher.lessonQuizEdit.label.isActive'/></label>
                    </div>
                    <div class="col-12 col-md-6 col-lg-9 mb-3 d-flex justify-content-end flex-wrap gap-2">
                        <button type="button" class="btn btn-primary-custom dropdown-toggle me-3" id="createQuestion"
                                data-bs-toggle="dropdown">
                            <@spring.message code='teacher.lessonQuizEdit.button.addQuestions'/>
                        </button>
                        <ul class="dropdown-menu">
                            <li class="dropdown-item" onclick="createQuestionBlock(1, ${lessonQuiz.id})">1</li>
                            <li class="dropdown-item" onclick="createQuestionBlock(3, ${lessonQuiz.id})">3</li>
                            <li class="dropdown-item" onclick="createQuestionBlock(5, ${lessonQuiz.id})">5</li>
                            <li class="dropdown-item" onclick="createQuestionBlock(10, ${lessonQuiz.id})">10</li>
                            <li class="dropdown-item" onclick="createQuestionBlock(15, ${lessonQuiz.id})">15</li>
                            <li class="dropdown-item" onclick="createQuestionBlock(20, ${lessonQuiz.id})">20</li>
                        </ul>
                        <button type="submit"
                                class="btn btn-primary-custom me-3"><@spring.message code='teacher.lessonQuizEdit.button.saveChanges'/></button>
                    </div>
                </div>
            </div>
            <input type="hidden" name="id" value="${lessonQuiz.id}">
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="lessonId" value="${lessonQuiz.lessonId}">
            <input type="hidden" name="lessonQuiz.id" value="${lessonQuiz.id}">
        </div>
    </form>
    <script>
        let timeInput = document.getElementById("questionTimeLimit")
        let form = document.getElementById("edit-quiz")
    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/quiz_form_validation.js"></script>
    <script src="/static/js/quiz_create.js"></script>
</@page>
