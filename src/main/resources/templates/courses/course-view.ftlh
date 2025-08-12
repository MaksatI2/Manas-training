<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getUsername()>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
    <#assign isStudent = roles?contains("STUDENT")>
    <#assign isOrganization = roles?contains("ORGANIZATION")>
<#else>
    <#assign isAdmin = false>
    <#assign isTeacher = false>
    <#assign isStudent = false>
    <#assign isOrganization = false>
</#if>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": springMacroRequestContext.getMessage("course.public.view.breadcrumb.home"), "url": "/"},
    {"label": springMacroRequestContext.getMessage("course.public.view.breadcrumb.courses"), "url": "/courses"},
    {"label": course.title, "url": ""}
    ] />
    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <div class="card-header py-3 d-flex justify-content-between align-items-center"
             style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-book me-2"></i>
                <@spring.message code="course.public.view.title"/>
            </h5>
            <div>
                <a href="/courses" class="btn btn-light btn-sm me-2"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1"
                       style="color: #0066cc;"></i> <@spring.message code="course.public.view.backToList"/>
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <div class="course-info">
                        <div class="course-header mb-4">
                            <h2 class="course-title">${course.title}</h2>
                            <div class="course-badges mt-2">
                                <span class="badge course-code">${course.code}</span>
                                <span class="badge bg-primary">${course.category.name}</span>
                                <#if course.active>
                                    <span class="badge bg-success">
                                        <i class="fas fa-check-circle me-1"></i><@spring.message code="course.public.view.badge.active"/>
                                    </span>
                                <#else>
                                    <span class="badge bg-warning">
                                        <i class="fas fa-times-circle me-1"></i><@spring.message code="course.public.view.badge.inactive"/>
                                    </span>
                                </#if>
                                <span class="badge bg-info">
                                    <i class="fas fa-users me-1"></i><@spring.message code="course.public.view.badge.group"/>
                                </span>
                            </div>
                        </div>

                        <div class="course-details">
                            <div class="detail-item mb-3">
                                <label class="detail-label">
                                    <i class="fas fa-clock me-2" style="color: #0066cc;"></i>
                                    <@spring.message code="course.public.view.duration.label"/>
                                </label>
                                <span class="detail-value">${course.duration} <@spring.message code="course.public.view.duration.unit"/></span>
                            </div>

                            <#if course.description?? && course.description != ''>
                                <div class="detail-item mb-4">
                                    <label class="detail-label">
                                        <i class="fas fa-align-left me-2" style="color: #0066cc;"></i>
                                        <@spring.message code="course.public.view.description.label"/>
                                    </label>
                                    <div class="detail-value description-text">
                                        ${course.description}
                                    </div>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="course-meta">
                        <div class="meta-card">
                            <h6 class="meta-title">
                                <i class="fas fa-info-circle me-2" style="color: #0066cc;"></i>
                                <@spring.message code="course.public.view.meta.title"/>
                            </h6>

                            <div class="meta-item">
                                <small class="meta-label"><@spring.message code="course.public.view.meta.category"/></small>
                                <span class="meta-value">${course.category.name}</span>
                            </div>

                            <#if course.category.description?? && course.category.description != ''>
                                <div class="meta-item">
                                    <small class="meta-label"><@spring.message code="course.public.view.meta.categoryDescription"/></small>
                                    <span class="meta-value">${course.category.description}</span>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>

            <div id="deleteCourseModal" class="modal fade" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><@spring.message code="course.public.view.modal.delete.title"/></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div id="depList"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal"><@spring.message code="course.public.view.modal.delete.cancel"/></button>
                            <button type="button" id="confirmDeleteCourse"
                                    class="btn btn-danger"><@spring.message code="course.public.view.modal.delete.confirm"/></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const modalEl = document.getElementById('deleteCourseModal');
            const deleteModal = new bootstrap.Modal(modalEl);
            const depList = document.getElementById('depList');
            const confirmBtn = document.getElementById('confirmDeleteCourse');
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

            const i18n = {
                depsApplications: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.dependencies.applications')?js_string}",
                depsInstances: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.dependencies.instances')?js_string}",
                depsTeachers: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.dependencies.teachers')?js_string}",
                deleteImpossible: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.impossible')?js_string}",
                noDeps: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.noDependencies')?js_string}",
                delete: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.confirm')?js_string}",
                deleteSuccess: "${springMacroRequestContext.getMessage('course.public.view.modal.delete.success')?js_string}"
            };

            document.querySelectorAll('.js-delete-course-btn').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    const courseId = btn.dataset.courseId;
                    fetch('/admin/courses/api/' + courseId + '/dependencies')
                        .then(function (res) {
                            return res.json();
                        })
                        .then(function (deps) {
                            depList.innerHTML = '';
                            if (deps.applications && deps.applications.length) {
                                let html = '<h6>' + i18n.depsApplications + '</h6><ul>';
                                deps.applications.forEach(function (a) {
                                    html += '<li>' + (a.name) + '</li>';
                                });
                                html += '</ul>';
                                depList.insertAdjacentHTML('beforeend', html);
                            }

                            if (deps.instances && deps.instances.length) {
                                let html = '<h6>' + i18n.depsInstances + '</h6><ul>';
                                deps.instances.forEach(function (i) {
                                    html += '<li>' + (i.name || i.title) + '</li>';
                                });
                                html += '</ul>';
                                depList.insertAdjacentHTML('beforeend', html);
                            }

                            if (deps.teachers && deps.teachers.length) {
                                let html = '<h6>' + i18n.depsTeachers + '</h6><ul>';
                                deps.teachers.forEach(function (t) {
                                    html += '<li>' + t.name + '</li>';
                                });
                                html += '</ul>';
                                depList.insertAdjacentHTML('beforeend', html);
                            }

                            const hasDeps =
                                (deps.applications && deps.applications.length) ||
                                (deps.instances && deps.instances.length) ||
                                (deps.teachers && deps.teachers.length);

                            if (hasDeps) {
                                confirmBtn.disabled = true;
                                confirmBtn.textContent = i18n.deleteImpossible;
                                confirmBtn.onclick = null;
                            } else {
                                depList.insertAdjacentHTML('beforeend', '<p>' + i18n.noDeps + '</p>');
                                confirmBtn.disabled = false;
                                confirmBtn.textContent = i18n.delete;
                                confirmBtn.onclick = function () {
                                    fetch('/admin/courses/api/' + courseId, {
                                        method: 'DELETE',
                                        headers: {
                                            [csrfHeader]: csrfToken
                                        }
                                    })
                                        .then(r => {
                                            if (r.ok) {
                                                localStorage.setItem('flashMessage', JSON.stringify({
                                                    type: 'success',
                                                    text: i18n.deleteSuccess,
                                                    duration: 4000
                                                }));
                                                window.location.href = '/admin/courses';
                                            } else {
                                                return r.json().then(err => {
                                                    throw new Error(err.message || 'Unknown error')
                                                });
                                            }
                                        })
                                        .catch(err => {
                                            console.error('Delete failed:', err);
                                            alert(err.message);
                                        });
                                };
                            }

                            deleteModal.show();
                        });
                });
            });
        });
    </script>

    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .course-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 0;
        }

        .course-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.375rem;
        }

        .course-code {
            background: #87ceeb;
            color: #2c3e50;
            border: 1px solid #c6d9ec;
        }

        .bg-primary {
            background-color: #0066cc !important;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #212529 !important;
        }

        .bg-info {
            background-color: #17a2b8 !important;
        }

        .bg-secondary {
            background-color: #6c757d !important;
        }

        .bg-danger {
            background-color: #dc3545 !important;
        }

        .detail-item {
            border-bottom: 1px solid #e3e6f0;
            padding-bottom: 0.75rem;
        }

        .detail-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .detail-label {
            font-weight: 600;
            color: #2c3e50;
            display: block;
            margin-bottom: 0.25rem;
        }

        .detail-value {
            color: #495057;
            font-size: 0.95rem;
        }

        .description-text {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid #0066cc;
            margin-top: 0.5rem;
            line-height: 1.5;
        }

        .meta-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            border: 1px solid #e3e6f0;
        }

        .meta-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #0066cc;
        }

        .meta-item {
            margin-bottom: 0.75rem;
            display: flex;
            flex-direction: column;
        }

        .meta-item:last-child {
            margin-bottom: 0;
        }

        .meta-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .meta-value {
            color: #2c3e50;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        .btn {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }

        .w-100 {
            width: 100%;
        }

        .mb-2 {
            margin-bottom: 0.5rem;
        }

        .me-1 {
            margin-right: 0.25rem;
        }

        .me-2 {
            margin-right: 0.5rem;
        }

        @media (max-width: 768px) {
            .course-badges {
                justify-content: flex-start;
            }

            .meta-card {
                margin-top: 2rem;
            }

            .btn-sm {
                font-size: 0.875rem;
                padding: 0.375rem 0.75rem;
            }
        }
    </style>
</@layout.page>
