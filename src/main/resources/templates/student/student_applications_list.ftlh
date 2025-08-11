<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#setting datetime_format="dd.MM.yyyy HH:mm">
<#setting date_format="dd.MM.yyyy">

<#assign bcHome><@spring.message code='student.applications.list.breadcrumb.home'/></#assign>
<#assign bcMy><@spring.message code='student.applications.list.breadcrumb.my'/></#assign>

<@layout.page title="<@spring.message code='student.applications.list.title'/>">
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMy, "url": ""}
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
                    <i class="fas fa-list me-2"></i> <@spring.message code='student.applications.list.header'/>
                </h5>
                <a href="/applications/student/applications/create" class="btn btn-sm"
                   style="border-radius: 25px; background-color: white; color: #0066cc; border: 1px solid #0066cc;">
                    <i class="fas fa-plus me-1"></i> <@spring.message code='student.applications.list.create'/>
                </a>
            </div>
        </div>

        <div class="table-responsive p-3">
            <#if applications?size == 0>
                <div class="alert alert-info mb-0"><@spring.message code='student.applications.list.notfound'/></div>
            <#else>
                <table id="studentApplicationsTable"
                       class="table table-hover table-bordered align-middle display nowrap" width="100%">
                    <thead>
                    <tr>
                        <th><@spring.message code='student.applications.list.table.number'/></th>
                        <th><@spring.message code='student.applications.list.table.course'/></th>
                        <th><@spring.message code='student.applications.list.table.teacher'/></th>
                        <th><@spring.message code='student.applications.list.table.start'/></th>
                        <th><@spring.message code='student.applications.list.table.end'/></th>
                        <th><@spring.message code='student.applications.list.table.status'/></th>
                        <th><@spring.message code='student.applications.list.table.submitted'/></th>
                        <th class="text-center"><@spring.message code='student.applications.list.table.actions'/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list applications as app>
                        <tr class="clickable-row" data-href="/applications/student/applications/${app.id}">
                            <td>${app?index + 1}</td>
                            <td class="field-value">${app.courseTitle}</td>
                            <td class="field-value">
                                <#if app.preferredTeacher??>
                                    ${app.preferredTeacher.name} ${app.preferredTeacher.lastName}
                                <#else>
                                    <span class="text-muted"><@spring.message code='student.applications.list.teacher.none'/></span>
                                </#if>
                            </td>
                            <td>
                                <#if app.formattedPreferredStartDate??>
                                    ${app.formattedPreferredStartDate}
                                <#else>
                                    <span class="text-muted"><@spring.message code='student.applications.list.date.none'/></span>
                                </#if>
                            </td>
                            <td>
                                <#if app.formattedPreferredEndDate??>
                                    ${app.formattedPreferredEndDate}
                                <#else>
                                    <span class="text-muted"><@spring.message code='student.applications.list.date.none'/></span>
                                </#if>
                            </td>
                            <td class="status-cell">
                                <span class="badge
                                    <#if app.status == "PENDING">bg-warning
                                    <#elseif app.status == "APPROVED">bg-success
                                    <#elseif app.status == "REJECTED">bg-danger
                                    <#else>bg-secondary</#if>">
                                    <#if app.status == "PENDING">
                                        <@spring.message code='student.applications.list.status.pending'/>
                                    <#elseif app.status == "APPROVED">
                                        <@spring.message code='student.applications.list.status.approved'/>
                                    <#elseif app.status == "REJECTED">
                                        <@spring.message code='student.applications.list.status.rejected'/>
                                    <#else>
                                        <@spring.message code='student.applications.list.status.other'/>
                                    </#if>
                                </span>
                            </td>
                            <td>${app.formattedSubmittedAt!"—"}</td>
                            <td class="text-center align-middle">
                                <#if app.status == "PENDING">
                                    <a href="/applications/student/applications/${app.id}/edit"
                                       class="btn btn-sm btn-warning me-1"
                                       title="<@spring.message code='student.applications.list.edit'/>">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                            data-bs-target="#deleteModal${app.id}"
                                            title="<@spring.message code='student.applications.list.delete'/>">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                    <div class="modal fade" id="deleteModal${app.id}" tabindex="-1"
                                         aria-labelledby="deleteModalLabel${app.id}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">
                                                <div class="modal-header bg-danger text-white">
                                                    <h5 class="modal-title" id="deleteModalLabel${app.id}">
                                                        <@spring.message code='student.applications.list.delete.confirm.title'/>
                                                    </h5>
                                                    <button type="button" class="btn-close btn-close-white"
                                                            data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body text-break">
                                                    <p class="mb-0">
                                                        ${springMacroRequestContext.getMessage(
                                                        "student.applications.list.delete.confirm.message",
                                                        [app.courseTitle],
                                                        "Вы уверены, что хотите удалить заявку на курс «{0}»? Это действие необратимо."
                                                        )}
                                                    </p>
                                                </div>
                                                <div class="modal-footer">
                                                    <form action="/applications/student/applications/${app.id}/delete"
                                                          method="post">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">
                                                            <@spring.message code='student.applications.list.cancel'/>
                                                        </button>
                                                        <button type="submit" class="btn btn-danger">
                                                            <@spring.message code='student.applications.list.delete'/>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <#else>
                                    <button type="button" class="btn btn-sm btn-secondary me-1" disabled
                                            title="<@spring.message code='student.applications.list.locked.edit'/>">
                                        <i class="fas fa-lock"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-secondary" disabled
                                            title="<@spring.message code='student.applications.list.locked.delete'/>">
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
            var langUrl = '<#if springMacroRequestContext.locale?string?lower_case?starts_with("ru")>/js/datatables/ru_RU.json<#elseif springMacroRequestContext.locale?string?lower_case?starts_with("ky")>/js/datatables/ky_KG.json<#else>/js/datatables/en_US.json</#if>';
            var allLabel = '<#if springMacroRequestContext.locale?string?lower_case?starts_with("ru")>Все<#elseif springMacroRequestContext.locale?string?lower_case?starts_with("ky")>Баары<#else>All</#if>';

            $('#studentApplicationsTable').DataTable({
                language: {
                    url: langUrl,
                    paginate: {previous: '‹', next: '›'}
                },
                responsive: true,
                order: [[0, 'desc']],
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, allLabel]],
                dom: '<"row mb-3 px-3 pt-2"<"col-md-6"l><"col-md-6 text-end"f>>rt<"row mt-3 px-3 pb-2"<"col-md-6"i><"col-md-6"p>>',
                info: false,
                columnDefs: [
                    {responsivePriority: 4, targets: 0},
                    {responsivePriority: 1, targets: 1},
                    {responsivePriority: 3, targets: 2},
                    {responsivePriority: 5, targets: 3, orderable: false},
                    {responsivePriority: 6, targets: 4, orderable: false},
                    {responsivePriority: 7, targets: 5},
                    {responsivePriority: 8, targets: 6},
                    {responsivePriority: 2, orderable: false, targets: 7}
                ]
            });

            $(".clickable-row").on('click', function (e) {
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

        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            border-radius: 0.375rem;
            display: inline-block;
            width: 140px;
            text-align: center;
        }

        td.status-cell {
            text-align: center;
            vertical-align: middle;
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
        }

        .btn-view i {
            font-size: 1rem;
        }

        table th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            font-weight: 600;
        }

        table td {
            vertical-align: middle;
            border-color: #dee2e6;
        }

        .modal-body {
            word-break: break-word;
            white-space: normal;
        }

        .modal-dialog {
            max-width: 600px;
            width: 100%;
        }

        tr.clickable-row:hover {
            background-color: #f1f9ff;
            cursor: pointer;
        }

        .field-value {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }

        @media (max-width: 768px) {
            .card-header h5 {
                font-size: 1.25rem;
            }
        }

        table.dataTable thead th {
            color: white !important;
        }
    </style>
</@layout.page>
