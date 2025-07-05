<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring/>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "${userRole}/Мои курсы", "url": "/${userRole}/my-courses"},
    {"label": "Курс #${courseInstance.id}", "url": ""}
    ] />
    <div class="hero-section">
        <h1 class="hero-title"><i class="fas fa-book me-2"></i>${courseInstance.title}</h1>
        <p class="hero-subtitle">
            Курс: <strong>${courseInstance.courseTitle!'-'}</strong> |
            Категория: <strong>${courseInstance.category!'-'}</strong>
        </p>
        <p class="hero-subtitle">
            Начало: ${courseInstance.startDate} |
            Окончание: ${courseInstance.endDate} |
            Статус: <#if courseInstance.isActive>Активен<#else>Завершен</#if>
        </p>
    </div>

    <div class="container mt-4">
        <h2>Модули курса</h2>

        <#if courseInstance.modules?has_content>
            <div class="accordion" id="modulesAccordion">
                <#list courseInstance.modules as module>
                    <div class="feature-card mb-3">
                        <div class="accordion-item">
                            <div class="d-flex justify-content-between align-items-center px-3 py-2 bg-light rounded-top">
                                <button class="accordion-button collapsed flex-grow-1 text-start" type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse${module.id}" aria-expanded="false"
                                        aria-controls="collapse${module.id}">
                                    ${module.title} (Продолжительность: ${module.durationHours} ч.)
                                </button>
                            </div>
                            <div id="collapse${module.id}" class="accordion-collapse collapse"
                                 aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                <div class="accordion-body">
                                    <p>${module.description!''}</p>
                                    <h5>Уроки</h5>
                                    <#if module.lessons?has_content>
                                        <div class="row row-cols-1 row-cols-md-2 g-3">
                                            <#list module.lessons as lesson>
                                                <div class="col">
                                                    <a href="<@spring.url '/lessons/${lesson.id}'/>" class="text-decoration-none">
                                                        <div class="card h-100 shadow-sm">
                                                            <div class="card-body">
                                                                <h6 class="card-title">${lesson.title}</h6>
                                                                <p class="card-text text-muted small">
                                                                    ${lesson.description!''}
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </a>
                                                </div>
                                            </#list>
                                        </div>
                                    <#else>
                                        <p>Уроки отсутствуют</p>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <p>Модули отсутствуют</p>
        </#if>
    </div>

    <style>
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .feature-card {
            background-color: #fff;
            border-radius: 0.375rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .accordion-button {
            font-weight: 500;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.2s ease-in-out;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 500;
        }

        .card-text {
            font-size: 0.875rem;
        }
    </style>
</@layout.page>
