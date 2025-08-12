<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page>
    <#assign bcHome = springMacroRequestContext.getMessage("course.participants.breadcrumb.home")>
    <#assign bcInstances = springMacroRequestContext.getMessage("course.participants.breadcrumb.instances")>
    <#assign bcInstance = springMacroRequestContext.getMessage("course.participants.breadcrumb.instance", [courseInstance.id?string])>
    <#assign bcParticipants = springMacroRequestContext.getMessage("course.participants.breadcrumb.participants")>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcInstances, "url": "/admin/course-instances"},
    {"label": bcInstance, "url": "/admin/course-instances/${courseInstance.id}"},
    {"label": bcParticipants, "url": ""}
    ] />
    <div class="container py-4">
        <div class="hero-section mb-4 text-center">
            <h2 class="hero-title mb-2">
                ${springMacroRequestContext.getMessage("course.participants.title", [courseInstance.title!""])}
            </h2>
            <p class="hero-subtitle fs-5 text-muted">
                ${springMacroRequestContext.getMessage("course.participants.currentStream", [courseInstance.title!""])}
            </p>
        </div>

        <#if errorMessage??>
            <div class="alert alert-danger mt-3 mx-auto" style="max-width: 600px;">
                ${errorMessage}
            </div>
        </#if>

        <div class="feature-card mb-5 p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3"><@spring.message code="course.participants.current.title"/></h3>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 30%;"><@spring.message code="course.participants.table.name"/></th>
                        <th scope="col" style="width: 20%;"><@spring.message code="course.participants.table.enrollmentDate"/></th>
                        <th scope="col" style="width: 10%;"><@spring.message code="course.participants.table.grade"/></th>
                        <th scope="col" style="width: 20%;"><@spring.message code="course.participants.table.status"/></th>
                        <th scope="col" style="width: 20%;"><@spring.message code="course.participants.table.action"/></th>
                    </tr>
                    </thead>
                    <tbody id="current-participants">
                    <#list enrollments as enrollment>
                        <tr data-enrollment-id="${enrollment.id}">
                            <td>${enrollment.studentName!''}</td>
                            <td>${enrollment.formattedEnrollmentDate}</td>
                            <td>${(enrollment.finalGrade?string['0.##'])!'–'}</td>
                            <td>
                <span class="badge
                    <#if enrollment.status == 'ENROLLED'>bg-success<#else>bg-secondary</#if>">
                    <#if enrollment.status == 'ENROLLED'>
                        <@spring.message code="course.participants.status.enrolled"/>
                    <#else>
                        <@spring.message code="course.participants.status.expelled"/>
                    </#if>
                </span>
                            </td>
                            <td>
                                <form method="post"
                                      action="/admin/course-instances/${courseInstance.id}/participants/toggle-status/${enrollment.id}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit"
                                            class="btn btn-sm
                            <#if enrollment.status == 'ENROLLED'>btn-outline-danger<#else>btn-outline-success</#if>">
                                        <#if enrollment.status == 'ENROLLED'>
                                            <@spring.message code="course.participants.action.expel"/>
                                        <#else>
                                            <@spring.message code="course.participants.action.restore"/>
                                        </#if>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>


            </div>
        </div>

        <div class="feature-card p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3"><@spring.message code="course.participants.addFromApplications"/></h3>
            <form id="participant-form" action="/admin/course-instances/${courseInstance.id}/participants/add" method="post" novalidate>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div id="new-participants-container" class="mb-4">
                    <#if (participantForm.pendingEmployeeIds)?? && participantForm.pendingEmployeeIds?has_content>
                        <#list pendingEmployees as employee>
                            <#if participantForm.pendingEmployeeIds?seq_contains(employee.id)>
                                <div class="new-participant-section mb-3 p-3 border rounded" data-employee-id="${employee.id}">
                                    <div class="row align-items-center">
                                        <div class="col-md-1">
                                            <input type="checkbox" class="form-check-input" name="pendingEmployeeIds" value="${employee.id}" checked>
                                        </div>
                                        <div class="col-md-6">
                                            <span>${employee.employeeName!''}</span>
                                        </div>
                                        <div class="col-md-5">
                                            <span>${springMacroRequestContext.getMessage("course.participants.applicationNumber", [employee.applicationId?string])}</span>
                                        </div>
                                    </div>
                                </div>
                            </#if>
                        </#list>
                    </#if>
                    <#list pendingEmployees as employee>
                        <#if !(participantForm.pendingEmployeeIds?seq_contains(employee.id))>
                            <div class="new-participant-section mb-3 p-3 border rounded" data-employee-id="${employee.id}">
                                <div class="row align-items-center">
                                    <div class="col-md-1">
                                        <input type="checkbox" class="form-check-input" name="pendingEmployeeIds" value="${employee.id}">
                                    </div>
                                    <div class="col-md-6">
                                        <span>${employee.employeeName!''}</span>
                                    </div>
                                    <div class="col-md-5">
                                        <span>${springMacroRequestContext.getMessage("course.participants.applicationNumber", [employee.applicationId?string])}</span>
                                    </div>
                                </div>
                            </div>
                        </#if>
                    </#list>
                </div>

                <div class="d-flex gap-2 flex-wrap">
                    <button type="submit" class="btn btn-primary">
                        <@spring.message code="course.participants.addButton"/>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="/static/js/participants.js" defer></script>

    <style>
        .hero-title {
            font-weight: 700;
            color: #343a40;
        }
        .hero-subtitle {
            font-weight: 500;
        }

        .feature-card {
            background-color: #fff;
            border-radius: 0.375rem;
            box-shadow: 0 0.125rem 0.25rem rgb(0 0 0 / 0.075);
        }

        table.table-hover tbody tr:hover {
            background-color: #f1f3f5;
            cursor: pointer;
        }

        button.btn-success {
            min-width: 140px;
        }

        .new-participant-section {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }
        .new-participant-section:hover {
            box-shadow: 0 0.5rem 1rem rgb(0 0 0 / 0.1);
            transform: translateY(-2px);
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .form-check-input {
            margin-top: 0;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }
    </style>
</@layout.page>