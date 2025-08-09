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
                    <h4 class="text-success result-header"><i class="fa-solid fa-check-circle"></i> Поздравляем, Вы успешно окончили курс!</h4>
                <#else>
                    <h4 class="text-danger result-header"><i class="fa-solid fa-xmark-circle"></i> Вы не набрали нужного количества баллов</h4>
                </#if>

                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fa-solid fa-question"></i>
                        <p>Вопросов в тесте</p>
                        <h3>${results.questionsCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-check"></i>
                        <p>Правильных ответов</p>
                        <h3>${results.correctAnswersCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-xmark"></i>
                        <p>Неправильных ответов</p>
                        <h3>${results.wrongAnswersCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-star"></i>
                        <p>Набрано баллов</p>
                        <h3>${results.totalPoints} / 100</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-flag-checkered"></i>
                        <p>Проходной балл</p>
                        <h3>${results.testInstance.test.passingScore}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-clock"></i>
                        <p>Время затраченное на прохождение теста в минутах -</p>
                        <h3>${results.passingTime} мин</h3>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a class="btn btn-primary rounded-pill fs-5 p-3" href="/student/course/${results.testInstance.courseInstance.id}">Вернуться к курсу</a>
                </div>
            </div>
        </div>
    </div>

    <style>
        .container {
            display: flex;
            justify-content: center;
            padding: 30px;
        }
        .card-wrapper {
            width: 100%;
            max-width: 1000px;
        }
        .feature-card {
            background-color: #ffffff;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 24px;
        }
        .stat-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .stat-card i {
            font-size: 1.8rem;
            color: #0066cc;
            margin-bottom: 12px;
        }
        .stat-card p {
            margin: 0;
            font-size: 1rem;
            color: #6c757d;
        }
        .stat-card h3 {
            margin-top: 8px;
            font-size: 1.5rem;
            color: #343a40;
        }
        .text-center.mt-4 {
            margin-top: 32px;
        }
    </style>
</@page>
