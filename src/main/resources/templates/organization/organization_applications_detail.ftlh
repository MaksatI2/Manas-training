<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<#assign dateFormat = "dd.MM.yyyy">
<#assign dateTimeFormat = "dd.MM.yyyy HH:mm">
<#assign pageTitle = springMacroRequestContext.getMessage("application.organization.detail.title")>
<#assign bcHome    = springMacroRequestContext.getMessage("application.organization.detail.breadcrumb.home")>
<#assign bcList    = springMacroRequestContext.getMessage("application.organization.detail.breadcrumb.list")>
<#assign bcView    = springMacroRequestContext.getMessage("application.organization.detail.breadcrumb.view", [application.id])>

<@layout.page title=pageTitle>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcList, "url": "/applications/organization"},
    {"label": bcView, "url": ""}
    ] />

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
            margin-bottom: 2rem;
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

        .badge {
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 0.375rem;
            padding: 0.35em 0.65em;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #212529 !important;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-danger {
            background-color: #dc3545 !important;
        }

        .bg-secondary {
            background-color: #6c757d !important;
        }

        .me-1 {
            margin-right: 0.25rem;
        }

        .me-2 {
            margin-right: 0.5rem;
        }

        .btn-light:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.2);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-blue);
        }

        .employee-list {
            padding-left: 0.25rem;
        }

        .employee-item {
            padding: 0.4rem 0;
            border-bottom: 1px dashed #ddd;
            font-size: 0.95rem;
            color: #333;
            display: flex;
            align-items: center;
        }

        .employee-item:last-child {
            border-bottom: none;
        }

        .employee-item i {
            color: #6c757d;
            margin-right: 0.5rem;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 140px;
        }

    </style>

    <div class="card-custom">
        <div class="card-header-custom">
            <h5 class="m-0">
                <i class="fas fa-file-alt me-2"></i> ${bcView}
            </h5>
            <a href="/applications/organization" class="btn btn-light btn-sm"
               style="border-radius: 25px; background: white; color: var(--primary-blue); border: 1px solid var(--primary-blue);">
                <i class="fas fa-arrow-left me-1"
                   style="color: var(--primary-blue);"></i> <@spring.message code='application.organization.detail.back'/>
            </a>
        </div>

        <div class="card-body-custom">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <strong><@spring.message code='application.organization.detail.course'/>:</strong><br>
                    ${application.courseTitle!"—"}
                </div>
                <div class="col-md-6 mb-3">
                    <strong><@spring.message code='application.organization.detail.companyCode'/>:</strong><br>
                    ${application.outgoingCode!"—"}
                </div>
                <div class="col-md-6 mb-3">
                    <strong><@spring.message code='application.organization.detail.status'/>:</strong><br>
                    <span class="badge status-badge
                        <#if application.status == "PENDING">bg-warning
                        <#elseif application.status == "APPROVED">bg-success
                        <#elseif application.status == "REJECTED">bg-danger
                        <#else>bg-secondary</#if>">
                        <#if application.status == "PENDING">
                            <@spring.message code="application.organization.detail.status.pending"/>
                        <#elseif application.status == "APPROVED">
                            <@spring.message code="application.organization.detail.status.approved"/>
                        <#elseif application.status == "REJECTED">
                            <@spring.message code="application.organization.detail.status.rejected"/>
                        <#else>
                            <@spring.message code="application.organization.detail.status.other"/>
                        </#if>
                    </span>
                </div>

                <div class="col-md-6 mb-3">
                    <strong><@spring.message code='application.organization.detail.submissionDate'/>:</strong><br>
                    ${application.formattedSubmittedAt!"—"}
                </div>

                <#if application.preferredTeacher??>
                    <div class="col-md-6 mb-3">
                        <strong><@spring.message code='application.organization.detail.preferredTeacher'/>:</strong><br>
                        ${application.preferredTeacher.name} ${application.preferredTeacher.lastName}
                    </div>
                </#if>

                <#if application.formattedPreferredStartDate??>
                    <div class="col-md-6 mb-3">
                        <strong><@spring.message code='application.organization.detail.preferredStart'/>:</strong><br>
                        ${application.formattedPreferredStartDate}
                    </div>
                </#if>

                <#if application.formattedPreferredEndDate??>
                    <div class="col-md-6 mb-3">
                        <strong><@spring.message code='application.organization.detail.preferredEnd'/>:</strong><br>
                        ${application.formattedPreferredEndDate}
                    </div>
                </#if>
            </div>

            <h6 class="mt-4 section-title">
                <i class="fas fa-users me-2 text-primary"></i> <@spring.message code='application.organization.detail.employees'/>
            </h6>
            <div class="employee-list mb-4">
                <#list application.employees as emp>
                    <div class="employee-item">
                        <i class="fas fa-user"></i>
                        <span>${emp.fullName} &lt;${emp.email}&gt;</span>
                    </div>
                </#list>
            </div>
        </div>
    </div>

    <div class="card-custom">
        <div class="card-header-custom" style="background: #f8f9fa; color: #333; font-weight: 600;">
            <i class="fas fa-comments me-2 text-secondary"></i><@spring.message code='application.organization.detail.comments'/>
        </div>
        <div class="card-body-custom">
            <#if comments?size == 0>
                <p class="text-muted"><@spring.message code='application.organization.detail.noComments'/></p>
            <#else>
                <ul class="list-group list-group-flush mb-0">
                    <#list comments as c>
                        <li class="list-group-item">
                            <div class="fw-bold">${c.authorName}</div>
                            <div>${c.comment}</div>
                            <div class="text-muted small">${c.formattedCreatedAt!"—"}</div>
                        </li>
                    </#list>
                </ul>
            </#if>
        </div>
    </div>
    <script>
        const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
        fetch('/api/notifications/mark-all-as-read?targetType=COURSE_APPLICATION', {
            method: 'POST',
            headers: {[csrfHeader]: csrfToken}
        }).then(() => {
            updateNotificationCount();
        });
    </script>
</@layout.page>
