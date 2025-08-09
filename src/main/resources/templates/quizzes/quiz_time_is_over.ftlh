<#import "/spring.ftl" as spring />
<#include "../layout.ftlh">
<#import "../RoadMap.ftlh" as roadmap>
<@page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": "/student/my-courses"},
    {"label": "${lesson.courseModule.courseInstance.title}", "url": "/student/course/${lesson.courseModule.courseInstance.id}"},
    {"label": "Урок #${lesson.title}", "url": "/lessons/${lesson.id}"},
    {"label": "Тест: ${quiz.title}", "url": "/quiz/${quiz.id}/passing"},
    {"label": "Время истекло", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fa-solid fa-list-check"></i> Тест по результатам урока "${quiz.lesson.title}"</h1>
    </div>
    <div class="card mx-auto">
        <div class="card-header bg-primary text-white">
            <h1 class="mb-0">Время истекло</h1>
        </div>
        <div class="card-body">
            <div class="mb-5">
                <h2 class="h4 fw-bold mb-2">У Вас закончилось время</h2>
                <p class="text-muted mb-0">К сожалению, время на прохождение теста истекло. Вы можете вернуться к уроку
                    или попробовать пройти тест еще раз.</p>
            </div>
            <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
                <a href="/lessons/${quiz.lessonId}" class="btn btn-primary rounded-pill">
                    <i class="fa-solid fa-arrow-left"></i> Вернуться к уроку
                </a>
                <a href="/quiz/${quiz.id}/passing" class="btn btn-primary rounded-pill">
                    <i class="fa-solid fa-list-check"></i> Пройти тест еще раз
                </a>
            </div>
        </div>
    </div>
    <style>
        .card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 800px;
            width: 100%;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 32px rgba(0, 0, 0, 0.25);
        }

        .card-header {
            background: linear-gradient(90deg, #0066cc, #004d99);
            padding: 15px;
            border-bottom: none;
        }

        .card-header h1 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.02em;
        }

        .card-body {
            padding: 20px;
        }

        .btn-primary {
            background-color: #0066cc;
            border-color: #0066cc;
            padding: 0.875rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #004d99;
            border-color: #004d99;
            transform: translateY(-3px);
        }

        .btn-primary i {
            margin-right: 0.75rem;
        }

        @media (max-width: 768px) {
            .card-header {
                padding: 15px;
            }

            .card-header h1 {
                font-size: 1.75rem;
            }

            .card-body {
                padding: 2rem;
            }

            .btn-group .btn {
                margin: 0.5rem 0;
                width: 100%;
                font-size: 1rem;
            }
        }

        @media (max-width: 576px) {
            .card {
                margin: 1.5rem;
            }

            .card-header {
                padding: 1.25rem;
            }

            .card-header h1 {
                font-size: 1.5rem;
            }

            .card-body {
                padding: 1.5rem;
            }
        }
    </style>
</@page>