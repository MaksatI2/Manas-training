<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>
<#import "../RoadMap.ftlh" as roadmap>

<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getFullName()>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
    <#assign isStudent = roles?contains("STUDENT")>
    <#assign isOrganization = roles?contains("ORGANIZATION")>
    <#assign currentUserId = user.user.id>
    <#assign bcHome><@spring.message code='course.final.tests.list.breadcrumb.home'/></#assign>
    <#assign bcMy><@spring.message code='teacher.course.detail.breadcrumb.myCourses'/></#assign>
    <#assign bcList = springMacroRequestContext.getMessage("breadcrumbs.course.instances")>
    <#assign bcCurrent = springMacroRequestContext.getMessage("courseInstances.admin.detail.breadcrumb.current", [lesson.courseModule.courseInstance.id])>
    <#assign breadcrumbs = [{"label": bcHome, "url": "/"}]>

    <#if isTeacher>
        <#assign breadcrumbs = breadcrumbs + [{"label": bcMy, "url": "/teacher/my-courses"}]>
        <#assign breadcrumbs = breadcrumbs + [{"label": lesson.courseModule.courseInstance.title, "url": "/teacher/course/${lesson.courseModule.courseInstance.id}"}]>
    </#if>
    <#if isStudent>
        <#assign breadcrumbs = breadcrumbs + [{"label": bcMy, "url": "/student/my-courses"}]>
        <#assign breadcrumbs = breadcrumbs + [{"label": lesson.courseModule.courseInstance.title, "url": "/student/course/${lesson.courseModule.courseInstance.id}"}]>
    </#if>
    <#if isAdmin>
        <#assign breadcrumbs = breadcrumbs + [{"label": bcList, "url": "/admin/course-instances"}]>
        <#assign breadcrumbs = breadcrumbs + [{"label": bcCurrent, "url": "/admin/course-instances/${lesson.courseModule.courseInstance.id}"}]>
    </#if>
    <#assign breadcrumbs = breadcrumbs + [{"label": lesson.title, "url": ""}]>
