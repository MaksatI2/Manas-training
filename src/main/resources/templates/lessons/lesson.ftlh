<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

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
</#if>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="container my-5">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <div class="flex-grow-1">
                <h1 class="display-4 fw-bold text-break">${lesson.title}</h1>
            </div>
            <#if isAdmin || isTeacher>
                <div class="d-flex gap-2 flex-shrink-0">
                    <a href="<@spring.url '/admin/lessons/${lesson.id}/edit'/>"
                       class="btn btn-primary btn-sm rounded-pill">
                        <i class="fas fa-edit me-1"></i>Редактировать
                    </a>

                    <form method="post" action="<@spring.url '/admin/lessons/${lesson.id}/delete'/>"
                          onsubmit="return confirm('Вы уверены, что хотите удалить этот урок?')">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger btn-sm rounded-pill">
                            <i class="fas fa-trash-alt me-1"></i>Удалить
                        </button>
                    </form>
                </div>
            </#if>
        </div>

        <div class="card shadow-sm mb-5 border-0 rounded-3">
            <div class="card-body">
                <h5 class="card-title fw-semibold">Описание</h5>
                <p class="card-text text-secondary">
                    <#if lesson.description?has_content>
                        ${lesson.description}
                    <#else>
                        <span class="text-muted fst-italic">Описание отсутствует</span>
                    </#if>
                </p>
            </div>
        </div>


        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1">Материалы</h4>
                <a href="/lessons/${lesson.id}/content-page" target="_blank"
                   class="btn btn-primary btn-sm rounded-pill flex-shrink-0">
                    <i class="fas fa-external-link-alt me-1"></i>Содержимое урока
                </a>
                <#if isAdmin || isTeacher>
                    <a href="<@spring.url '/lessons/${lesson.id}/materials/new'/>"
                       class="btn btn-primary btn-sm rounded-pill flex-shrink-0">
                        <i class="fas fa-plus me-1"></i>Добавить
                    </a>
                </#if>
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
                                            <i class="fas fa-external-link-alt me-1"></i>Открыть
                                        </a>
                                        <#if isAdmin>
                                            <form action="<@spring.url '/lessons/${lesson.id}/materials/${material.id}/delete'/>"
                                                  method="post" class="d-inline"
                                                  onsubmit="return confirm('Удалить материал?')">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                       value="${_csrf.token}"/>
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
                    <p class="text-muted mb-0">Материалы не добавлены.</p>
                </div>
            </#if>
        </div>

        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1">Расписание</h4>
                <#if isAdmin>
                    <#if schedule??>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>"
                           class="btn btn-primary btn-sm rounded-pill flex-shrink-0">Редактировать расписание</a>
                    <#else>
                        <a href="<@spring.url '/schedules/lessons/${lesson.id}'/>"
                           class="btn btn-primary btn-sm rounded-pill flex-shrink-0">Создать расписание</a>
                    </#if>
                </#if>
            </div>

            <#if schedule??>
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-start mb-3 gap-3">
                            <h6 class="card-title fw-semibold flex-grow-1 text-break">${schedule.title!lesson.title}</h6>

                            <#if isTeacher && schedule.teacherId?? && schedule.teacherId == currentUserId>
                                <#if isMeetingActive!false>
                                <#else>
                                    <a href="<@spring.url '/jitsi/schedule/${schedule.id}/start?teacherId=${currentUserId}'/>"
                                       class="btn btn-success btn-sm rounded-pill flex-shrink-0">
                                        <i class="fas fa-play me-1"></i>Начать урок
                                    </a>
                                </#if>
                            </#if>
                        </div>

                        <div class="lesson-info-grid">
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-calendar me-2"></i>Дата:</span>
                                <span class="lesson-info-value">${schedule.formattedLessonDate}</span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-clock me-2"></i>Длительность:</span>
                                <span class="lesson-info-value">${schedule.durationHours} ч.</span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-user me-2"></i>Преподаватель:</span>
                                <span class="lesson-info-value">${schedule.teacherName!'Не указан'}</span>
                            </div>
                            <div class="lesson-info-item">
                                <span class="lesson-info-label"><i class="fas fa-chalkboard me-2"></i>Тип урока:</span>
                                <span class="lesson-info-value">${schedule.lessonType.value}</span>
                            </div>
                            <#if schedule.meetingUrl?has_content>
                                <div class="lesson-info-item">
                                    <span class="lesson-info-label"><i class="fas fa-link me-2"></i>Ссылка:</span>
                                    <span class="lesson-info-value"><a href="${schedule.meetingUrl}" target="_blank"
                                                                       class="link-primary">Присоединиться</a></span>
                                </div>
                            </#if>
                            <#if schedule.notes?has_content>
                                <div class="lesson-info-item">
                                    <span class="lesson-info-label"><i
                                                class="fas fa-note-sticky me-2"></i>Примечания:</span>
                                    <span class="lesson-info-value">${schedule.notes}</span>
                                </div>
                            </#if>
                            <#if isMeetingActive!false>
                                <div class="lesson-info-item">
                                    <span class="lesson-info-label"><i class="fas fa-circle text-success me-2"></i>Статус:</span>
                                    <span class="lesson-info-value fw-bold text-success">Урок активен</span>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0">Расписание пока не задано.</p>
                </div>
            </#if>
        </div>

        <div class="mb-5">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-3">
                <h4 class="fw-bold flex-grow-1">Тестирование</h4>
                <#if isTeacher>
                    <#if lesson.quiz??>
                        <a href="/quiz/${lesson.quiz.id}/edit"
                           class="btn btn-warning btn-sm rounded-pill flex-shrink-0">
                            <i class="fas fa-edit me-1"></i> Редактировать тест
                        </a>
                        <a href="/quiz/${lesson.quiz.id}/delete"
                           class="btn btn-danger btn-sm rounded-pill flex-shrink-0">
                            <i class="fas fa-trash-alt me-1"></i> Удалить тест
                        </a>
                        <#if !lesson.quiz.isActive>
                            <a href="/quiz/${lesson.quiz.id}/activate"
                               class="btn btn-success btn-sm rounded-pill flex-shrink-0">
                                <i class="fa-solid fa-check"></i> Активировать тест
                            </a>
                        <#else>
                            <a href="/quiz/${lesson.quiz.id}/deactivate"
                               class="btn btn-warning btn-sm rounded-pill flex-shrink-0">
                                <i class="fas fa-ban"></i> Деактивировать тест
                            </a>
                        </#if>
                    <#else>
                        <a href="/quiz/create/${lesson.id}" class="btn btn-primary btn-sm rounded-pill flex-shrink-0">
                            <i class="fas fa-plus me-1"></i> Создать тест
                        </a>
                    </#if>
                </#if>
            </div>
            <#if lesson.quiz?has_content>
                <div class="card shadow-sm mb-5 border-0 rounded-3 mt-4">
                    <div class="card-body">
                        <h5>Тестовое задание по итогам урока: <span class="fw-bold">${lesson.title}</span></h5>
                        <p>Время на прохождения теста: <span
                                    class="fw-bold">${lesson.quiz.questionTimeLimit} минут.</span></p>
                        <#if (isStudent || isTeacher)>
                            <a href="/quiz/${lesson.quiz.id}/passing"
                               class="btn btn-primary rounded-pill <#if !lesson.quiz.isActive>disabled</#if>">
                                <i class="fa-solid fa-list-check"></i>
                                <#if timer??>
                                    Вернуться к тесту
                                <#else>
                                    Начать тест
                                </#if>
                            </a>
                        </#if>
                    </div>
                </div>
            <#else>
                <div class="text-center py-5 bg-light rounded-3">
                    <p class="text-muted mb-0">Тестовое задание еще не загружено.</p>
                </div>
            </#if>
        </div>
    </div>

    <style>

        .fr-box.fr-basic {
            min-height: 300px;
            padding: 15px;
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
        }

        .lesson-info-value a {
            text-decoration: none;
        }

        .lesson-info-value a:hover {
            text-decoration: underline;
        }

        @media (max-width: 576px) {
            .lesson-info-grid {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }

            .lesson-info-label,
            .lesson-info-value {
                padding: 0.25rem 0;
            }
        }

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

        .btn-outline-primary, .btn-outline-warning, .btn-outline-danger {
            transition: all 0.2s ease-in-out;
        }

        .btn-outline-primary:hover, .btn-outline-warning:hover, .btn-outline-danger:hover {
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

        .list-unstyled li {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .list-unstyled i {
            width: 1.25rem;
            text-align: center;
        }

        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .bg-light {
            background-color: #f1f3f5 !important;
        }

        @media (max-width: 768px) {
            .display-4 {
                font-size: 2rem;
            }

            .d-flex.justify-content-between {
                flex-direction: column;
                gap: 1rem;
            }

            .d-flex.gap-2 {
                justify-content: center;
            }
        }
    </style>
</@layout.page>