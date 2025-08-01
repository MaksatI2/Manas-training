<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "${result.testInstance.courseInstance.title}", "url": "/teacher/courses/${result.testInstance.courseInstance.id}"},
    {"label": "Результаты по тесту: ${test.title}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Результаты прохождения итогового теста "${test.title}"</h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10 col-md-10">
            <div class="mb-3 text-end">
            </div>
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3"><span
                                class="fw-bold">${test.title}</h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3">${test.description}</p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3"><span class="fw-bold">Количество вопросов:</span> ${test.questions?size}
                    </p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3"><span class="fw-bold">Набрано баллов: </span>${result.totalPoints}
                        из ${test.passingScore}
                    </p>
                        <p class="card-text fs-5 fw-bold">
                            Итоговый результат:
                            <#if result.isPassed>
                                <span class="text-success">Успешно пройден</span>
                            <#else>
                                <span class="text-danger">Не пройден</span>
                            </#if>
                        </p>
                </div>
            </div>
            <h3 class="text-center mb-4">Ваши ответы</h3>
            <#list test.questions as question>
                <#if question?? && question.isRequired>
                    <#assign userAnswer = answers?filter(a -> a.questionId == question.id)?first>
                    <div class="feature-card">
                        <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3">Вопрос
                            №${question?index+1}</h4>
                        <h5 class="card-title mb-3 fs-4">${question.question}</h5>
                        <ul class="list-group">
                            <#list question.options as option>
                                <#if option??>
                                    <li class="list-group-item border-primary-subtle fs-5">
                                        <#if option.isCorrect>
                                            <i class="fa-solid fa-check text-success"></i>
                                        <#else>
                                            <i class="fa-solid fa-xmark text-danger"></i>
                                        </#if>
                                        ${option.optionText}
                                        <#if userAnswer?? && option.id == userAnswer.answerId>
                                            <span class="fw-bold <#if option.isCorrect>text-success<#else>text-danger</#if>">
                                                Ваш ответ (Баллов: ${userAnswer.points})
                                            </span>
                                        </#if>
                                    </li>
                                </#if>
                            </#list>
                        </ul>
                    </div>
                </#if>
            </#list>
            Lorem ipsum dolor sit amet, consectetur adipisicing.
        </div>
    </div>
</@page>