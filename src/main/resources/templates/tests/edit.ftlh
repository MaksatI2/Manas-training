<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <#assign bcHome><@spring.message code='test.final.edit.breadcrumb.home'/></#assign>
    <#assign bcMyCourses><@spring.message code='test.final.edit.breadcrumb.myCourses'/></#assign>
    <#assign bcEdit><@spring.message code='test.final.edit.breadcrumb.edit'/></#assign>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMyCourses, "url": "/teacher/my-courses"},
    {"label": bcEdit, "url": ""}
    ] />

    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> <@spring.message code="test.final.edit.pageTitle"/></h1>
    </div>
    <form method="post" action="/test/edit" id="edit-test">
        <div class="row justify-content-center" id="test">
            <div class="col-lg-8 col-md-8">
                <div class="feature-card">
                    <div class="mb-3">
                        <label for="test.title"
                               class="form-label fw-bold"><@spring.message code="test.final.edit.form.title.label"/>
                            <span class="text-danger"><@spring.message code="test.final.edit.form.title.required"/></span></label>
                        <@spring.formInput "test.title" 'class="form-control" id="test.title"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.description"
                               class="form-label fw-bold"><@spring.message code="test.final.edit.form.description.label"/>
                            <span class="text-danger"><@spring.message code="test.final.edit.form.description.required"/></span></label>
                        <@spring.formTextarea "test.description" 'class="form-control" rows="3" id="test.description"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                    <div class="mb-3">
                        <label for="test.passingScore"
                               class="form-label fw-bold"><@spring.message code="test.final.edit.form.passingScore.label"/>
                            <span class="text-danger"><@spring.message code="test.final.edit.form.passingScore.required"/></span></label>
                        <@spring.formInput "test.passingScore" 'class="form-control points" id="test.passingScore"' />
                        <@spring.showErrors "<br>" "error text-danger" />
                    </div>
                </div>
            </div>
            <h3 class="text-center mb-4"><@spring.message code="test.final.edit.questions.listTitle"/></h3>
            <#if 0 < test.questions?size>
                <#list (test.questions)![] as question>
                    <div class="col-lg-8 col-md-8" id="questionId-${question?index}">
                        <div class="feature-card">
                            <#if question?index != 0>
                                <div class="text-end" id="question-${question?index}-btnDiv">
                                    <button type="button" class="btn btn-outline-danger"
                                            onclick="deleteQuestionFromEdit('questionId-${question?index}', ${question?index})"
                                            id="delete-question-${question?index}"
                                            title="<@spring.message code='test.final.edit.question.delete.title'/>">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <label for="questions[${question?index}].question"
                                       class="form-label fw-bold"><@spring.message code="test.final.edit.question.text.label"/>
                                    <span class="text-danger"><@spring.message code="test.final.edit.question.text.required"/></span></label>
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
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3" placeholder="' + springMacroRequestContext.getMessage("test.final.edit.option.placeholder") + '" aria-describedby="delete-question-${question?index}-option-${option?index}" id="questions[${question?index}].options[${option?index}].optionText"' />
                                                    <button class="btn btn-outline-danger"
                                                            type="button"
                                                            id="delete-question-${question?index}-option-${option?index}"
                                                            onclick="deleteOptionFromEdit('questionId-${question?index}-optionId-${option?index}', ${question?index}, ${option?index}, 'option-${option?index}-error')"
                                                            title="<@spring.message code='test.final.edit.option.delete.title'/>">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </div>
                                            <#else>
                                                <div class="flex-grow-1 me-0"
                                                     id="question-${question?index}-option-${option?index}-inputBlock">
                                                    <@spring.formInput "test.questions[${question?index}].options[${option?index}].optionText" 'class="form-control me-3" placeholder="' + springMacroRequestContext.getMessage("test.final.edit.option.placeholder.required") + '" aria-describedby="delete-question-${question?index}-option-${option?index}" id="questions[${question?index}].options[${option?index}].optionText"' />
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
                                        <@spring.message code="test.final.edit.option.add"/>
                                    </button>
                                </div>
                            </#if>
                            <div class="mb-3">
                                <@spring.formCheckbox "test.questions[${question?index}].isRequired" 'class="form-check-input fs-4"'/>
                                <label for="questions[${question?index}].isRequired"
                                       class="form-label fw-bold mx-2"><@spring.message code="test.final.edit.question.required.label"/></label>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="questions[${question?index}].id" value="${question.id!}">
                    <input type="hidden" name="questions[${question?index}].testId" value="${question.testId!}">
                </#list>
            </#if>

            <div class=" mb-3 col-lg-8 col-md-8" id="createQuestionContainer">
                <div class="row">
                    <div class="col-12 col-md-6 col-lg-3 mb-3 d-flex align-items-center">
                        <@spring.formCheckbox "test.isActive" 'class="form-check-input fs-4 ms-3"'/>
                        <label class="form-check-label fw-bold"
                               for="test.isActive"><@spring.message code="test.final.edit.test.active.label"/></label>
                    </div>
                    <div class="col-12 col-md-6 col-lg-9 mb-3 d-flex justify-content-end flex-wrap gap-2">
                        <button type="button" class="btn btn-primary-custom dropdown-toggle me-3" id="createQuestion"
                                data-bs-toggle="dropdown">
                            <@spring.message code="test.final.edit.button.addQuestions"/>
                        </button>
                        <ul class="dropdown-menu">
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(1, ${test.id})"><@spring.message code="test.final.edit.add.count.1"/></li>
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(3, ${test.id})"><@spring.message code="test.final.edit.add.count.3"/></li>
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(5, ${test.id})"><@spring.message code="test.final.edit.add.count.5"/></li>
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(10, ${test.id})"><@spring.message code="test.final.edit.add.count.10"/></li>
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(15, ${test.id})"><@spring.message code="test.final.edit.add.count.15"/></li>
                            <li class="dropdown-item"
                                onclick="createQuestionBlock(20, ${test.id})"><@spring.message code="test.final.edit.add.count.20"/></li>
                        </ul>
                        <button type="submit"
                                class="btn btn-primary-custom me-3"><@spring.message code="test.final.edit.button.save"/></button>
                    </div>
                </div>
            </div>
            <input type="hidden" name="id" value="${test.id}">
            <#if _csrf??>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </#if>
            <input type="hidden" name="courseInstanceId" value="${test.courseInstanceId}">
        </div>
    </form>
    <script>
        let pointsInput = document.querySelectorAll(".points")
        let form = document.getElementById("edit-test")
    </script>
    <script src="/static/js/test_form_validation_error.js"></script>
    <script src="/static/js/test_form_validation.js"></script>
    <script src="/static/js/test_form.js"></script>
</@page>
