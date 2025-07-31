<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/student/my-courses"},
    {"label": "${results.quiz.lesson.courseModule.courseInstance.title}", "url": "/student/course/${results.quiz.lesson.courseModule.courseInstance.id}"},
    {"label": "Урок: ${results.quiz.lesson.title}", "url": "/lessons/${results.quiz.lesson.id}"},
    {'label': "Результаты тестирования", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Результаты прохождения теста</h1>
    </div>

    <div class="container">
        <div class="card-wrapper">
            <div class="feature-card">
                    <h4 class="result-header text-secondary">Тест пройден!</h4>
                <div class="row mb-3">
                    <div class="col">
                        <p><span>Количество вопросов в тесте:</span> ${results.questionsCount}</p>
                        <p><span>Правильных ответов:</span> ${results.correctAnswersCount}</p>
                        <p><span>Неправильных ответов:</span> ${results.wrongAnswersCount}</p>
                    </div>
                    <div class="col">
                        <p><span>Количество набранных баллов:</span> ${results.totalPoints} из 100</p>
                        <p><span>Затрачено времени на прохождение:</span> ${results.passingTime} минут</p>
                    </div>
                </div>
                <div class="text-center">
                    <a class="btn btn-primary rounded-pill fs-5 p-3" href="/lessons/${results.quiz.lesson.id}">Вернуться к уроку</a>
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