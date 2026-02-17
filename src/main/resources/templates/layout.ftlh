<#import "/spring.ftl" as spring>
<#import "/spring.ftl" as spring>

<#macro page title="">
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <style>
            body {
                visibility: hidden;
                display: none;
            }
        </style>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-solid-900.woff2"
              as="font" type="font/woff2" crossorigin="anonymous">
        <link rel="preload"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-regular-400.woff2" as="font"
              type="font/woff2" crossorigin="anonymous">
        <link rel="preload"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-brands-400.woff2" as="font"
              type="font/woff2" crossorigin="anonymous">

        <title><@spring.message code="app.title" /></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.5.0/css/flag-icon.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/lipis/flag-icons@7.3.2/css/flag-icons.min.css"/>
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">

        <script>
            window.APP_MESSAGES = Object.assign({}, window.APP_MESSAGES, {
                'js.instance_list.alert.invalidId': '<@spring.message code="js.instance_list.alert.invalidId"/>',
                'js.instance_list.loading': '<@spring.message code="js.instance_list.loading"/>',
                'js.instance_list.empty': '<@spring.message code="js.instance_list.empty"/>',
                'js.instance_list.btn.delete': '<@spring.message code="js.instance_list.btn.delete"/>',
                'js.instance_list.btn.disabledHasModules': '<@spring.message code="js.instance_list.btn.disabledHasModules"/>',
                'js.instance_list.error.load': '<@spring.message code="js.instance_list.error.load"/>',
                'js.instance_list.error.cannotCheck': '<@spring.message code="js.instance_list.error.cannotCheck"/>',
                'js.instance_list.hours.suffix': '<@spring.message code="js.instance_list.hours.suffix"/>',
                'js.instance_list.order.label': '<@spring.message code="js.instance_list.order.label"/>',
                'js.instance_list.dash': '<@spring.message code="js.instance_list.dash"/>',
                'js.instance_module.field.title': '<@spring.message code="js.instance_module.field.title"/>',
                'js.instance_module.field.hours': '<@spring.message code="js.instance_module.field.hours"/>',
                'js.instance_module.field.description': '<@spring.message code="js.instance_module.field.description"/>',
                'js.instance_module.btn.remove': '<@spring.message code="js.instance_module.btn.remove"/>',
                'js.instance_module.alert.needOne': '<@spring.message code="js.instance_module.alert.needOne"/>',
                'js.instance_module.alert.overLimit': '<@spring.message code="js.instance_module.alert.overLimit"/>',
                'js.instance_module.modal.blocked': '<@spring.message code="js.instance_module.modal.blocked"/>',
                'js.instance_module.modal.deleteQuestion': '<@spring.message code="js.instance_module.modal.deleteQuestion"/>',
                'js.instance_module.modal.deleteImpossible': '<@spring.message code="js.instance_module.modal.deleteImpossible"/>',
                'js.instance_module.modal.deleteAction': '<@spring.message code="js.instance_module.modal.deleteAction"/>',

                'js.lesson-materials.label.fileSelected': '${springMacroRequestContext.getMessage("js.lesson-materials.label.fileSelected")?js_string}',
                'js.lesson-materials.label.clickToChooseAnother': '${springMacroRequestContext.getMessage("js.lesson-materials.label.clickToChooseAnother")?js_string}',
                'js.lesson-materials.error.invalidType': '${springMacroRequestContext.getMessage("js.lesson-materials.error.invalidType")?js_string}',
                'js.lesson-materials.error.tooLarge': '${springMacroRequestContext.getMessage("js.lesson-materials.error.tooLarge")?js_string}',
                'js.lesson-materials.info.selectedFile': '${springMacroRequestContext.getMessage("js.lesson-materials.info.selectedFile")?js_string}',
                'js.lesson-materials.info.size': '${springMacroRequestContext.getMessage("js.lesson-materials.info.size")?js_string}',
                'js.lesson-materials.preview.alt': '${springMacroRequestContext.getMessage("js.lesson-materials.preview.alt")?js_string}',
                'js.lesson-materials.label.clickToChoose': '${springMacroRequestContext.getMessage("js.lesson-materials.label.clickToChoose")?js_string}',
                'js.lesson-materials.label.orDragHere': '${springMacroRequestContext.getMessage("js.lesson-materials.label.orDragHere")?js_string}',
                'js.lesson-materials.error.pickFile': '${springMacroRequestContext.getMessage("js.lesson-materials.error.pickFile")?js_string}',
                'js.lesson-materials.error.enterTitle': '${springMacroRequestContext.getMessage("js.lesson-materials.error.enterTitle")?js_string}',
                'js.lesson-materials.saving': '${springMacroRequestContext.getMessage("js.lesson-materials.saving")?js_string}',

                'js.map.confirm.mobile': '${springMacroRequestContext.getMessage("js.map.confirm.mobile")?js_string}',
                'js.map.prompt.desktop': '${springMacroRequestContext.getMessage("js.map.prompt.desktop")?js_string}',
                'js.map.choice.google': '${springMacroRequestContext.getMessage("js.map.choice.google")?js_string}',
                'js.map.choice.yandex': '${springMacroRequestContext.getMessage("js.map.choice.yandex")?js_string}',
                'js.map.choice.osm': '${springMacroRequestContext.getMessage("js.map.choice.osm")?js_string}',
                'js.map.log.appleUnavailable': '${springMacroRequestContext.getMessage("js.map.log.appleUnavailable")?js_string}',
                'js.map.log.googleAppUnavailable': '${springMacroRequestContext.getMessage("js.map.log.googleAppUnavailable")?js_string}',

                'js.lesson-materials.label.enterQuestion': '${springMacroRequestContext.getMessage("js.lesson-materials.label.enterQuestion")?js_string}',
                'js.lesson-materials.placeholder.answerOption': '${springMacroRequestContext.getMessage("js.lesson-materials.placeholder.answerOption")?js_string}',
                'js.lesson-materials.button.addOption': '${springMacroRequestContext.getMessage("js.lesson-materials.button.addOption")?js_string}',

                'quiz_form_validation.title.required': '${springMacroRequestContext.getMessage("quiz_form_validation.title.required")?js_string}',
                'quiz_form_validation.description.required': '${springMacroRequestContext.getMessage("quiz_form_validation.description.required")?js_string}',
                'quiz_form_validation.time.required': '${springMacroRequestContext.getMessage("quiz_form_validation.time.required")?js_string}',
                'quiz_form_validation.question.required': '${springMacroRequestContext.getMessage("quiz_form_validation.question.required")?js_string}',
                'quiz_form_validation.option.required': '${springMacroRequestContext.getMessage("quiz_form_validation.option.required")?js_string}',

                'teachers.alert.selectOne': '${springMacroRequestContext.getMessage("teachers.alert.selectOne")?js_string}',

                'test_form.label.enterQuestion': '${springMacroRequestContext.getMessage("test_form.label.enterQuestion")?js_string}',
                'test_form.placeholder.answerOption': '${springMacroRequestContext.getMessage("test_form.placeholder.answerOption")?js_string}',
                'test_form.button.addOption': '${springMacroRequestContext.getMessage("test_form.button.addOption")?js_string}',
                'test_form.label.active': '${springMacroRequestContext.getMessage("test_form.label.active")?js_string}',

                'test_form_validation.title.required': '${springMacroRequestContext.getMessage("test_form_validation.title.required")?js_string}',
                'test_form_validation.passingScore.required': '${springMacroRequestContext.getMessage("test_form_validation.passingScore.required")?js_string}',
                'test_form_validation.question.required': '${springMacroRequestContext.getMessage("test_form_validation.question.required")?js_string}',
                'test_form_validation.option.required': '${springMacroRequestContext.getMessage("test_form_validation.option.required")?js_string}',

                'test_instance_form.test.required': '${springMacroRequestContext.getMessage("test_instance_form.test.required")?js_string}',
                'test_instance_form.startDate.required': '${springMacroRequestContext.getMessage("test_instance_form.startDate.required")?js_string}',
                'test_instance_form.endDate.required': '${springMacroRequestContext.getMessage("test_instance_form.endDate.required")?js_string}',
                'test_instance_form.startTime.required': '${springMacroRequestContext.getMessage("test_instance_form.startTime.required")?js_string}',
                'test_instance_form.endTime.required': '${springMacroRequestContext.getMessage("test_instance_form.endTime.required")?js_string}'
            });
        </script>


    </head>
    <div id="flash-message-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>
    <script src="/static/js/notifications.js"></script>
    <script src="/static/js/test_instance_form.js"></script>
    <body>
    <#assign known = Session.SPRING_SECURITY_CONTEXT??>
    <#if known>
        <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
        <#assign name = user.getFullName()>
        <#assign roles = user.getAuthorities()?join(",")>
        <#assign isAdmin = roles?contains("ADMIN")>
        <#assign isTeacher = roles?contains("TEACHER")>
        <#assign isStudent = roles?contains("STUDENT")>
        <#assign isOrganization = roles?contains("ORGANIZATION")>
    </#if>

    <button class="sidebar-toggle" id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <a href="/" class="sidebar-brand">
                <i class="fas fa-graduation-cap"></i>
                <span><@spring.message code="app.title" /></span>
            </a>
        </div>

        <div class="sidebar-content">
            <div class="sidebar-nav">
                <div class="nav-item">
                    <a href="/" class="nav-link" data-tooltip="<@spring.message code='sidebar.home' />">
                        <i class="fas fa-home"></i>
                        <span><@spring.message code="sidebar.home" /></span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="/courses" class="nav-link" data-tooltip="<@spring.message code='sidebar.courses' />">
                        <i class="fas fa-book"></i>
                        <span><@spring.message code="sidebar.courses" /></span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="/teacher" class="nav-link" data-tooltip="<@spring.message code='sidebar.teachers' />">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span><@spring.message code="sidebar.teachers" /></span>
                    </a>
                </div>
                <#if isAdmin?? && isAdmin>
                    <div class="nav-item">
                        <a href="/admin/users" class="nav-link" data-tooltip="<@spring.message code='sidebar.users' />">
                            <i class="fas fa-users"></i>
                            <span><@spring.message code="sidebar.users" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/schedules" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.schedule' />">
                            <i class="fas fa-calendar"></i>
                            <span><@spring.message code="sidebar.schedule" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/statistics" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.statistics' />">
                            <i class="fas fa-chart-bar"></i>
                            <span><@spring.message code="sidebar.statistics" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/courses" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.course.management' />">
                            <i class="fas fa-book-open"></i>
                            <span><@spring.message code="sidebar.course.management" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/categories" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.categories' />">
                            <i class="fas fa-tags"></i>
                            <span><@spring.message code="sidebar.categories" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/course-instances" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.instances' />">
                            <i class="fas fa-chart-bar"></i>
                            <span><@spring.message code="sidebar.instances" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/applications/admin" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.applications.admin' />">
                            <i class="fas fa-file-alt"></i>
                            <span><@spring.message code="sidebar.applications.admin" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/certificate" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.certificates' />">
                            <i class="fas fa-award"></i>
                            <span><@spring.message code="sidebar.certificates" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/test-results" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.test.results' />">
                            <i class="fa-solid fa-list-check"></i>
                            <span><@spring.message code="sidebar.test.results" /></span>
                        </a>
                    </div>
                </#if>
                <#if isTeacher?? && isTeacher>
                    <div class="nav-item">
                        <a href="/teacher/my-courses" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.my.courses' />">
                            <i class="fas fa-book-open"></i>
                            <span><@spring.message code="sidebar.my.courses" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/schedules" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.schedule' />">
                            <i class="fas fa-calendar"></i>
                            <span><@spring.message code="sidebar.schedule" /></span>
                        </a>
                    </div>
                </#if>
                <#if isOrganization?? && isOrganization>
                    <div class="nav-item">
                        <a href="/organization/students" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.students' />">
                            <i class="fas fa-user-tie"></i>
                            <span><@spring.message code="sidebar.students" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/applications/organization"
                           class="nav-link d-flex justify-content-between align-items-center"
                           data-tooltip="<@spring.message code='sidebar.applications.org' />">
                            <div class="d-flex align-items-center" style="gap: 15px">
                                <i class="fas fa-file-alt"></i>
                                <span><@spring.message code="sidebar.applications.org" /></span>
                            </div>
                            <span id="notificationCount" class="badge bg-danger ms-2" style="display: none;">0</span>
                        </a>
                    </div>
                </#if>
                <#if isStudent?? && isStudent>
                    <div class="nav-item">
                        <a href="/student/my-courses" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.my.courses' />">
                            <i class="fas fa-book-open"></i>
                            <span><@spring.message code="sidebar.my.courses" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/student/my-tests" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.tests' />">
                            <i class="fas fa-clipboard-list"></i>
                            <span><@spring.message code="sidebar.tests" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/schedules" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.schedule' />">
                            <i class="fas fa-calendar"></i>
                            <span><@spring.message code="sidebar.schedule" /></span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/applications/student/applications"
                           class="nav-link d-flex justify-content-between align-items-center"
                           data-tooltip="<@spring.message code='sidebar.applications.student' />">
                            <div class="d-flex align-items-center" style="gap: 15px">
                                <i class="fas fa-file-alt"></i>
                                <span><@spring.message code="sidebar.applications.student" /></span>
                            </div>
                            <span id="notificationCountStudent" class="badge bg-danger ms-2"
                                  style="display: none;">0</span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/student/certificates" class="nav-link"
                           data-tooltip="<@spring.message code='sidebar.certificates.student' />">
                            <i class="fas fa-award"></i>
                            <span><@spring.message code="sidebar.certificates.student" /></span>
                        </a>
                    </div>
                </#if>
            </div>
            <div class="sidebar-profile <#if known>authorized</#if>">
                <div class="custom-language-selector mt-4" id="languageSelector">
                    <button class="selected-language" id="selectedLanguageBtn">
                        <span class="fi" id="selectedFlag"></span>
                        <span class="language-text" id="selectedLanguageText"></span>
                    </button>
                    <div class="language-options" id="languageOptions">
                        <div class="language-option" data-value="ru">
                            <span class="fi fi-ru"></span>
                            <span><@spring.message code="language.russian" /></span>
                        </div>
                        <div class="language-option" data-value="ky">
                            <span class="fi fi-kg"></span>
                            <span><@spring.message code="language.kyrgyz" /></span>
                        </div>
                        <div class="language-option" data-value="en">
                            <span class="fi fi-gb"></span>
                            <span><@spring.message code="language.english" /></span>
                        </div>
                    </div>
                    <#if known>
                        <form id="languageForm" action="/api/users/language" method="post" style="display:none;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="lang" id="languageInput" value="">
                        </form>
                    </#if>
                </div>

                <#if known>
                    <div class="dropdown mt-2">
                        <button class="btn btn-outline-secondary dropdown-toggle w-100" type="button"
                                data-bs-toggle="dropdown"
                                style="border-color: rgba(255,255,255,0.2); color: white; text-align: left; padding: 0.5rem 1rem;">
                            <@spring.message code="header.additional" />
                        </button>
                        <ul class="dropdown-menu w-100">
                            <li><a class="dropdown-item" href="/auth/manage-devices">
                                    <@spring.message code="header.device.management" />
                                </a></li>
                            <li>
                                <form action="/auth/logout-all-devices" method="post" class="dropdown-item p-0">
                                    <#if _csrf??>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    </#if>
                                    <button type="submit"
                                            class="btn btn-link text-decoration-none w-100 text-start ps-3 py-2"
                                            onclick="return confirm('<@spring.message code="header.logout.all.confirm" />')"
                                            style="color: inherit;">
                                        <i class="fas fa-sign-out-alt me-1"></i>
                                        <@spring.message code="header.logout.all" />
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </#if>

                <#if !known?? || !known>
                    <div class="profile-actions">
                        <a href="/auth/login" class="profile-btn">
                            <i class="fas fa-sign-in-alt"></i> <span><@spring.message code="auth.login" /></span>
                        </a>
                        <a href="/auth/register" class="profile-btn">
                            <i class="fas fa-user-plus"></i> <span><@spring.message code="auth.register" /></span>
                        </a>
                    </div>
                </#if>
            </div>
        </div>
    </nav>

    <div class="main-wrapper" id="mainWrapper">
        <header class="top-header d-md-flex justify-content-between align-items-center px-3 py-2">

            <div class="d-flex align-items-center w-100 justify-content-between d-md-none">
                <button class="mobile-menu-btn" id="mobileMenuBtn">
                    <i class="fas fa-bars"></i>
                </button>
                <h1 class="text-center flex-grow-1 m-0" style="color: var(--primary-blue); font-size: 1.1rem;">
                    <i class="fas fa-graduation-cap me-2"></i>
                    <@spring.message code="app.title" />
                </h1>
                <span style="width: 44px;"></span>
            </div>

            <#if known>
                <#assign profileUrl = "/profile">
                <#if isAdmin>
                    <#assign profileUrl = "/admin/profile">
                <#elseif isTeacher>
                    <#assign profileUrl = "/teacher/profile">
                <#elseif isStudent>
                    <#assign profileUrl = "/student/profile">
                <#elseif isOrganization>
                    <#assign profileUrl = "/organization/profile">
                </#if>

                <div class="d-md-none mt-2 d-flex gap-2 justify-content-center">
                    <#if isAdmin>
                        <button class="btn d-flex align-items-center justify-content-center" disabled
                                style="width: 44px; height: 44px; border-radius: 25px; background: white; color: var(--primary-blue); border: 2px solid var(--primary-blue); opacity: 0.6; cursor: not-allowed;">
                            <i class="fas fa-user-circle"></i>
                        </button>
                    <#else>
                        <a href="${profileUrl}" class="btn d-flex align-items-center justify-content-center"
                           style="width: 44px; height: 44px; border-radius: 25px; background: white; color: var(--primary-blue); border: 2px solid var(--primary-blue);">
                            <i class="fas fa-user-circle"></i>
                        </a>
                    </#if>
                    <form action="/logout" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn d-flex align-items-center justify-content-center text-white"
                                style="width: 44px; height: 44px; border-radius: 25px; background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); border: none;">
                            <i class="fas fa-sign-out-alt"></i>
                        </button>
                    </form>
                </div>
            </#if>

            <#if known>
                <#assign profileUrl = "/profile">
                <#if isAdmin>
                    <#assign profileUrl = "/admin/profile">
                <#elseif isTeacher>
                    <#assign profileUrl = "/teacher/profile">
                <#elseif isStudent>
                    <#assign profileUrl = "/student/profile">
                <#elseif isOrganization>
                    <#assign profileUrl = "/organization/profile">
                </#if>

                <div class="d-none d-md-flex align-items-center ms-auto rounded-pill overflow-hidden"
                     style="box-shadow: 0 0 5px rgba(0,0,0,0.1); background: var(--primary-blue); height: 48px;">
                    <#if isAdmin>
                        <div class="d-flex align-items-center text-white px-3 text-decoration-none"
                             style="cursor: not-allowed; opacity: 0.6;">
                            <div class="rounded-circle d-flex justify-content-center align-items-center me-2"
                                 style="width: 36px; height: 36px; background: var(--light-blue); color: var(--dark-blue); font-weight: bold;">
                                ${name?substring(0, 1)?upper_case}
                            </div>
                            <div class="d-flex flex-column justify-content-center">
                                <span class="fw-semibold" style="font-size: 0.85rem;">${name}</span>
                                <small style="font-size: 0.7rem; color: var(--light-blue);">
                                    <@spring.message code="role.admin" />
                                </small>
                            </div>
                        </div>
                    <#else>
                        <a href="${profileUrl}" class="d-flex align-items-center text-white px-3 text-decoration-none">
                            <div class="rounded-circle d-flex justify-content-center align-items-center me-2"
                                 style="width: 36px; height: 36px; background: var(--light-blue); color: var(--dark-blue); font-weight: bold;">
                                ${name?substring(0, 1)?upper_case}
                            </div>
                            <div class="d-flex flex-column justify-content-center">
                                <span class="fw-semibold" style="font-size: 0.85rem;">${name}</span>
                                <small style="font-size: 0.7rem; color: var(--light-blue);">
                                    <#if isTeacher><@spring.message code="role.teacher" /></#if>
                                    <#if isStudent><@spring.message code="role.student" /></#if>
                                    <#if isOrganization><@spring.message code="role.organization" /></#if>
                                </small>
                            </div>
                        </a>
                    </#if>

                    <a href="/notifications"
                       class="d-flex align-items-center justify-content-center text-white position-relative"
                       style="width: 44px; height: 48px; background: transparent; border: none;">
                        <i class="fas fa-bell"></i>
                        <span id="notificationCountHeader"
                              class="position-absolute badge rounded-pill"
                              style="top: 2px; right: 2px; font-size: 0.6rem; display: none;
                     background-color: #dc3545; color: white; border: 1px solid white; padding: 2px 5px;">
                         0
                        </span>
                    </a>

                    <div style="width: 1px; height: 24px; background: rgba(255,255,255,0.3); margin: 0 0.5rem;"></div>

                    <form action="/logout" method="post" class="d-flex">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="d-flex align-items-center justify-content-center text-white"
                                style="width: 44px; height: 48px; background: transparent; border: none;">
                            <i class="fas fa-sign-out-alt"></i>
                        </button>
                    </form>
                </div>
            </#if>
        </header>
        <div class="main-content">
            <#nested>
        </div>
    </div>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const mainWrapper = document.getElementById('mainWrapper');

        function toggleMobileSidebar() {
            sidebar.classList.toggle('open');
            sidebarOverlay.classList.toggle('active');
        }

        function closeMobileSidebar() {
            sidebar.classList.remove('open');
            sidebarOverlay.classList.remove('active');
        }

        function toggleDesktopSidebar() {
            sidebar.classList.toggle('collapsed');
            sidebarToggle.classList.toggle('collapsed');
            mainWrapper.classList.toggle('collapsed');

            const icon = sidebarToggle.querySelector('i');
            if (sidebar.classList.contains('collapsed')) {
                icon.className = 'fas fa-chevron-right';
                localStorage.setItem('sidebarCollapsed', 'true');
            } else {
                icon.className = 'fas fa-bars';
                localStorage.setItem('sidebarCollapsed', 'false');
            }
        }

        if (mobileMenuBtn) {
            mobileMenuBtn.addEventListener('click', toggleMobileSidebar);
        }

        sidebarToggle.addEventListener('click', toggleDesktopSidebar);
        sidebarOverlay.addEventListener('click', closeMobileSidebar);

        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 768) {
                    closeMobileSidebar();
                }
            });
        });

        document.addEventListener('DOMContentLoaded', function () {
            const languageSelector = document.querySelector('.custom-language-selector');
            const selectedBtn = languageSelector.querySelector('#selectedLanguageBtn');
            const optionsContainer = languageSelector.querySelector('#languageOptions');
            const selectedFlag = document.querySelector('#selectedFlag');
            const selectedLanguageText = document.querySelector('#selectedLanguageText');

            const languageMap = {
                'ru': { name: '<@spring.message code="language.russian" />', flag: 'fi-ru' },
                'ky': { name: '<@spring.message code="language.kyrgyz" />', flag: 'fi-kg' },
                'en': { name: '<@spring.message code="language.english" />', flag: 'fi-gb' }
            };

            const urlParams = new URLSearchParams(window.location.search);
            let currentLang = 'ru';
            fetch('/api/users/current-language')
                .then(res => res.text())
                .then(lang => {
                    currentLang = lang;
                    updateSelectedLanguage(currentLang);
                });

            function updateSelectedLanguage(lang) {
                selectedFlag.className = 'fi ' + languageMap[lang].flag;
                selectedLanguageText.textContent = languageMap[lang].name;
            }


            selectedBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                optionsContainer.style.display = optionsContainer.style.display === 'block' ? 'none' : 'block';
            });

            optionsContainer.querySelectorAll('.language-option').forEach(option => {
                option.addEventListener('click', function () {
                    const lang = this.getAttribute('data-value');
                    <#if known>
                    const form = document.getElementById('languageForm');
                    const input = document.getElementById('languageInput');
                    const formData = new URLSearchParams();
                    formData.append('lang', lang);
                    formData.append('${_csrf.parameterName}', '${_csrf.token}');
                    input.value = lang;

                    fetch('/api/users/language', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'},
                        body: formData.toString()
                    })
                        .then(response => {
                            if (response.ok) {
                                updateSelectedLanguage(lang);
                                const url = new URL(window.location.href);
                                url.searchParams.set('lang', lang);
                                window.history.pushState({}, '', url);
                                window.location.reload();
                            } else {
                                console.error('Failed to update language');
                            }
                        })
                        .catch(error => console.error('Error:', error));
                    <#else>
                    const url = new URL(window.location.href);
                    url.searchParams.set('lang', lang);
                    window.location.href = url.toString();
                    </#if>
                });
            });

            document.addEventListener('click', function () {
                optionsContainer.style.display = 'none';
            });
        });

        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-link').forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && sidebar.classList.contains('open')) {
                closeMobileSidebar();
            }
        });

        document.addEventListener('DOMContentLoaded', function () {
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            if (isCollapsed && window.innerWidth > 768) {
                sidebar.classList.add('collapsed');
                sidebarToggle.classList.add('collapsed');
                mainWrapper.classList.add('collapsed');
                const icon = sidebarToggle.querySelector('i');
                icon.className = 'fas fa-chevron-right';
            }
        });

        window.addEventListener('resize', function () {
            if (window.innerWidth > 768) {
                sidebar.classList.remove('open');
                sidebarOverlay.classList.remove('active');
            } else {
                sidebar.classList.remove('collapsed');
                sidebarToggle.classList.remove('collapsed');
                mainWrapper.classList.remove('collapsed');
            }
        });
    </script>
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
            --sidebar-width: 280px;
            --sidebar-collapsed-width: 70px;
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, Helvetica, Arial, sans-serif;
            font-weight: 400;
            line-height: 1.5;
            letter-spacing: 0.01em;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            background-color: #f8f9fa;
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed-width);
            overflow-x: hidden;
        }

        .sidebar-profile .dropdown-menu {
            background: var(--dark-blue);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 0;
        }

        .sidebar-profile .dropdown-item {
            color: rgba(255, 255, 255, 0.9);
            padding: 0.5rem 1rem;
            transition: all 0.3s ease;
        }

        .sidebar-profile .dropdown-item:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--white);
        }

        .sidebar-profile .dropdown-item form button {
            background: none;
            border: none;
            width: 100%;
            text-align: left;
        }

        .sidebar-profile .btn-outline-secondary {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .sidebar-profile .btn-outline-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .sidebar.collapsed .dropdown {
            display: none;
        }

        .sidebar-toggle {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background: var(--primary-blue);
            color: var(--white);
            border: none;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
        }

        .sidebar-toggle:hover {
            background: var(--dark-blue);
            transform: scale(1.1);
        }

        .sidebar-toggle.collapsed {
            left: var(--sidebar-collapsed-width);
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
        }

        .sidebar-brand {
            color: var(--white);
            font-size: 1.0rem;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .sidebar.collapsed .sidebar-brand {
            justify-content: center;
        }

        .sidebar.collapsed .sidebar-brand span {
            display: none;
        }

        .sidebar-brand:hover {
            color: var(--light-blue);
            transform: translateX(5px);
        }

        .sidebar.collapsed .sidebar-brand:hover {
            transform: none;
        }

        .sidebar-brand i {
            font-size: 1.8rem;
        }

        .sidebar-content {
            flex: 1;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            min-height: 0;
            overflow-x: hidden;
        }

        .sidebar-nav {
            flex: 1;
            padding: 1rem 0;
            overflow-y: auto;
            overflow-x: hidden;
            min-height: 0;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .sidebar.collapsed .nav-section-title {
            opacity: 0;
            height: 0;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 0.8rem 1.5rem;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 0;
            position: relative;
            width: 100%;
            box-sizing: border-box;
        }

        .sidebar.collapsed .nav-link {
            justify-content: center;
            padding: 0.8rem;
        }

        .sidebar.collapsed .nav-link span {
            display: none;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: var(--light-blue);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--white);
            transform: translateX(5px);
        }

        .sidebar.collapsed .nav-link:hover {
            transform: none;
        }

        .nav-link:hover::before {
            transform: scaleY(1);
        }

        .nav-link.active {
            background: rgba(135, 206, 235, 0.2);
            color: var(--white);
        }

        .nav-link.active::before {
            transform: scaleY(1);
        }

        .nav-link i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }

        .sidebar.collapsed .nav-link {
            position: relative;
        }

        .sidebar.collapsed .nav-link::after {
            content: attr(data-tooltip);
            position: absolute;
            left: 100%;
            top: 50%;
            transform: translateY(-50%);
            background: var(--dark-blue);
            color: var(--white);
            padding: 0.5rem 0.8rem;
            border-radius: 4px;
            font-size: 0.85rem;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            margin-left: 10px;
            box-shadow: var(--shadow);
            z-index: 1002;
        }

        .sidebar.collapsed .nav-link:hover::after {
            opacity: 1;
            visibility: visible;
        }

        .sidebar-profile {
            flex-shrink: 0;
            padding: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
            max-height: 250px;
            overflow-y: auto;
            overflow-x: hidden;
            transition: all 0.3s ease;
        }

        .sidebar.collapsed .sidebar-profile {
            padding: 1rem 0.5rem;
            text-align: center;
            max-height: 200px;
            width: var(--sidebar-collapsed-width);
        }

        .profile-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .sidebar.collapsed .profile-info {
            justify-content: center;
            margin-bottom: 0.5rem;
        }

        .sidebar.collapsed .profile-info > div {
            display: none;
        }

        .profile-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--light-blue);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--dark-blue);
            font-weight: bold;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .profile-name {
            color: var(--white);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .profile-role {
            color: var(--light-blue);
            font-size: 0.8rem;
        }

        .profile-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .sidebar.collapsed .profile-actions {
            align-items: center;
        }

        .profile-btn {
            padding: 0.5rem 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: var(--white);
            text-decoration: none;
            text-align: center;
            font-size: 0.85rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            box-sizing: border-box;
        }

        .sidebar.collapsed .profile-btn {
            width: 40px;
            height: 40px;
            padding: 0;
            border-radius: 50%;
            margin-bottom: 8px;
        }

        .sidebar.collapsed .profile-btn span {
            display: none;
        }

        .profile-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: var(--white);
            transform: translateY(-2px);
        }

        .sidebar.collapsed .profile-btn:hover {
            transform: scale(1.1);
        }

        .sidebar-profile .dropdown-menu {
            overflow-x: hidden;
            max-width: 100%;
        }

        .custom-language-selector {
            position: relative;
            width: 100%;
            margin-bottom: 1rem;
        }

        .selected-language {
            width: 100%;
            padding: 0.67rem 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: var(--white);
            text-align: left;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 0.85rem;
        }

        .language-options {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            background: var(--dark-blue);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            margin-top: 5px;
            z-index: 100;
            overflow-x: hidden;
            overflow-y: auto;
            max-height: 200px;
            white-space: nowrap;
        }

        .language-option {
            padding: 0.4rem 0.8rem;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: background 0.2s;
            color: var(--white);
            font-size: 0.85rem;
        }

        .language-option:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .fi {
            width: 20px;
            height: 15px;
            border-radius: 2px;
            display: inline-block;
            background-size: cover;
        }

        .sidebar.collapsed .custom-language-selector {
            display: none;
        }

        .main-wrapper {
            margin-left: var(--sidebar-width);
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .main-wrapper.collapsed {
            margin-left: var(--sidebar-collapsed-width);
        }

        .top-header {
            background: var(--white);
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
        }

        .main-content {
            padding: 2rem;
            padding-top: 4rem;
        }

        .sidebar.collapsed #notificationCount,
        .sidebar.collapsed #notificationCountStudent {
            display: none !important;
        }

        .sidebar.collapsed .nav-link.d-flex {
            justify-content: center !important;
        }

        .sidebar.collapsed .nav-link .badge {
            display: none !important;
        }

        .sidebar.collapsed .nav-link div {
            justify-content: center;
        }

        .hero-section {
            background: linear-gradient(135deg, rgba(0, 102, 204, 0.1), rgba(135, 206, 235, 0.1));
            border-radius: 15px;
            padding: 3rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .hero-title {
            color: var(--primary-blue);
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .hero-subtitle {
            color: var(--text-dark);
            font-size: 1.2rem;
            margin-bottom: 2rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-weight: 500;
            color: var(--white);
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .feature-card {
            background: var(--white);
            border-radius: 10px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
            transition: transform 0.3s ease;
            border-left: 4px solid var(--primary-blue);
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
            color: var(--white);
        }

        .sidebar-content::-webkit-scrollbar,
        .sidebar-nav::-webkit-scrollbar,
        .sidebar-profile::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar-content::-webkit-scrollbar-track,
        .sidebar-nav::-webkit-scrollbar-track,
        .sidebar-profile::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar-content::-webkit-scrollbar-thumb,
        .sidebar-nav::-webkit-scrollbar-thumb,
        .sidebar-profile::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        .sidebar-content::-webkit-scrollbar-thumb:hover,
        .sidebar-nav::-webkit-scrollbar-thumb:hover,
        .sidebar-profile::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }

        @media (max-width: 768px) {
            .sidebar-toggle {
                display: none;
            }

            .sidebar {
                transform: translateX(-100%);
                width: 100%;
                max-width: var(--sidebar-width);
                overflow-x: hidden;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main-wrapper {
                margin-left: 0;
            }

            .main-wrapper.collapsed {
                margin-left: 0;
            }

            .main-content {
                padding-top: 1rem;
            }

            .top-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .mobile-menu-btn {
                background: none;
                border: none;
                color: var(--primary-blue);
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0.5rem;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .mobile-menu-btn:hover {
                background: rgba(0, 102, 204, 0.1);
            }

            .hero-title {
                font-size: 2rem;
            }

            .hero-section {
                padding: 2rem 1rem;
            }

            .main-content {
                padding: 1rem;
            }

            .sidebar-profile {
                max-height: none;
                overflow-x: hidden;
            }
        }

        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .sidebar-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .sidebar-profile.authorized {
            height: 13rem;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script src="/static/js/websocket-notifications.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            updateNotificationCount();
        });
        window.addEventListener('load', function () {
            document.body.style.visibility = 'visible';
            document.body.style.display = 'block';
        });
    </script>
    </body>
    </html>
</#macro>