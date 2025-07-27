<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/teacher/my-courses"},
    {"label": "${instance.title}", "url": "/teacher/courses/${instance.id}"},
    {"label": "Тесты по курсу: ${test.course.title}", "url": "/courses/${test.course.id}/tests"},
    {"label": "Детали теста: ${test.title}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Детали теста "${test.title}"</h1>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10 col-md-10">
            <div class="mb-3 text-end">
                <a href="/test/${test.id}/edit" class="btn btn-warning btn-sm rounded-pill p-2">
                    <i class="fas fa-edit me-1"></i>Редактировать
                </a>
            </div>
            <div class="feature-card">
                <div class="card-body">
                    <h5 class="card-title fs-3 mb-3 border-bottom border-primary-subtle pb-3"><span
                                class="fw-bold">Название теста: </span> ${test.title}</h5>
                    <p class="card-text fs-4 border-bottom border-primary-subtle pb-3"><span class="fw-bold">Описание теста: </span>${test.description}</p>
                    <p class="card-text fs-5 border-bottom border-primary-subtle pb-3"><span class="fw-bold">Количество вопросов:</span> ${test.questions?size}
                    </p>
                    <p class="card-text fs-5"><span class="fw-bold">Проходной балл: </span>${test.passingScore}</p>

                </div>
            </div>
            <h3 class="text-center mb-4">Список вопросов</h3>
            <#list test.questions as question>
                <div class="feature-card">
                    <h4 class="card-title mb-3 border-bottom border-primary-subtle pb-3">Вопрос
                        №${question?index+1} <#if !question.isRequired>(Не активный)</#if></h4>
                    <h5 class="card-title mb-3 border-bottom border-primary-subtle pb-3 fs-4"><span
                                class="fw-bold">Текст вопроса: </span>${question.question}</h5>
                    <h5 class="card-title mb-3 fw-bold">Варианты ответа:</h5>
                    <ul class="list-group">
                        <#list question.options as option>
                            <li class="list-group-item border-primary-subtle fs-5"><#if option.isCorrect><i
                                        class="fa-solid fa-check text-success"></i><#else><i
                                        class="fa-solid fa-xmark text-danger"></i></#if> ${option.optionText}
                            </li>
                        </#list>
                    </ul>
                </div>
            </#list>
        </div>
    </div>
</@page>