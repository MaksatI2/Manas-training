<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring/>
<#import "../RoadMap.ftlh" as roadmap>

<#assign bcHome><@spring.message code='teacher.course.detail.breadcrumb.home'/></#assign>
<#assign bcMy><@spring.message code='teacher.course.detail.breadcrumb.myCourses'/></#assign>
<#assign bcCourse = courseInstance.title>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>
    <div class="page-wrapper">
        <@roadmap.breadcrumbs items=[
        {"label": bcHome, "url": "/"},
        {"label": bcMy, "url": "/teacher/my-courses"},
        {"label": bcCourse, "url": ""}
        ] />



        <div class="container main-layout">
            <main class="main-content">
                <header class="hero-section">
                    <h1 class="hero-title"><i class="fas fa-book me-2"></i>${courseInstance.title}</h1>
                    <div class="hero-info">
                        <div class="hero-info-item">
                            <span class="hero-label"><@spring.message code="courseInstances.admin.detail.course"/>:</span>
                            <span class="hero-value">${courseInstance.courseTitle!'-'}</span>
                        </div>
                        <div class="hero-info-item">
                            <span class="hero-label"><@spring.message code="courseInstances.admin.detail.category"/>:</span>
                            <span class="hero-value">${courseInstance.category!'-'}</span>
                        </div>
                        <div class="hero-info-item">
                            <span class="hero-label"><@spring.message code="courseInstances.admin.detail.startDate"/>:</span>
                            <span class="hero-value">${courseInstance.formattedStartDate}</span>
                        </div>
                    </div>
                    <div class="course-controls">
                        <a href="<@spring.url '/teacher/course/${courseInstance.id}/statistics'/>" class="btn btn-primary btn-icon">
                            <i class="fas fa-chart-bar"></i><@spring.message code='teacher.course.detail.btn.statistics'/>
                        </a>
                        <a href="/courses/${courseInstance.id}/tests" class="btn btn-primary btn-icon">
                            <i class="fas fa-list"></i><@spring.message code='teacher.course.detail.btn.tests'/>
                        </a>
                    </div>
                </header>

                <section class="modules-section">
                    <h2 class="section-title"><@spring.message code='teacher.course.detail.modules.title'/></h2>
                    <#if courseInstance.modules?has_content>
                        <div class="accordion" id="modulesAccordion">
                            <#list courseInstance.modules as module>
                                <div class="accordion-item glass-effect">
                                    <div class="accordion-header">
                                        <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#collapse${module.id}"
                                                aria-expanded="false"
                                                aria-controls="collapse${module.id}">
                                            <span class="module-title">${module.title}</span>
                                            <span class="module-duration">(${springMacroRequestContext.getMessage("teacher.course.detail.modules.duration", [module.durationHours], module.durationHours + " ч.")})</span>
                                        </button>
                                        <a href="<@spring.url '/course-instances/${courseInstance.id}/modules/${module.id}/lessons/new'/>"
                                           class="btn btn-primary btn-icon lesson-btn">
                                            <@spring.message code='teacher.course.detail.modules.addLesson'/>
                                        </a>
                                    </div>
                                    <div id="collapse${module.id}" class="accordion-collapse collapse"
                                         aria-labelledby="heading${module.id}" data-bs-parent="#modulesAccordion">
                                        <div class="accordion-body">
                                            <p class="module-description">${module.description!''}</p>
                                            <h5 class="lessons-title"><@spring.message code='teacher.course.detail.modules.lessons'/></h5>
                                            <#if module.lessons?has_content>
                                                <div class="lessons-grid">
                                                    <#list module.lessons as lesson>
                                                        <a href="<@spring.url '/lessons/${lesson.id}'/>"
                                                           class="lesson-card glass-effect">
                                                            <h6 class="lesson-title">${lesson.title}</h6>
                                                            <p class="lesson-description">${lesson.description!''}</p>
                                                        </a>
                                                    </#list>
                                                </div>
                                            <#else>
                                                <div class="empty-state"><@spring.message code='teacher.course.detail.modules.lessons.empty'/></div>
                                            </#if>
                                        </div>
                                    </div>
                                </div>
                            </#list>
                        </div>
                    <#else>
                        <div class="empty-state glass-effect"><@spring.message code='teacher.course.detail.modules.empty'/></div>
                    </#if>
                </section>

                <section class="test-section">
                    <h2 class="section-title"><@spring.message code='teacher.course.detail.testing.title'/></h2>
                    <div class="test-card glass-effect">
                        <#if testInstance?has_content>
                            <h3 class="test-title">${springMacroRequestContext.getMessage("teacher.course.detail.testing.assigned", [testInstance.test.title], "Тест: " + testInstance.test.title)}</h3>
                            <p class="test-info">${springMacroRequestContext.getMessage("teacher.course.detail.testing.start", [startDate + " " + testInstance.startTime], "Начало: " + startDate + " " + testInstance.startTime)}</p>
                            <p class="test-info">${springMacroRequestContext.getMessage("teacher.course.detail.testing.end", [endDate + " " + testInstance.endTime], "Окончание: " + endDate + " " + testInstance.endTime)}</p>
                            <#if hasResults>
                                <p class="test-info text-danger"><@spring.message code='teacher.course.detail.testing.resultsExist'/></p>
                            <#else>
                                <a href="/instance/${courseInstance.id}/change/test" class="btn btn-warning btn-icon">
                                    <i class="fas fa-edit"></i><@spring.message code='teacher.course.detail.testing.changeTest'/>
                                </a>
                                <a href="/instance/${courseInstance.id}/delete/test" class="btn btn-danger btn-icon">
                                    <i class="fas fa-trash"></i><@spring.message code='teacher.course.detail.testing.unassignTest'/>
                                </a>
                            </#if>
                        <#else>
                            <div class="empty-state"><@spring.message code='teacher.course.detail.testing.notAssigned'/></div>
                            <a href="/instance/${courseInstance.id}/test" class="btn btn-primary btn-icon">
                                <i class="fas fa-plus"></i><@spring.message code='teacher.course.detail.testing.assignTest'/>
                            </a>
                        </#if>
                    </div>
                </section>
            </main>
        </div>
    </div>

    <style>
        :root {
            --primary: #0066cc;
            --primary-dark: #003d7a;
            --secondary: #6b7280;
            --background: #f9fafb;
            --card-bg: rgba(255, 255, 255, 0.9);
            --text: #111827;
            --success: #22c55e;
            --danger: #ef4444;
            --warning: #f59e0b;
        }

        body {
            background: var(--background);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: var(--text);
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            padding: 1.5rem 0;
        }

        .main-layout {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .main-content {
            flex: 1;
        }

        .hero-section {
            background: linear-gradient(145deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            margin-bottom: 2rem;
            text-align: center;
        }

        .hero-title {
            font-size: 2.25rem;
            font-weight: 700;
            margin: 0 0 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .hero-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            font-size: 1rem;
            margin-bottom: 1.5rem;
            padding: 0 1rem;
        }

        .hero-info-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.25rem;
        }

        .hero-label {
            font-size: 0.95rem;
            color: var(--primary);
            font-weight: 500;
        }

        .hero-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--primary);
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .course-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            justify-content: center;
        }

        .section-title {
            font-size: 1.75rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text);
        }

        .glass-effect {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-effect:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }

        .accordion-item {
            border: none;
            margin-bottom: 1rem;
        }

        .accordion-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            background: var(--card-bg);
            padding: 1rem;
            border-radius: 1rem;
        }

        .accordion-button {
            background: none;
            border: none;
            font-size: 1.15rem;
            font-weight: 500;
            color: var(--text);
            flex-grow: 1;
            text-align: left;
            padding: 0;
            display: flex;
            gap: 0.75rem;
            align-items: center;
            cursor: pointer;
        }

        .accordion-button:not(.collapsed) {
            color: var(--primary);
        }

        .module-title {
            flex-grow: 1;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .module-duration {
            font-size: 0.95rem;
            color: var(--secondary);
        }

        .accordion-body {
            padding: 1.5rem;
            background: var(--card-bg);
            border-radius: 0 0 1rem 1rem;
            word-break: break-all;
            overflow-wrap: anywhere;
        }

        .module-description {
            font-size: 0.95rem;
            color: var(--secondary);
            margin-bottom: 1.25rem;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .lessons-title {
            font-size: 1.3rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }

        .lessons-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1rem;
        }

        .lesson-card {
            display: block;
            text-decoration: none;
            color: inherit;
            padding: 1.25rem;
            border-radius: 0.75rem;
            transition: transform 0.2s ease;
        }

        .lesson-card:hover {
            transform: translateY(-2px);
        }

        .lesson-title {
            font-size: 1.15rem;
            font-weight: 500;
            margin: 0 0 0.5rem;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .lesson-description {
            font-size: 0.9rem;
            color: var(--secondary);
            margin: 0;
            word-break: break-all;
            overflow-wrap: anywhere;
            max-width: 100%;
        }

        .test-card {
            padding: 1.5rem;
            border-radius: 1rem;
        }

        .test-title {
            font-size: 1.3rem;
            font-weight: 500;
            margin: 0 0 1rem;
            word-break: break-all;
            overflow-wrap: anywhere;
            white-space: normal;
            max-width: 100%;
        }

        .test-info {
            font-size: 0.95rem;
            color: var(--secondary);
            margin: 0.75rem 0;
            word-break: break-all;
            overflow-wrap: anywhere;
            white-space: normal;
            max-width: 100%;
        }

        .empty-state {
            text-align: center;
            padding: 1.5rem;
            color: var(--secondary);
            font-size: 1rem;
            word-break: break-all;
            overflow-wrap: anywhere;
            white-space: normal;
            max-width: 100%;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            border-radius: 0.75rem;
            font-weight: 500;
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: linear-gradient(145deg, var(--primary), var(--primary-dark));
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(145deg, var(--primary-dark), color-mix(in srgb, var(--primary-dark) 85%, black));
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0, 102, 204, 0.3);
        }

        .btn-warning {
            background: var(--warning);
            border: none;
            color: white;
        }

        .btn-warning:hover {
            background: color-mix(in srgb, var(--warning) 85%, black);
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(245, 158, 11, 0.3);
        }

        .btn-danger {
            background: var(--danger);
            border: none;
            color: white;
        }

        .btn-danger:hover {
            background: color-mix(in srgb, var(--danger) 85%, black);
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(239, 68, 68, 0.3);
        }

        .btn-icon {
            padding: 0.6rem 1rem;
        }




        @media (max-width: 768px) {
            .hero-title {
                font-size: 1.75rem;
            }

            .hero-info {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }

            .course-controls {
                flex-direction: column;
                align-items: stretch;
            }

            .lessons-grid {
                grid-template-columns: 1fr;
            }

            .section-title {
                font-size: 1.5rem;
            }

            .btn {
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 576px) {
            .hero-title {
                font-size: 1.5rem;
            }

            .section-title {
                font-size: 1.25rem;
            }

            .accordion-header {
                flex-direction: column;
                align-items: stretch;
                gap: 0.75rem;
            }

            .lesson-btn {
                width: 100%;
                text-align: center;
            }

            .hero-info-item {
                align-items: flex-start;
            }
        }
    </style>
</@layout.page>