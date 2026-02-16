<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#setting datetime_format="dd.MM.yyyy HH:mm">
<#setting date_format="dd.MM.yyyy">

<#assign bcHome = springMacroRequestContext.getMessage("organization.applications.list.breadcrumb.home")>
<#assign bcApps = springMacroRequestContext.getMessage("organization.applications.list.breadcrumb.applications")>

<@layout.page title="<@spring.message code='organization.applications.list.title'/>">
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcApps, "url": ""}
    ] />

    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="card shadow mb-4">
        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="m-0 font-weight-bold text-white mb-2 mb-md-0">
                    <i class="fas fa-list me-2"></i> <@spring.message code="organization.applications.list.header"/>
                </h5>
                <a href="/applications/organization/create" class="btn btn-sm"
                   style="border-radius: 25px; background-color: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-plus me-1"></i> <@spring.message code="organization.applications.list.create"/>
                </a>
            </div>
        </div>

        <div class="table-responsive p-3">
            <#if applications?size == 0>
                <div class="alert alert-info mb-0"><@spring.message code="organization.applications.list.notfound"/></div>
            <#else>
                <table id="applicationsTable" class="table table-hover table-bordered align-middle display nowrap"
                       width="100%">
                    <thead>
                    <tr>
                        <th><@spring.message code="organization.applications.list.table.number"/></th>
                        <th><@spring.message code="organization.applications.list.table.course"/></th>
                        <th><@spring.message code="organization.applications.list.table.teacher"/></th>
                        <th><@spring.message code="organization.applications.list.table.start"/></th>
                        <th><@spring.message code="organization.applications.list.table.end"/></th>
                        <th><@spring.message code="organization.applications.list.table.status"/></th>
                        <th><@spring.message code="organization.applications.list.table.submitted"/></th>
                        <th class="text-center"><@spring.message code="organization.applications.list.table.actions"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list applications as app>
                        <tr class="clickable-row" data-href="/applications/organization/${app.id}">
                            <td>${app?index + 1}</td>
                            <td>
                                <#if (app.courseTitle?? && app.courseTitle?length > 10)>
                                    ${app.courseTitle?substring(0, 10)}...
                                <#else>
                                    ${app.courseTitle!""}
                                </#if>
                            </td>
                            <td>
                                <#if app.preferredTeacher??>
                                    <#assign fullName = app.preferredTeacher.name + " " + app.preferredTeacher.lastName>
                                    <#if (fullName?length > 20)>
                                        ${fullName?substring(0, 20)}...
                                    <#else>
                                        ${fullName}
                                    </#if>
                                <#else>
                                    <span class="text-muted">—</span>
                                </#if>
                            </td>
                            <td>
                                <#if app.formattedPreferredStartDate??>
                                    ${app.formattedPreferredStartDate}
                                <#else>
                                    <span class="text-muted"><@spring.message code="organization.applications.list.date.none"/></span>
                                </#if>
                            </td>
                            <td>
                                <#if app.formattedPreferredEndDate??>
                                    ${app.formattedPreferredEndDate}
                                <#else>
                                    <span class="text-muted"><@spring.message code="organization.applications.list.date.none"/></span>
                                </#if>
                            </td>
                            <td class="status-cell text-center">
                                <span class="badge status-badge
                                    <#if app.status == "PENDING"> bg-warning
                                    <#elseif app.status == "APPROVED"> bg-success
                                    <#elseif app.status == "REJECTED"> bg-danger
                                    <#else> bg-secondary</#if>">
                                    <#if app.status == "PENDING">
                                        <@spring.message code="organization.applications.list.status.pending"/>
                                    <#elseif app.status == "APPROVED">
                                        <@spring.message code="organization.applications.list.status.approved"/>
                                    <#elseif app.status == "REJECTED">
                                        <@spring.message code="organization.applications.list.status.rejected"/>
                                    <#else>
                                        <@spring.message code="organization.applications.list.status.other"/>
                                    </#if>
                                </span>
                            </td>
                            <td>${app.formattedSubmittedAt!"—"}</td>
                            <td class="text-center align-middle">
                                <#if app.status == "PENDING">
                                    <a href="/applications/organization/${app.id}/edit"
                                       class="btn btn-sm btn-warning me-1"
                                       title="<@spring.message code='organization.applications.list.edit'/>">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                            data-bs-target="#deleteModal${app.id}"
                                            title="<@spring.message code='organization.applications.list.delete'/>">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                    <div class="modal fade" id="deleteModal${app.id}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${app.id}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">
                                                <div class="modal-header bg-danger text-white">
                                                    <h5 class="modal-title" id="deleteModalLabel${app.id}">
                                                        <@spring.message code="organization.applications.list.delete.confirm.title"/>
                                                    </h5>
                                                    <button type="button" class="btn-close btn-close-white"
                                                            data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <
                                                <div class="modal-body">
                                                    ${springMacroRequestContext.getMessage(
                                                    "organization.applications.list.delete.confirm.message",
                                                    [app.courseTitle]
                                                    )}
                                                </div>

                                                <div class="modal-footer">
                                                    <form action="/applications/organization/${app.id}/delete"
                                                          method="post">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">
                                                            <@spring.message code="organization.applications.list.cancel"/>
                                                        </button>
                                                        <button type="submit" class="btn btn-danger">
                                                            <@spring.message code="organization.applications.list.delete"/>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <#else>
                                    <button type="button" class="btn btn-sm btn-secondary me-1" disabled
                                            title="<@spring.message code='organization.applications.list.locked.edit'/>">
                                        <i class="fas fa-lock"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-secondary" disabled
                                            title="<@spring.message code='organization.applications.list.locked.delete'/>">
                                        <i class="fas fa-lock"></i>
                                    </button>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </#if>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function () {
            $('#applicationsTable').DataTable({
                language: {
                    url: '/js/datatables/' + (
                        ('${springMacroRequestContext.locale?lower_case}'.startsWith('ru')) ? 'ru' :
                            (('${springMacroRequestContext.locale?lower_case}'.startsWith('ky')) ? 'ky' : 'en')
                    ) + '.json',
                    paginate: {previous: '‹', next: '›'}
                },
                responsive: true,
                order: [[0, 'desc']],
                pageLength: 10,
                dom: '<"row mb-3 px-3 pt-2"<"col-md-6"l><"col-md-6 text-end"f>>rt<"row mt-3 px-3 pb-2"<"col-md-6"i><"col-md-6"p>>',
                info: false,
                columnDefs: [
                    {responsivePriority: 4, targets: 0},
                    {responsivePriority: 1, targets: 1},
                    {responsivePriority: 5, targets: 2},
                    {responsivePriority: 6, orderable: false, targets: 3},
                    {responsivePriority: 7, orderable: false, targets: 4},
                    {responsivePriority: 2, targets: 5},
                    {responsivePriority: 8, targets: 6},
                    {responsivePriority: 3, orderable: false, targets: 7}
                ]
            });

            $(".clickable-row").click(function (e) {
                if (!$(e.target).closest('a, button').length) {
                    window.location = $(this).data("href");
                }
            });
        });
    </script>

    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .card-header {
            border-bottom: none;
        }

        .modal-dialog {
            max-width: 500px;
        }

        .modal-body {
            word-break: break-word;
            overflow-wrap: break-word;
            white-space: normal;
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

        .status-cell {
            text-align: center;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 140px;
        }

        .btn-outline-primary {
            color: #0066cc;
            border-color: #0066cc;
        }

        .btn-outline-primary:hover {
            background-color: #0066cc;
            color: white;
        }

        .btn-view {
            background-color: #0aa7c6;
            border: 1px solid #0aa7c6;
            color: #000;
            width: 100px;
            height: 36px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.375rem;
            transition: all 0.2s ease-in-out;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.25);
        }

        .btn-view:hover {
            background-color: #0dcaf0;
            border-color: #0dcaf0;
            color: #000;
        }

        .btn-view i {
            font-size: 1rem;
        }

        table th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            font-weight: 600;
            vertical-align: middle;
            border: none;
        }

        table td {
            vertical-align: middle;
            border-color: #dee2e6;
        }

        .table-responsive {
            border-radius: 0.5rem;
        }

        @media (max-width: 768px) {
            .card-header h5 {
                font-size: 1.25rem;
                margin-bottom: 1rem;
            }

            .btn-sm {
                margin-top: 0.5rem;
            }
        }

        table.dataTable thead th {
            color: white !important;
        }
    </style>
</@layout.page>