</#if>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" class="alert alert-success rounded-3 mb-4">
            <i class="fas fa-check-circle me-2"></i>${successMessage?js_string}
        </div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" class="alert alert-danger rounded-3 mb-4">
            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage?js_string}
        </div>
    </#if>
    <@roadmap.breadcrumbs items=breadcrumbs/>

    <div class="container my-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div class="flex-grow-1">
                <h1 class="display-4 fw-bold text-break">${lesson.title}</h1>
            </div>
            <#if isAdmin || isTeacher>
                <div class="d-flex gap-2 flex-shrink-0">
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/edit'/>"
                       class="btn btn-primary btn-sm rounded-pill">
                        <i class="fas fa-edit me-1"></i><@spring.message code="lesson.edit"/>
                    </a>
                    <form method="post" action="<@spring.url '/admin/lessons/${lesson.id}/delete'/>"
                          onsubmit="return confirm('<@spring.message code="lesson.delete.confirm"/>')">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger btn-sm rounded-pill">
                            <i class="fas fa-trash-alt me-1"></i><@spring.message code="lesson.delete"/>
                        </button>
                    </form>
                </div>
            </#if>
        </div>

        <div class="card shadow-sm mb-5 border-0 rounded-3">
            <div class="card-body">
                <h5 class="card-title fw-semibold"><@spring.message code="lesson.description"/></h5>
                <p class="card-text text-secondary">
                    <#if lesson.description?has_content>
                        ${lesson.description}
                    <#else>
                        <span class="text-muted fst-italic"><@spring.message code="lesson.description.empty"/></span>
                    </#if>
                </p>
            </div>
        </div>

        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1"><@spring.message code="lesson.materials"/></h4>
                <div class="d-flex gap-2 flex-shrink-0">
                    <a href="/lessons/${lesson.id}/content-page" target="_blank"
                       class="btn btn-primary btn-sm rounded-pill">
                        <i class="fas fa-external-link-alt me-1"></i><@spring.message code="lesson.contentPage"/>
                    </a>
                    <#if isAdmin || isTeacher>
                        <a href="<@spring.url '/lessons/${lesson.id}/materials/new'/>"
                           class="btn btn-primary btn-sm rounded-pill">
                            <i class="fas fa-plus me-1"></i><@spring.message code="lesson.materials.add"/>
                        </a>
                    </#if>
                </div>
            </div>
            <#if materials?has_content>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <#list materials as material>
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm rounded-3 overflow-hidden">
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title mb-3 fw-semibold text-break">${material.title}</h6>
                                    <div class="mt-auto d-flex justify-content-between align-items-center">
                                        <a href="/data/lesson-materials/${material.url}" target="_blank"
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-external-link-alt me-1"></i><@spring.message code="lesson.materials.open"/>
                                        </a>
                                        <#if isAdmin>
                                            <form action="<@spring.url '/lessons/${lesson.id}/materials/${material.id}/delete'/>"
                                                  method="post" class="d-inline"
                                                  onsubmit="return confirm('<@spring.message code="lesson.materials.delete.confirm"/>')">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0"><@spring.message code="lesson.materials.empty"/></p>
                </div>
            </#if>
        </div>

        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1"><@spring.message code="lesson.schedule"/></h4>
                <#if isAdmin>
                    <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>"
                       class="btn btn-primary btn-sm rounded-pill flex-shrink-0">
                        <i class="fas fa-calendar me-1"></i><#if schedule??><@spring.message code="lesson.schedule.edit"/><#else><@spring.message code="lesson.schedule.create"/></#if>
                    </a>
                </#if>
            </div>
            <#if schedule??>
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-start mb-3 gap-3">
                            <h6 class="card-title fw-semibold flex-grow-1 text-break">${schedule.title!lesson.title}</h6>

                            <div class="d-flex gap-2 flex-wrap">
                                <#if (isTeacher && schedule.teacherId?? && schedule.teacherId == currentUserId) || isStudent>
                                    <#if isMeetingActive!false>
                                        <a href="<@spring.url '/jitsi/meeting/${activeMeeting.meetingId}/join?userId=${currentUserId}&userRole=${isTeacher?then("TEACHER","STUDENT")}'/>"
                                           class="btn btn-success btn-sm rounded-pill">
                                            <i class="fas fa-video me-1"></i><@spring.message code="lesson.login"/>
                                        </a>
                                    <#else>
                                        <#if isTeacher>
                                            <a href="<@spring.url '/jitsi/schedule/${schedule.id}/start?teacherId=${currentUserId}'/>"
                                               class="btn btn-success btn-sm rounded-pill">
                                                <i class="fas fa-play me-1"></i><@spring.message code="lesson.start"/>
                                            </a>
                                        </#if>
                                    </#if>
                                </#if>

                                <#if (isTeacher || isAdmin)>
                                    <a href="<@spring.url '/analytics/schedule/${schedule.id}'/>"
                                       class="btn btn-outline-info btn-sm rounded-pill"
                                       title="Посмотреть аналитику урока">
                                        <i class="fas fa-chart-bar me-1"></i><@spring.message code="lesson.analytics"/>
                                    </a>
                                </#if>
                            </div>
                        </div>

                        <div class="lesson-info-grid">
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-calendar me-2"></i><@spring.message code="lesson.schedule.date"/></span>
                                <span class="lesson-info-value">${schedule.formattedLessonDate}</span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-clock me-2"></i><@spring.message code="lesson.schedule.duration"/></span>
                                <span class="lesson-info-value">${schedule.durationHours} <@spring.message code="lesson.quiz.minutes"/></span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-user me-2"></i><@spring.message code="lesson.schedule.teacher"/></span>
                                <span class="lesson-info-value">${schedule.teacherName!'<@spring.message code="lesson.schedule.teacher.none"/>'}</span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-chalkboard me-2"></i><@spring.message code="lesson.schedule.type"/></span>
                                <span class="lesson-info-value">
                                    <@spring.message code=schedule.lessonType.value />
                                </span>
                            </div>
                            <#if schedule.notes?has_content>
                                <div class="lesson-info-item">
                                    <span class="lesson-info-label"><i class="fas fa-note-sticky me-2"></i><@spring.message code="lesson.schedule.notes"/></span>
                                    <span class="lesson-info-value">${schedule.notes}</span>
                                </div>
                            </#if>
                            <#if isMeetingActive!false>
                                <div class="lesson-info-item">
                                    <span class="lesson-info-label"><i class="fas fa-circle text-success me-2"></i><@spring.message code="lesson.schedule.status"/></span>
                                    <span class="lesson-info-value fw-bold text-success"><@spring.message code="lesson.schedule.active"/></span>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0"><@spring.message code="lesson.schedule.empty"/></p>
                </div>
            </#if>
        </div>

        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1"><@spring.message code="lesson.testing"/></h4>
                <#if isTeacher>
                    <#if lesson.quiz??>
                        <div class="d-flex gap-2 flex-shrink-0">
                            <a href="/quiz/${lesson.quiz.id}/edit"
                               class="btn btn-warning btn-sm rounded-pill">
                                <i class="fas fa-edit me-1"></i><@spring.message code="lesson.quiz.edit"/>
                            </a>
                            <a href="/quiz/${lesson.quiz.id}/delete"
                               class="btn btn-danger btn-sm rounded-pill">
                                <i class="fas fa-trash-alt me-1"></i><@spring.message code="lesson.quiz.delete"/>
                            </a>
                            <a href="/quiz/${lesson.quiz.id}/${lesson.quiz.isActive?string('deactivate','activate')}"
                               class="btn btn-${lesson.quiz.isActive?string('warning','success')} btn-sm rounded-pill">
                                <i class="fas fa-${lesson.quiz.isActive?string('ban','check')} me-1"></i>
                                <@spring.message code="lesson.quiz.${lesson.quiz.isActive?string('deactivate','activate')}"/>
                            </a>
                        </div>
                    <#else>
                        <a href="/quiz/create/${lesson.id}" class="btn btn-primary btn-sm rounded-pill flex-shrink-0">
                            <i class="fas fa-plus me-1"></i><@spring.message code="lesson.quiz.create"/>
                        </a>
                    </#if>
                </#if>
            </div>
            <#if lesson.quiz?has_content>
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body">
                        <h5 class="card-title fw-semibold"><@spring.message code="lesson.quiz.title"/> <span class="fw-bold">${lesson.title}</span></h5>
                        <p class="card-text"><@spring.message code="lesson.quiz.time"/> <span class="fw-bold">${lesson.quiz.questionTimeLimit} <@spring.message code="lesson.quiz.minutes"/></span></p>
                        <#if isStudent || isTeacher>
                            <a href="/quiz/${lesson.quiz.id}/passing"
                               class="btn btn-primary btn-sm rounded-pill <#if !lesson.quiz.isActive>disabled</#if>">
                                <i class="fa-solid fa-list-check me-1"></i>
                                <#if timer??><@spring.message code="lesson.quiz.return"/><#else><@spring.message code="lesson.quiz.start"/></#if>
                            </a>
                        </#if>
                    </div>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0"><@spring.message code="lesson.quiz.empty"/></p>
                </div>
            </#if>
        </div>
    </div>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 1200px;
        }

        .display-4 {
            font-size: 2.5rem;
            color: #1a252f;
        }

        .card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
        }

        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            transition: background 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3, #003d7a);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            border: none;
            transition: background 0.3s ease;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1e7e34, #155724);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            border: none;
            transition: background 0.3s ease;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706, #b35a05);
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #b02a37);
            border: none;
            transition: background 0.3s ease;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #b02a37, #8b1d2a);
        }

        .btn-outline-primary, .btn-outline-danger {
            transition: all 0.2s ease-in-out;
        }

        .btn-outline-primary:hover, .btn-outline-danger:hover {
            transform: scale(1.05);
        }

        .btn-sm {
            padding: 0.375rem 0.75rem;
        }

        .rounded-pill {
            border-radius: 50rem !important;
        }

        .card-title {
            color: #1a252f;
        }

        .text-secondary {
            color: #6c757d !important;
        }

        .text-success {
            color: #28a745 !important;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
            border: 1px solid #28a745;
        }

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border: 1px solid #dc3545;
        }

        .bg-light {
            background-color: #f1f3f5 !important;
        }

        .lesson-info-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 2fr);
            gap: 0.75rem;
            align-items: center;
            font-size: 0.95rem;
        }

        .lesson-info-item {
            display: contents;
        }

        .lesson-info-label {
            font-weight: 500;
            color: #495057;
            display: flex;
            align-items: center;
            padding: 0.5rem 0;
        }

        .lesson-info-label i {
            font-size: 1.1rem;
            width: 1.5rem;
            text-align: center;
        }

        .lesson-info-value {
            padding: 0.5rem 0;
            color: #212529;
            word-break: break-all;
            overflow-wrap: anywhere;
        }

        .lesson-info-value a {
            text-decoration: none;
        }

        .lesson-info-value a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .display-4 {
                font-size: 2rem;
            }

            .d-flex.justify-content-between {
                flex-direction: column;
                gap: 1rem;
            }

            .d-flex.gap-2, .d-flex.gap-3 {
                justify-content: center;
            }

            .lesson-info-grid {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }

            .lesson-info-label,
            .lesson-info-value {
                padding: 0.25rem 0;
            }
        }

        @media (max-width: 576px) {
            .display-4 {
                font-size: 1.75rem;
            }

            .btn-sm {
                padding: 0.3rem 0.6rem;
                font-size: 0.85rem;
            }
        }
    </style>
</@layout.page>