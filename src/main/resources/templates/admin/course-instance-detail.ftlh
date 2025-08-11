<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome    = springMacroRequestContext.getMessage("courseInstances.admin.detail.breadcrumb.home")>
<#assign bcList    = springMacroRequestContext.getMessage("courseInstances.admin.detail.breadcrumb.list")>
<#assign bcCurrent = springMacroRequestContext.getMessage("courseInstances.admin.detail.breadcrumb.current", [courseInstance.id])>


<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcList, "url": "/admin/course-instances"},
    {"label": bcCurrent, "url": ""}
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
            <@spring.message code="courseInstances.admin.detail.course"/>:
            <strong>${courseInstance.courseTitle!'-'}</strong> |
            <@spring.message code="courseInstances.admin.detail.category"/>:
            <strong>${courseInstance.category!'-'}</strong>
        </p>
        <p class="hero-subtitle">
            <@spring.message code="courseInstances.admin.detail.startDate"/>:
            <strong>${courseInstance.formattedStartDate}</strong> |
            <@spring.message code="courseInstances.admin.detail.endDate"/>:
            <strong>${courseInstance.formattedEndDate}</strong> |
            <@spring.message code="courseInstances.admin.detail.status"/>:
            <strong>
                <#if courseInstance.isActive>
                    <@spring.message code="courseInstances.admin.detail.status.active"/>
                <#else>
                    <@spring.message code="courseInstances.admin.detail.status.completed"/>
                </#if>
            </strong>
        </p>
    </div>

    <div class="d-flex flex-wrap align-items-center gap-2 mb-4">
        <a href="<@spring.url '/admin/course-instances/${courseInstance.id}/modules'/>" class="btn btn-primary">
            <@spring.message code="courseInstances.admin.detail.button.modules"/>
        </a>
        <a href="<@spring.url '/admin/course-instances/${courseInstance.id}/participants'/>" class="btn btn-primary">
            <@spring.message code="courseInstances.admin.detail.button.participants"/>
        </a>
        <a href="<@spring.url '/admin/course-instances/${courseInstance.id}/teachers'/>" class="btn btn-primary">
            <@spring.message code="courseInstances.admin.detail.button.teachers"/>
        </a>
        <a href="<@spring.url '/teacher/course/${courseInstance.id}/statistics'/>" class="btn btn-primary">
            <@spring.message code="courseInstances.admin.detail.button.statistics"/>
        </a>
    </div>

    <div class="container">
        <h2><@spring.message code="courseInstances.admin.detail.modules.header"/></h2>
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
                                    ${module.title} (${module.durationHours} ч.)
                                </button>
                                <a href="<@spring.url '/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new'/>"
                                   class="btn btn-primary btn-sm ms-3 lesson-btn d-none d-sm-block">
                                    <@spring.message code="courseInstances.admin.detail.modules.addLesson"/>
                                </a>
                            </div>
                            <div id="collapse${module.id}" class="accordion-collapse collapse"
                                 aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                <div class="accordion-body">
                                    <#if module.description?has_content>
                                        <p class="card-text text-muted small text-break">
                                            ${module.description}
                                        </p>
                                    </#if>
                                    <a href="<@spring.url '/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new'/>"
                                       class="btn btn-primary btn-sm lesson-btn d-sm-none mb-3">
                                        <@spring.message code="courseInstances.admin.detail.modules.addLesson"/>
                                    </a>
                                    <h5><@spring.message code="courseInstances.admin.detail.modules.lessons"/></h5>
                                    <#if module.lessons?has_content>
                                        <div class="row row-cols-1 row-cols-md-2 g-3">
                                            <#list module.lessons as lesson>
                                                <div class="col">
                                                    <a href="<@spring.url '/lessons/${lesson.id}'/>"
                                                       class="text-decoration-none">
                                                        <div class="card h-100 shadow-sm">
                                                            <div class="card-body">
                                                                <h6 class="card-title">${lesson.title}</h6>
                                                                <p class="card-text text-muted small text-break">
                                                                    ${module.description!''}
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </a>
                                                </div>
                                            </#list>
                                        </div>
                                    <#else>
                                        <p><@spring.message code="courseInstances.admin.detail.modules.lessons.empty"/></p>
                                    </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <p><@spring.message code="courseInstances.admin.detail.modules.empty"/></p>
        </#if>

        <h2>Тестирование</h2>
        <div class="feature-card mb-3">
            <#if testInstance?has_content>
                <p>Тест назначенный на данный поток: <span class="fw-bold">${testInstance.test.title}</span></p>
                <p>
                    <@spring.message code="courseInstances.admin.detail.startDate"/>:
                    <span class="fw-bold">${startDate} ${testInstance.startTime}</span> |
                    <@spring.message code="courseInstances.admin.detail.endDate"/>:
                    <span class="fw-bold">${endDate} ${testInstance.endTime}</span>
                </p>
                <a href="/instance/${courseInstance.id}/change-time" class="btn btn-warning mb-2">Изменить время доступа
                    к тесту</a>
            <#else>
                <p>На данный поток пока не был назначен тест.</p>
            </#if>
        </div>
    </div>

    <style>
        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
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

        .accordion-body, .card-text {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
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
    </style>
</@layout.page>
