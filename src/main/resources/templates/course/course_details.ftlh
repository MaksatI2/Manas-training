<#import "../layout.ftlh" as layout>
<@layout.page>
    <style>
        .course-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .course-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 102, 204, 0.1);
            padding: 2.5rem;
            margin-top: 2rem;
            border-left: 4px solid var(--primary-blue);
            transition: all 0.3s ease;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 102, 204, 0.15);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .detail-item {
            background: rgba(135, 206, 235, 0.05);
            padding: 1.5rem;
            border-radius: 10px;
            border-left: 3px solid var(--light-blue);
        }

        .detail-label {
            font-size: 0.95rem;
            color: var(--dark-blue);
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-value {
            font-size: 1.1rem;
            font-weight: 500;
            padding-left: 1.8rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }
    </style>

    <div class="course-container">
        <h1 class="page-title">
            <i class="fas fa-book me-2" style="color: var(--primary-blue);"></i>
            ${course.title}
        </h1>

        <div class="course-card">
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-code"></i>
                        Код курса
                    </div>
                    <div class="detail-value">${course.code}</div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-clock"></i>
                        Длительность
                    </div>
                    <div class="detail-value">${course.duration} часов</div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fas fa-layer-group"></i>
                        Категория
                    </div>
                    <div class="detail-value">${course.category.name}</div>
                </div>

                <div class="detail-item" style="grid-column: 1 / -1;">
                    <div class="detail-label">
                        <i class="fas fa-align-left"></i>
                        Описание
                    </div>
                    <div class="detail-value">${course.description}</div>
                </div>
            </div>

            <div class="action-buttons">
                <#if canEnroll>
                    <form action="/courses/${course.id}/enroll" method="POST">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>
                            Записаться на курс
                        </button>
                    </form>
                </#if>

                <a href="/courses" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>
                    Вернуться к списку
                </a>
                <a href="#" class="btn btn-outline-primary">Записаться на курс</a>
            </div>
        </div>
    </div>
</@layout.page>