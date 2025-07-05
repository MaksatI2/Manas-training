<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Тест #${test.id}", "url": "/test/${test.id}/passing"},
    {"label": "Результаты", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Результаты прохождения теста</h1>
    </div>

    <div class="row justify-content-center" id="test">
        <div class="col-lg-10 col-md-10">
            <div class="feature-card">
                <#if results.isPassed>
                    <h4 class="text-success text-center">Поздравляем вы успешно окончили курс</h4>
                    <#else>
                        <h4 class="text-danger text-center">Вы не набрали нужного количества баллов</h4>
                </#if>
                <p>Количество вопросов в тесте: ${results.questionsCount}</p>
                <p>Правильных ответов: ${results.correctAnswersCount}</p>
                <p>Неправильных ответов: ${results.wrongAnswersCount}</p>
                <p>Не отвеченных: ${results.withoutAnswersCount}</p>
                <p>Количество набраных баллов: ${results.totalPoints} из 100</p>
                <p>Затрачено времени на прохождение: ${results.passingTime} минут</p>
        </div>
    </div>
</@page>