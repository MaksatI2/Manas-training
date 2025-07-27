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

    <div class="row justify-content-center" id="test">
        <div class="col-lg-10 col-md-10">
            <div class="feature-card">
                <p class="result-text">Количество вопросов в тесте: ${results.questionsCount}</p>
                <p class="result-text">Правильных ответов: ${results.correctAnswersCount}</p>
                <p class="result-text">Неправильных ответов: ${results.wrongAnswersCount}</p>
                <p class="result-text">Не отвеченных: ${results.withoutAnswersCount}</p>
                <p class="result-text">Количество набраных баллов: ${results.totalPoints} из 100</p>
                <p class="result-text">Затрачено времени на прохождение: ${results.passingTime} минут</p>
            </div>
        </div>
    </div>
</@page>