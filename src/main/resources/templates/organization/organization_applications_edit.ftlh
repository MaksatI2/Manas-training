<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<#assign pageTitle = springMacroRequestContext.getMessage("application.organization.edit.title")>
<#assign bcHome    = springMacroRequestContext.getMessage("application.organization.edit.breadcrumb.home")>
<#assign bcList    = springMacroRequestContext.getMessage("application.organization.edit.breadcrumb.list")>
<#assign bcEdit    = springMacroRequestContext.getMessage("application.organization.edit.breadcrumb.edit")>

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>

<@layout.page title=pageTitle>
    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
        }

        .card-custom {
            background: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.08);
            overflow: hidden;
            transition: 0.3s ease;
        }

        .card-custom:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.15);
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            padding: 1rem 1.25rem;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-body-custom {
            padding: 1.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .btn-outline-secondary:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            color: #2c3e50;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
        }

        .me-1 {
            margin-right: 0.25rem;
        }

        .me-2 {
            margin-right: 0.5rem;
        }
    </style>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcList, "url": "/applications/organization"},
    {"label": bcEdit, "url": ""}
    ] />

    <div class="card-custom mb-4">
        <div class="card-header-custom">
            <h5 class="m-0"><i class="fas fa-edit me-2"></i> ${bcEdit}</h5>
            <div class="d-flex align-items-center">
                <a href="/applications/organization/calendar" class="btn btn-light btn-sm me-2"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-calendar-alt me-1"
                       style="color: #0066cc;"></i> <@spring.message code='application.organization.edit.calendar'/>
                </a>
                <a href="/applications/organization" class="btn btn-light btn-sm"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-arrow-left me-1"
                       style="color: #0066cc;"></i> <@spring.message code='application.organization.edit.back'/>
                </a>
            </div>
        </div>

        <div class="card-body-custom">
            <#if errors?? && errors.hasGlobalErrors()>
                <div class="alert alert-danger small">
                    <#list errors.globalErrors as err>${err.defaultMessage}<br/></#list>
                </div>
            </#if>
            <form method="post" action="/applications/organization/${id}/edit">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="courseId"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.course'/></label>
                            <select class="form-select" name="courseId" id="courseId" required>
                                <option value=""><@spring.message code='application.organization.edit.course.placeholder'/></option>
                                <#list courses as course>
                                    <option value="${course.id}"
                                            <#if course.id == application.courseId>selected</#if>>${course.title}</option>
                                </#list>
                            </select>
                            <#if errors?? && errors.hasFieldErrors("courseId")>
                                <div class="text-danger small mt-1">${errors.getFieldError("courseId").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="preferredTeacherId"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.preferredTeacher'/></label>
                            <select class="form-select" name="preferredTeacherId" id="preferredTeacherId">
                                <option value=""><@spring.message code='application.organization.edit.preferredTeacher.placeholder'/></option>
                                <#list teachers as teacher>
                                    <option value="${teacher.id}"
                                            <#if application.preferredTeacherId?? && teacher.id == application.preferredTeacherId>selected</#if>>${teacher.fullName}</option>
                                </#list>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="preferredStartDate"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.preferredStart'/></label>
                            <input type="date" class="form-control" name="preferredStartDate" id="preferredStartDate"
                                   value="${(application.preferredStartDate)?if_exists}">
                            <#if errors?? && errors.hasFieldErrors("preferredStartDate")>
                                <div class="text-danger small mt-1">${errors.getFieldError("preferredStartDate").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="preferredEndDate"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.preferredEnd'/></label>
                            <input type="date" class="form-control" name="preferredEndDate" id="preferredEndDate"
                                   value="${(application.preferredEndDate)?if_exists}">
                            <#if errors?? && errors.hasFieldErrors("preferredEndDate")>
                                <div class="text-danger small mt-1">${errors.getFieldError("preferredEndDate").defaultMessage}</div>
                            </#if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="employeeIds"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.employees'/></label>
                            <select id="employeeIds" name="employeeIds" class="form-select" multiple required>
                                <#list employees as emp>
                                    <option value="${emp.id}"
                                            <#if application.employeeIds?? && application.employeeIds?seq_contains(emp.id)>selected</#if>>${emp.fullName}
                                        &lt;${emp.email}&gt;
                                    </option>
                                </#list>
                            </select>
                            <#if errors?? && errors.hasFieldErrors("employeeIds")>
                                <div class="text-danger small mt-1">${errors.getFieldError("employeeIds").defaultMessage}</div>
                            </#if>
                        </div>

                        <div class="mb-3">
                            <label for="outgoingCode"
                                   class="form-label fw-bold"><@spring.message code='application.organization.edit.outgoingCode'/></label>
                            <input type="text" class="form-control" name="outgoingCode" id="outgoingCode"
                                   value="${application.outgoingCode!}" required>
                            <#if errors?? && errors.hasFieldErrors("outgoingCode")>
                                <div class="text-danger small mt-1">${errors.getFieldError("outgoingCode").defaultMessage}</div>
                            </#if>
                        </div>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i> <@spring.message code='application.organization.edit.save'/>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const element = document.getElementById('employeeIds');
            new Choices(element, {
                removeItemButton: true,
                searchResultLimit: 10,
                searchPlaceholderValue: '<@spring.message code="application.organization.edit.employees.searchPlaceholder"/>',
                placeholder: true,
                shouldSort: false
            });
            const courseSelect = document.getElementById('courseId');
            const teacherSelect = document.getElementById('preferredTeacherId');

            function loadTeachers(courseId) {
                teacherSelect.innerHTML = '<option value=""><@spring.message code="application.organization.edit.preferredTeacher.placeholder"/></option>';
                if (courseId) {
                    fetch('/api/courses/' + courseId + '/teachers')
                        .then(response => response.json())
                        .then(data => {
                            data.forEach(teacher => {
                                const option = document.createElement('option');
                                option.value = teacher.id;
                                option.textContent = teacher.fullName + ' (' + teacher.email + ')';
                                teacherSelect.appendChild(option);
                            });
                        })
                        .catch(error => console.error('<@spring.message code="application.organization.edit.error.loadTeachers"/>', error));
                }
            }

            courseSelect.addEventListener('change', () => loadTeachers(courseSelect.value));
            if (courseSelect.value) {
                loadTeachers(courseSelect.value);
            }
        });
    </script>
</@layout.page>
