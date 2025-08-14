<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<#setting datetime_format="dd.MM.yyyy HH:mm">
<#setting date_format="dd.MM.yyyy">

<#assign bcHome><@spring.message code='application.admin.list.breadcrumb.home'/></#assign>
<#assign bcCurrent><@spring.message code='application.admin.list.breadcrumb.current'/></#assign>

<@layout.page title="<@spring.message code='application.admin.list.title'/>">
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcCurrent, "url": ""}
    ] />

    <div class="card shadow mb-4">
        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <h5 class="m-0 font-weight-bold text-white mb-2 mb-md-0">
                    <i class="fas fa-file-alt me-2"></i> <@spring.message code="application.admin.list.title"/>
                </h5>
            </div>
        </div>

        <div class="table-responsive p-3">
            <#if applications?size == 0>
                <div class="alert alert-info mb-0"><@spring.message code="application.admin.list.noApplications"/></div>
            <#else>
                <table id="adminApplicationsTable" class="table table-hover table-bordered align-middle display nowrap"
                       width="100%">
                    <thead>
                    <tr>
                        <th><@spring.message code="application.admin.list.table.number"/></th>
                        <th><@spring.message code="application.admin.list.table.company"/></th>
                        <th><@spring.message code="application.admin.list.table.course"/></th>
                        <th><@spring.message code="application.admin.list.table.code"/></th>
                        <th><@spring.message code="application.admin.list.table.teacher"/></th>
                        <th class="wrap-date"><@spring.message code="application.admin.list.table.preferredStart"/></th>
                        <th class="wrap-date"><@spring.message code="application.admin.list.table.preferredEnd"/></th>
                        <th><@spring.message code="application.admin.list.table.status"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list applications as app>
                        <tr class="clickable-row" data-href="/applications/admin/${app.id}">
                            <td>${app?index + 1}</td>
                            <td>${app.organizationName!"—"}</td>
                            <td>${app.courseTitle!"—"}</td>
                            <td>${app.outgoingCode!"—"}</td>
                            <td>
                                <#if app.preferredTeacher??>
                                    ${app.preferredTeacher.name} ${app.preferredTeacher.lastName}
                                <#else>
                                    <span class="text-muted">—</span>
                                </#if>
                            </td>
                            <td>${app.formattedPreferredStartDate!"—"}</td>
                            <td>${app.formattedPreferredEndDate!"—"}</td>
                            <td>
                               <span class="badge
                                 <#if app.status == "PENDING">bg-warning
                                 <#elseif app.status == "APPROVED">bg-success
                                 <#elseif app.status == "REJECTED">bg-danger
                                 <#else>bg-secondary</#if>">
                                 <@spring.message code="application.admin.status.${app.status}"/>
                               </span>
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
            $('#adminApplicationsTable').DataTable({
                language: {
                    url: '/js/datatables/${(springMacroRequestContext.locale?lower_case?starts_with("ru"))?then("ru",(springMacroRequestContext.locale?lower_case?starts_with("ky"))?then("ky","en"))}.json',
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
        });

        $('.clickable-row').on('click', function () {
            window.location = $(this).data('href');
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

        .wrap-date {
            white-space: normal !important;
            word-break: break-word;
            min-width: 90px;
            max-width: 120px;
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
            min-width: 100px;
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

        .clickable-row {
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .clickable-row:hover {
            background-color: #f2f8ff;
        }

        @media (max-width: 768px) {
            .card-header h5 {
                font-size: 1.25rem;
                margin-bottom: 1rem;
            }
        }

        table.dataTable thead th {
            color: white !important;
        }
    </style>

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
