<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>

<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/student/my-courses"},
    {"label": "${results.quiz.lesson.courseModule.courseInstance.title}", "url": "/student/course/${results.quiz.lesson.courseModule.courseInstance.id}"},
    {"label": "Урок: ${results.quiz.lesson.title}", "url": "/lessons/${results.quiz.lesson.id}"},
    {"label": "Результаты тестирования", "url": ""}
    ] />

    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Результаты прохождения теста</h1>
    </div>

    <div class="container">
        <div class="card-wrapper">
            <div class="feature-card">
                <h4 class="result-header text-success">
                    <i class="fa-solid fa-check-circle"></i> Тест успешно пройден!
                </h4>

                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fa-solid fa-question"></i>
                        <p>Количество вопросов</p>
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
                        <i class="fa-solid fa-clock"></i>
                        <p>Затраченное время</p>
                        <h3>${results.passingTime} мин</h3>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a class="btn btn-primary rounded-pill fs-5 p-3" href="/lessons/${results.quiz.lesson.id}">Вернуться к уроку</a>
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 24px;
            margin-top: 24px;
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
