<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/student/my-courses"},
    {"label": "${results.testInstance.courseInstance.title}", "url": "/student/course/${results.testInstance.courseInstance.id}"},
    {"label": "Результаты теста по итогам курса ${results.testInstance.courseInstance.title}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Результаты прохождения теста</h1>
    </div>

    <div class="container">
        <div class="card-wrapper">
            <div class="feature-card">
                <#if results.isPassed>
                    <h4 class="text-success result-header">Поздравляем, вы успешно окончили курс!</h4>
                <#else>
                    <h4 class="text-danger result-header">Вы не набрали нужного количества баллов</h4>
                </#if>
                <div class="row mb-3    ">
                    <div class="col">
                        <p><span>Количество вопросов в тесте:</span> ${results.questionsCount}</p>
                        <p><span>Правильных ответов:</span> ${results.correctAnswersCount}</p>
                        <p><span>Неправильных ответов:</span> ${results.wrongAnswersCount}</p>
                    </div>
                    <div class="col">
                        <p><span>Количество набранных баллов:</span> ${results.totalPoints} из 100</p>
                        <p><span>Проходной балл:</span> ${results.testInstance.test.passingScore}</p>
                        <p><span>Затрачено времени на прохождение:</span> ${results.passingTime} минут</p>
                    </div>
                </div>
                <div class="text-center">
                    <a class="btn btn-primary rounded-pill fs-5 p-3" href="/student/course/${results.testInstance.courseInstance.id}">Вернуться к курсу</a>
                </div>
            </div>
        </div>
    </div>
    <style>
        .container {
            display: flex;
            justify-content: center;
            margin: 0 auto;
            padding: 30px;
        }
        .card-wrapper {
            width: 100%;
            max-width: 1000px;
        }
        .feature-card {
            background-color: #ffffff;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            border-left: 6px solid #0066cc;
        }
        .result-header {
            text-align: center;
            margin-bottom: 32px;
            font-weight: bold;
            font-size: 2rem;
            line-height: 1.4;
        }
        .text-success {
            color: #28a745;
        }
        .text-danger {
            color: #dc3545;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            gap: 32px;
        }
        .col {
            flex: 1;
            min-width: 250px;
        }
        .col p {
            font-size: 1.375rem;
            margin-bottom: 16px;
            line-height: 1.5;
        }
        .col span {
            font-weight: bold;
            color: #0066cc;
        }
    </style>
</@page>