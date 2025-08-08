<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/student/my-courses"},
    {"label": "${courseInstance.title}", "url": "/student/course/${courseInstance.id}"},
    {"label": "Тест: ${test.title}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Итоговый тест курса "${courseInstance.title}"</h1>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-8">
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3">${test.title}</h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3">${test.description}</p>
                    <p class="card-text fs-5"><span class="fw-bold">Количество вопросов:</span> ${test.questions?size}
                    </p>
                </div>
            </div>
            <form action="/test/checking" method="post">
                <#if test.questions??>
                    <#assign bindingResult = .globals["org.springframework.validation.BindingResult.result"]>
                    <#list test.questions as question>
                        <#if result.questionAnswers?has_content>
                            <#assign userAnswer = result.questionAnswers?filter(a -> a.questionId == question.id)?first>
                        </#if>
                        <#if question.isRequired>
                            <div class="feature-card">
                                <div class="card-body px-4">
                                    <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3">
                                        Вопрос №${question?index + 1}
                                        <#if bindingResult?? && bindingResult.hasFieldErrors("questionAnswers[" + question?index + "].answerId")>
                                            <#list bindingResult.getFieldErrors("questionAnswers[" + question?index + "].answerId") as error>
                                                <span class="text-danger">${error.defaultMessage}</span>
                                            </#list>
                                        </#if>
                                    </h4>
                                    <h5 class="card-title mb-3 fs-4">${question.question}</h5>
                                    <#if question.options??>
                                        <ul class="list-group">
                                            <#list question.options as option>
                                                <li class="list-group-item border-primary-subtle fs-5">
                                                    <input class="form-check-input me-1 fs-4" type="radio"
                                                           name="questionAnswers[${question?index}].answerId"
                                                           id="question-${question?index}-option-${option?index}"
                                                           value="${option.id}" <#if userAnswer?? && userAnswer.answerId?? && userAnswer.answerId == option.id> checked </#if>>
                                                    <label class="form-check-label fs-4"
                                                           for="question-${question?index}-option-${option?index}">
                                                        ${option.optionText}
                                                    </label>
                                                </li>
                                            </#list>
                                        </ul>
                                    </#if>
                                </div>
                            </div>
                        </#if>
                        <input type="hidden"
                               name="questionAnswers[${question?index}].questionId"
                               value="${question.id}">
                    </#list>
                </#if>
                <#if _csrf??>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </#if>
                <input type="hidden" name="testId" value="${test.id}">
                <input type="hidden" name="passingStart" value="${passing_start}">
                <input type="hidden" name="testInstanceId" value="${testInstanceId}">
                <div class="text-center">
                    <input type="submit" class="btn btn-primary-custom w-75" value="Отправить ответы">
                </div>
            </form>
        </div>
    </div>
</@page>