<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<@page>
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-ballot-check"></i>Тест по пройденому материалу</h1>
        <p class="hero-subtitle">Тестирование по полученным знаниям в течении пройденного урока</p>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-10 col-md-10">
            <div class="feature-card">
                <div class="feature-card">
                    <div class="card-body">
                        <h5 class="card-title fs-3 mb-3">Тест по теме: ${test.title}</h5>
                        <p class="card-text fs-4">${test.description}</p>
                        <p class="card-text fs-5">Количество вопросов: ${test.questions?size}</p>
                    </div>
                </div>
                <form action="/test/checking" method="post">
                    <#if test.questions??>
                        <#list test.questions as question>
                            <div class="feature-card">
                                <div class="card-body px-4">
                                    <h4 class="card-title mb-3">Вопрос №${question?index+1}</h4>
                                    <h5 class="card-title mb-3">${question.question}</h5>
                                    <#if question.options??>
                                        <#list question.options as option>
                                            <div class="form-check">
                                                <input class="form-check-input fs-4" type="radio"
                                                       name="questionAnswers[${question?index}].answerId"
                                                       id="question-${question?index}-option-${option?index}" value="${option.id}">
                                                <label class="form-check-label fs-4"
                                                       for="question-${question?index}-option-${option?index}">
                                                    ${option.optionText}
                                                </label>
                                                <input type="hidden" name="questionAnswers[${question?index}].questionId"
                                                       value="${question.id}">
                                                <input type="hidden" name="questionAnswers[${question?index}].points"
                                                       value="${question.points}">
                                            </div>
                                        </#list>
                                    </#if>
                                </div>
                            </div>
                        </#list>
                    </#if>
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>
                    <input type="hidden" name="testId" value="${test.id}">
                    <input type="hidden" name="passingStart" value="${passing_start}">
                    <div class="text-center">
                        <input type="submit" class="btn btn-primary-custom w-75" value="Отправить">
                    </div>
                </form>
            </div>
        </div>
    </div>
</@page>