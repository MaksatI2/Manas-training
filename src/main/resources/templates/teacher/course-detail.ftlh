<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring/>
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome><@spring.message code='teacher.course.detail.breadcrumb.home'/></#assign>
<#assign bcMy><@spring.message code='teacher.course.detail.breadcrumb.myCourses'/></#assign>
<#assign bcCourse>${springMacroRequestContext.getMessage("teacher.course.detail.breadcrumb.course", [courseInstance.title], "Курс #" + courseInstance.title)}</#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMy, "url": "/teacher/my-courses"},
    {"label": bcCourse, "url": ""}
    ] />

    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="hero-section">
        <h1 class="hero-title"><i class="fas fa-book me-2"></i>${courseInstance.title}</h1>
        <p class="hero-subtitle">
            Курс: <strong>${courseInstance.courseTitle!'-'}</strong> |
            Категория: <strong>${courseInstance.category!'-'}</strong>
        </p>
        <p class="hero-subtitle">
            Начало: <strong>${courseInstance.formattedStartDate}</strong> |
            Окончание: <strong>${courseInstance.formattedEndDate}</strong> |
            Статус:
            <strong><#if courseInstance.isActive><@spring.message code='teacher.course.detail.status.active'/><#else><@spring.message code='teacher.course.detail.status.completed'/></#if></strong>
        </p>
    </div>

    <div class="d-flex flex-wrap align-items-center gap-2 mb-4">
        <a href="<@spring.url '/teacher/course/${courseInstance.id}/statistics'/>"
           class="btn btn-primary"><@spring.message code='teacher.course.detail.btn.statistics'/></a>
        <a href="/courses/${courseInstance.id}/tests"
           class="btn btn-primary"><@spring.message code='teacher.course.detail.btn.tests'/></a>
    </div>

    <div class="container mt-4">
        <h2><@spring.message code='teacher.course.detail.modules.title'/></h2>

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
                                    ${module.title}
                                    (${springMacroRequestContext.getMessage("teacher.course.detail.modules.duration", [module.durationHours], "Продолжительность: " + module.durationHours + " ч.")}
                                    )
                                </button>
                                <a href="<@spring.url '/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new'/>"
                                   class="btn btn-primary btn-sm ms-3 lesson-btn d-none d-sm-block">
                                    <@spring.message code='teacher.course.detail.modules.addLesson'/>
                                </a>
                            </div>
                            <div id="collapse${module.id}" class="accordion-collapse collapse"
                                 aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                <div class="accordion-body">
                                    <p>${module.description!''}</p>
                                    <a href="<@spring.url '/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new'/>"
                                       class="btn btn-primary btn-sm lesson-btn d-sm-none mb-3">
                                        <@spring.message code='teacher.course.detail.modules.addLesson'/>
                                    </a>
                                    <h5><@spring.message code='teacher.course.detail.modules.lessons'/></h5>
                                    <#if module.lessons?has_content>
                                        <div class="row row-cols-1 row-cols-md-2 g-3">
                                            <#list module.lessons as lesson>
                                                <div class="col">
                                                    <a href="<@spring.url '/lessons/${lesson.id}'/>"
                                                       class="text-decoration-none">
                                                        <div class="card h-100 shadow-sm">
                                                            <div class="card-body">
                                                                <h6 class="card-title">${lesson.title}</h6>
                                                                <p class="card-text text-muted small">${lesson.description!''}</p>
                                                            </div>
                                                        </div>
                                                    </a>
                                                </div>
                                            </#list>
                                        </div>
                                    <#else>
                                        <p><@spring.message code='teacher.course.detail.modules.lessons.empty'/></p>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <p><@spring.message code='teacher.course.detail.modules.empty'/></p>
        </#if>

        <h2><@spring.message code='teacher.course.detail.testing.title'/></h2>
        <div class="feature-card mb-3">
            <#if testInstance?has_content>
                <p>${springMacroRequestContext.getMessage("teacher.course.detail.testing.assigned", [testInstance.test.title], "Тест назначенный на данный поток: " + testInstance.test.title)}</p>
                <p>
                    ${springMacroRequestContext.getMessage("teacher.course.detail.testing.start", [startDate + " " + testInstance.startTime], "Начало: " + startDate + " " + testInstance.startTime)}
                    | ${springMacroRequestContext.getMessage("teacher.course.detail.testing.end", [endDate + " " + testInstance.endTime], "Окончание: " + endDate + " " + testInstance.endTime)}
                </p>
                <#if hasResults>
                    <p class="text-danger"><@spring.message code='teacher.course.detail.testing.resultsExist'/></p>
                <#else>
                    <a href="/instance/${courseInstance.id}/change/test" class="btn btn-warning mb-2">
                        <@spring.message code='teacher.course.detail.testing.changeTest'/>
                    </a>
                    <a href="/instance/${courseInstance.id}/delete/test" class="btn btn-danger mb-2">
                        <@spring.message code='teacher.course.detail.testing.unassignTest'/>
                    </a>
                </#if>
            <#else>
                <p><@spring.message code='teacher.course.detail.testing.notAssigned'/></p>
                <a href="/instance/${courseInstance.id}/test" class="btn btn-primary mb-2">
                    <@spring.message code='teacher.course.detail.testing.assignTest'/>
                </a>
            </#if>
        </div>
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

        .hero-subtitle {
            color: var(--text-dark);
            font-size: 1.4rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 576px) {
            .lesson-btn {
                width: 100%;
                text-align: center;
                padding: 0.5rem;
                font-size: 0.875rem;
            }

            .accordion-body {
                padding-top: 0.5rem;
            }
        }

        .accordion-body, .card-text {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
        }
    </style>
</@layout.page>
