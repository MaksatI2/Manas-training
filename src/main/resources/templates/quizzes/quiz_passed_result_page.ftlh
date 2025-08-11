<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome><@spring.message code='student.quizResult.breadcrumb.home'/></#assign>
<#assign bcMy><@spring.message code='student.quizResult.breadcrumb.myCourses'/></#assign>
<#assign bcCourse>${springMacroRequestContext.getMessage("student.quizResult.breadcrumb.courseTitle", [results.quiz.lesson.courseModule.courseInstance.title], "Курс: " + results.quiz.lesson.courseModule.courseInstance.title)}</#assign>
<#assign bcLesson>${springMacroRequestContext.getMessage("student.quizResult.breadcrumb.lessonTitle", [results.quiz.lesson.title], "Урок: " + results.quiz.lesson.title)}</#assign>
<#assign bcResults><@spring.message code='student.quizResult.breadcrumb.results'/></#assign>

<@page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMy, "url": "/student/my-courses"},
    {"label": bcCourse, "url": "/student/course/${results.quiz.lesson.courseModule.courseInstance.id}"},
    {"label": bcLesson, "url": "/lessons/${results.quiz.lesson.id}"},
    {"label": bcResults, "url": ""}
    ] />

    <div class="hero-section">
        <h1 class="hero-title"><i
                    class="fa-solid fa-list-check"></i> <@spring.message code='student.quizResult.page.title'/></h1>
    </div>

    <div class="container">
        <div class="card-wrapper">
            <div class="feature-card">
                <h4 class="result-header text-success">
                    <i class="fa-solid fa-check-circle"></i> <@spring.message code='student.quizResult.passed.title'/>
                </h4>

                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fa-solid fa-question"></i>
                        <p><@spring.message code='student.quizResult.stats.questions'/></p>
                        <h3>${results.questionsCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-check"></i>
                        <p><@spring.message code='student.quizResult.stats.correct'/></p>
                        <h3>${results.correctAnswersCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-xmark"></i>
                        <p><@spring.message code='student.quizResult.stats.wrong'/></p>
                        <h3>${results.wrongAnswersCount}</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-star"></i>
                        <p><@spring.message code='student.quizResult.stats.points'/></p>
                        <h3>${results.totalPoints} / 100</h3>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-clock"></i>
                        <p><@spring.message code='student.quizResult.stats.timeLabel'/></p>
                        <h3>${springMacroRequestContext.getMessage("student.quizResult.stats.timeValue", [results.passingTime], results.passingTime + " мин")}</h3>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a class="btn btn-primary rounded-pill fs-5 p-3"
                       href="/lessons/${results.quiz.lesson.id}"><@spring.message code='student.quizResult.btn.backToLesson'/></a>
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
            background: #fff;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, .1);
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
            grid-template-columns:repeat(auto-fit, minmax(220px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }

        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0, 0, 0, .05);
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
