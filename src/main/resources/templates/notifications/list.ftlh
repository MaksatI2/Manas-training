<#import "../layout.ftlh" as layout>

<@layout.page title="Мои уведомления">
    <div class="container mt-4">
        <h2 class="mb-4" style="color: var(--primary-blue); font-weight: 600; font-size: 2.5rem;">
            <i class="fas fa-bell me-2"></i>Мои уведомления
        </h2>

        <div class="mb-4 d-flex gap-3">
            <button id="markAllBtn" class="btn btn-outline-success btn-sm">
                <i class="fas fa-check-double me-1"></i> Прочитать все
            </button>
            <button id="clearAllBtn" class="btn btn-outline-danger btn-sm">
                <i class="fas fa-trash me-1"></i> Очистить все
            </button>
        </div>

        <#if notifications?size == 0>
            <div class="text-center my-5">
                <i class="fas fa-inbox fa-3x mb-3" style="color: var(--light-blue);"></i>
                <p class="text-muted" style="font-size: 1.1rem;">Уведомлений пока нет.</p>
            </div>
        <#else>
            <div class="d-flex flex-column gap-3">
                <#list notifications as n>
                    <div class="p-4 rounded shadow-sm"
                         style="
                                 background: var(--white);
                                 border-left: 4px solid var(--primary-blue);
                                 border-radius: 10px;
                                 box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
                                 transition: transform 0.3s;
                         <#if !n.isRead>background-color: rgba(255, 204, 0, 0.1);</#if>
                                 "
                         onmouseover="this.style.transform='translateY(-5px)'"
                         onmouseout="this.style.transform='none'">

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="m-0" style="color: var(--primary-blue); font-weight: 600;">
                                ${n.title}
                            </h5>
                            <small class="text-muted">${n.formattedCreatedAt}</small>
                        </div>

                        <p class="mb-3" style="color: var(--text-dark);">${n.body}</p>
                        <#assign url = n.link>
                        <#if !url?has_content>
                            <#assign url = "">
                            <#if isAdmin?? && isAdmin>
                                <#if n.targetType == "COURSE_APPLICATION">
                                    <#assign url = "/applications/admin/" + n.targetId>
                                </#if>
                            <#elseif isOrganization?? && isOrganization>
                                <#if n.targetType == "COURSE_APPLICATION">
                                    <#assign url = "/applications/organization/" + n.targetId>
                                </#if>
                            <#elseif isStudent?? && isStudent>
                                <#if n.targetType == "COURSE_APPLICATION">
                                    <#assign url = "/applications/student/applications">
                                </#if>
                            <#elseif isTeacher?? && isTeacher>
                                <#if n.targetType == "NEW_SCHEDULE">
                                    <#assign url = "/schedules">
                                </#if>
                            </#if>
                        </#if>

                        <#if url?has_content>
                            <a href="${url}" class="btn btn-sm"
                               style="
                                   border-radius: 25px;
                                   padding: 0.4rem 1.2rem;
                                   background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
                                   color: white;
                                   text-decoration: none;
                                   transition: 0.3s;
                               "
                               onmouseover="this.style.transform='translateY(-2px)'"
                               onmouseout="this.style.transform='none'">
                                Открыть
                            </a>
                        </#if>
                    </div>
                </#list>
            </div>
        </#if>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const markBtn = document.getElementById('markAllBtn');
            const clearBtn = document.getElementById('clearAllBtn');
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            if (markBtn) {
                markBtn.addEventListener('click', () => {
                    fetch('/api/notifications/mark-all', {
                        method: 'POST',
                        headers: {
                            [csrfHeader]: csrfToken
                        }
                    }).then(() => location.reload());
                });
            }

            if (clearBtn) {
                clearBtn.addEventListener('click', () => {
                    if (confirm('Вы уверены, что хотите удалить все уведомления?')) {
                        fetch('/api/notifications/clear', {
                            method: 'DELETE',
                            headers: {
                                [csrfHeader]: csrfToken
                            }
                        }).then(() => location.reload());
                    }
                });
            }
        });
    </script>
</@layout.page>
