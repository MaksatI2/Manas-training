<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>

<#assign bcHome><@spring.message code='admin.user.list.breadcrumb.home'/></#assign>
<#assign bcUsers><@spring.message code='admin.user.list.breadcrumb.users'/></#assign>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcUsers, "url": ""}
    ] />
    <div class="card shadow mb-4">

        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h5 class="m-0 font-weight-bold text-white">
                    <i class="fas fa-users me-2"></i> <@spring.message code='admin.user.list.title'/>
                </h5>

                <div class="d-flex align-items-center flex-wrap gap-2">
                    <div id="usersTable_buttons"></div>
                    <div class="d-flex align-items-center flex-wrap gap-2">
                        <div class="input-group input-group-sm" style="width: 180px;">
                            <span class="input-group-text"
                                  style="background-color: #fff; border: 1px solid #0066cc; color: #0066cc;">
                                <i class="fas fa-filter"></i>
                            </span>
                            <select class="form-select form-select-sm" id="roleFilter"
                                    style="border: 1px solid #0066cc; border-left: 0; color: #0066cc;">
                                <option hidden disabled selected
                                        value=""><@spring.message code='admin.user.list.filter.allUsers'/></option>
                                <#list roles as role>
                                    <option value="${role}" <#if selectedRole?? && selectedRole == role>selected</#if>>
                                        ${roleDisplayNames[role]!role}
                                    </option>
                                </#list>
                            </select>
                        </div>

                        <div class="input-group input-group-sm" style="width: 180px;">
                            <span class="input-group-text"
                                  style="background-color: #fff; border: 1px solid #0066cc; color: #0066cc;">
                                <i class="fas fa-filter"></i>
                            </span>
                            <select class="form-select form-select-sm" id="statusFilter"
                                    style="border: 1px solid #0066cc; border-left: 0; color: #0066cc;">
                                <option hidden disabled selected
                                        value=""><@spring.message code='admin.user.list.filter.allStatuses'/></option>
                                <option value="<@spring.message code='admin.user.list.status.active'/>"><@spring.message code='admin.user.list.status.active'/></option>
                                <option value="<@spring.message code='admin.user.list.status.inactive'/>"><@spring.message code='admin.user.list.status.inactive'/></option>
                            </select>
                        </div>

                        <button id="resetFilters"
                                class="btn btn-link text-white btn-sm px-2"
                                title="<@spring.message code='admin.user.list.resetFilters'/>"
                                style="font-size: 1rem;">
                            <i class="fas fa-times-circle"></i>
                        </button>
                    </div>

                    <a href="/admin/teachers/add" class="btn btn-light btn-sm"
                       style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                        <i class="fas fa-plus me-1"></i> <@spring.message code='admin.user.list.addTeacher'/>
                    </a>
                </div>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="usersTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th><@spring.message code='admin.user.list.table.number'/></th>
                        <th><@spring.message code='admin.user.list.table.name'/></th>
                        <th><@spring.message code='admin.user.list.table.lastName'/></th>
                        <th><@spring.message code='admin.user.list.table.email'/></th>
                        <th><@spring.message code='admin.user.list.table.phone'/></th>
                        <th><@spring.message code='admin.user.list.table.role'/></th>
                        <th><@spring.message code='admin.user.list.table.status'/></th>
                        <th class="text-center"><@spring.message code='admin.user.list.table.actions'/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if users?has_content>
                        <#list users as user>
                            <tr style="cursor: pointer;" onclick="window.location.href='/admin/users/${user.id}'">
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${(user.lastName?has_content && user.lastName != "null")?then(user.lastName, "-")}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <span class="badge bg-primary">${user.role.name}</span>
                                </td>
                                <td>
                                    <#if user.isActive>
                                        <span class="badge bg-success"><@spring.message code='admin.user.list.status.active'/></span>
                                    <#else>
                                        <span class="badge bg-warning"><@spring.message code='admin.user.list.status.inactive'/></span>
                                    </#if>
                                </td>
                                <td class="text-center">
                                    <a href="/admin/users/${user.id}/edit" class="btn btn-sm btn-primary"
                                       title="Редактировать">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <#if !user.isActive>
                                        <a href="/admin/users/${user.id}/activate"
                                           class="btn btn-sm btn-success"
                                           title="Активировать">
                                            <i class="fas fa-check"></i>
                                        </a>
                                    <#else>
                                        <a href="/admin/users/${user.id}/deactivate"
                                           class="btn btn-sm btn-warning"
                                           title="Деактивировать"
                                           onclick="return confirm('Вы уверены, что хотите деактивировать пользователя?')">
                                            <i class="fas fa-ban"></i>
                                        </a>
                                    </#if>
                                    <button class="btn btn-sm btn-danger delete-user-btn"
                                            data-user-id="${user.id}"
                                            data-user-name="${user.name} ${user.lastName!'unknown'}"
                                            title="Удалить">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <p><@spring.message code='admin.user.list.table.notFound'/></p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="usersTable_paginate" class="dataTables_paginate"></div>
                </div>
            </div>
        </div>
    </div>

    <div id="i18n-holder"
         data-delete-title="<@spring.message code='admin.user.list.modal.deleteTitle'/>"
         data-delete-confirm="<@spring.message code='admin.user.list.modal.deleteConfirm'/>"
         data-delete-warning="<@spring.message code='admin.user.list.modal.deleteWarning'/>"
         data-relations-error="<@spring.message code='admin.user.list.modal.relationsError'/>"
         data-cancel="<@spring.message code='admin.user.list.modal.cancel'/>"
         data-delete="<@spring.message code='admin.user.list.modal.delete'/>"
         data-export="<@spring.message code='admin.user.list.export'/>"
         data-export-copy="<@spring.message code='admin.user.list.export.copy'/>"
         data-export-excel="<@spring.message code='admin.user.list.export.excel'/>"
         data-export-pdf="<@spring.message code='admin.user.list.export.pdf'/>"
         data-export-print="<@spring.message code='admin.user.list.export.print'/>">
    </div>

    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"
                        id="deleteUserModalLabel"><@spring.message code='admin.user.list.modal.deleteTitle'/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p id="deleteConfirmText"></p>
                    <p class="text-warning"><@spring.message code='admin.user.list.modal.deleteWarning'/></p>
                    <ul id="userRelationsList" class="list-group">
                        <li class="list-group-item"><strong>Расписания:</strong> <span id="schedulesCount">0</span></li>
                        <li class="list-group-item"><strong>Сотрудники:</strong> <span id="employeesCount">0</span></li>
                        <li class="list-group-item"><strong>Заявки на курсы:</strong> <span
                                    id="courseApplicationEmployeesCount">0</span></li>
                        <li class="list-group-item"><strong>Результаты тестов:</strong> <span
                                    id="testResultsCount">0</span></li>
                        <li class="list-group-item"><strong>Посещения:</strong> <span
                                    id="attendancesAsStudentCount">0</span></li>
                        <li class="list-group-item"><strong>Отмеченные посещения:</strong> <span
                                    id="attendancesMarkedByCount">0</span></li>
                        <li class="list-group-item"><strong>Сертификаты:</strong> <span id="certificatesAsStudentCount">0</span>
                        </li>
                        <li class="list-group-item"><strong>Выданные сертификаты:</strong> <span
                                    id="certificatesIssuedByUserCount">0</span></li>
                        <li class="list-group-item"><strong>Преподаватели потоков:</strong> <span
                                    id="courseInstanceTeachersCount">0</span></li>
                        <li class="list-group-item"><strong>Преподаватели курсов:</strong> <span
                                    id="courseTeachersCount">0</span></li>
                        <li class="list-group-item"><strong>Записи на курсы:</strong> <span
                                    id="enrollmentsCount">0</span></li>
                    </ul>
                    <div id="relationsError" class="alert alert-danger d-none mt-3">
                        <@spring.message code='admin.user.list.modal.relationsError'/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal"><@spring.message code='admin.user.list.modal.cancel'/></button>
                    <a id="confirmDeleteBtn" href="#"
                       class="btn btn-danger"><@spring.message code='admin.user.list.modal.delete'/></a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css"
          href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function () {
            var dtLangUrl = "<#if springMacroRequestContext.locale?string?lower_case?starts_with('ru')>/js/datatables/ru.json" +
                "<#elseif springMacroRequestContext.locale?string?lower_case?starts_with('ky')>/js/datatables/ky.json" +
                "<#else>/js/datatables/en.json</#if>";

            var allLabel = "<#if springMacroRequestContext.locale?string?lower_case?starts_with('ru')>Все" +
                "<#elseif springMacroRequestContext.locale?string?lower_case?starts_with('ky')>Баары" +
                "<#else>All</#if>";

            var i18n = document.getElementById('i18n-holder').dataset;

            var table = $('#usersTable').DataTable({
                language: {url: dtLangUrl, paginate: {previous: '‹', next: '›'}},
                responsive: true,
                pageLength: 10,
                lengthChange: true,
                lengthMenu: [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, allLabel]],
                order: [[0, 'asc']],
                searching: true,
                info: false,
                paging: true,
                autoWidth: false,
                stateSave: true,
                dom: '<"row mb-3 pt-2"<"col-md-6"l><"col-md-6 text-end"f>>' +
                    'rt' +
                    '<"row mt-3 align-items-center pb-2"<"col-md-6"i><"col-md-6"p>>',
                buttons: [
                    {
                        extend: 'collection',
                        text: '<i class="fas fa-download me-1"></i> ' + i18n.export,
                        className: 'btn btn-primary btn-sm dropdown-toggle',
                        buttons: [
                            {
                                extend: 'copy',
                                text: '<i class="fas fa-copy me-1"></i> ' + i18n.exportCopy,
                                className: 'dropdown-item',
                                exportOptions: {columns: ':visible'},
                                title: 'Список пользователей',
                                messageTop: 'Список пользователей на ' + new Date().toLocaleDateString()
                            },
                            {
                                extend: 'excel',
                                text: '<i class="fas fa-file-excel me-1"></i> ' + i18n.exportExcel,
                                className: 'dropdown-item',
                                exportOptions: {columns: ':visible'},
                                title: 'Список пользователей',
                                messageTop: 'Список пользователей на ' + new Date().toLocaleDateString(),
                                autoFilter: true,
                                customize: function (xlsx) {
                                    var sheet = xlsx.xl.worksheets['sheet1.xml'];
                                    $('row c[r^="A"]', sheet).attr('s', '2');
                                }
                            },
                            {
                                extend: 'pdf',
                                text: '<i class="fas fa-file-pdf me-1"></i> ' + i18n.exportPdf,
                                className: 'dropdown-item',
                                exportOptions: {columns: ':visible'},
                                title: 'Список пользователяй Manas - ' + new Date().toLocaleDateString(),
                                customize: function (doc) {
                                    if (!doc.content || doc.content.length < 2 || !doc.content[1].table) return;
                                    doc.defaultStyle = {fontSize: 8, color: '#2c3e50'};
                                    doc.styles.title = {
                                        color: '#0066cc',
                                        fontSize: 14,
                                        alignment: 'center',
                                        margin: [0, 0, 0, 15]
                                    };
                                    const t = doc.content[1].table;
                                    t.widths = Array(t.body[0].length).fill('*');
                                    t.body[0].forEach(function (c) {
                                        c.fillColor = '#003d7a';
                                        c.color = '#ffffff';
                                        c.alignment = 'center';
                                        c.bold = true;
                                    });
                                    for (let i = 1; i < t.body.length; i++) {
                                        if (i % 2 === 0) {
                                            t.body[i].forEach(function (c) {
                                                c.fillColor = '#f8f9fa';
                                            });
                                        }
                                    }
                                    doc.pageMargins = [20, 60, 20, 30];
                                },
                                orientation: 'landscape'
                            },
                            {
                                extend: 'print',
                                text: '<i class="fas fa-print me-1"></i> ' + i18n.exportPrint,
                                className: 'dropdown-item',
                                exportOptions: {columns: ':visible'},
                                title: 'Список пользователей',
                                messageTop: '<h3 class="text-center">Список пользователей</h3><p class="text-center">На ' + new Date().toLocaleDateString() + '</p>',
                                customize: function (win) {
                                    $(win.document.body).find('table').addClass('display').css('font-size', '10px');
                                    $(win.document.body).find('tr:nth-child(odd) td').each(function () {
                                        $(this).css('background-color', '#f8f9fa');
                                    });
                                    $(win.document.body).find('h1').css('text-align', 'center');
                                }
                            }
                        ]
                    }
                ],
                columnDefs: [
                    {targets: [1], responsivePriority: 3, orderable: true, searchable: true},
                    {targets: [2], responsivePriority: 4, orderable: true, searchable: true},
                    {targets: [3], responsivePriority: 1, orderable: true, searchable: true},
                    {targets: [7], responsivePriority: 2, orderable: false, searchable: false},
                    {targets: [4, 5], orderable: true, searchable: true}
                ],
                initComplete: function () {
                    this.api().page.len(10).draw();
                    table.buttons().container().appendTo('#usersTable_buttons');
                }
            });

            $('#roleFilter').on('change', function () {
                table.column(5).search(this.value).draw();
            });

            $('#statusFilter').on('change', function () {
                table.column(6).search(this.value).draw();
            });

            $('.dt-buttons').addClass('btn-group');
            $('.dt-button').addClass('btn').removeClass('dt-button');
            $('.dropdown-toggle').dropdown();

            $('#resetFilters').on('click', function () {
                $('#roleFilter').prop('selectedIndex', 0).trigger('change');
                $('#statusFilter').prop('selectedIndex', 0).trigger('change');
                table.search('').columns().search('').draw();
            });

            $('.delete-user-btn').on('click', function (event) {
                event.stopPropagation();

                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');

                const tmpl = document.getElementById('i18n-holder').dataset.deleteConfirm;
                const text = tmpl.replace('{0}', '<strong>' + userName + '</strong>');
                $('#deleteConfirmText').html(text);

                $('#confirmDeleteBtn').attr('href', '/admin/users/' + userId + '/delete');

                $('#userRelationsList span').text('0');
                $('#relationsError').addClass('d-none');

                $.ajax({
                    url: '/api/users/' + userId + '/relations-count',
                    method: 'GET',
                    success: function (data) {
                        $('#schedulesCount').text(data.schedules);
                        $('#employeesCount').text(data.employees);
                        $('#courseApplicationEmployeesCount').text(data.courseApplicationEmployees);
                        $('#testResultsCount').text(data.testResults);
                        $('#attendancesAsStudentCount').text(data.attendancesAsStudent);
                        $('#attendancesMarkedByCount').text(data.attendancesMarkedBy);
                        $('#certificatesAsStudentCount').text(data.certificatesAsStudent);
                        $('#certificatesIssuedByUserCount').text(data.certificatesIssuedByUser);
                        $('#courseInstanceTeachersCount').text(data.courseInstanceTeachers);
                        $('#courseTeachersCount').text(data.courseTeachers);
                        $('#enrollmentsCount').text(data.enrollments);
                    },
                    error: function () {
                        $('#relationsError').removeClass('d-none');
                    }
                });

                $('#deleteUserModal').modal('show');
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

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
        }

        #usersTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #usersTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #usersTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #usersTable tr:hover {
            background-color: rgba(0, 102, 204, 0.05);
            transform: translateY(-1px);
            transition: all 0.3s ease;
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

        .custom-pagination .pagination {
            display: flex;
            gap: 5px;
            padding-left: 0;
            list-style: none;
            margin: 0;
        }

        .dataTables_wrapper .dataTables_paginate .pagination .page-item .page-link {
            border-radius: 0 !important;
        }

        .dataTables_wrapper .dataTables_paginate .pagination .page-item:first-child .page-link {
            border-top-left-radius: 12px !important;
            border-bottom-left-radius: 12px !important;
        }

        .dataTables_wrapper .dataTables_paginate .pagination .page-item:last-child .page-link {
            border-top-right-radius: 12px !important;
            border-bottom-right-radius: 12px !important;
        }

        .dataTables_wrapper .dataTables_paginate .pagination .page-item.active .page-link {
            background-color: var(--primary-blue) !important;
            color: white !important;
            font-weight: bold;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-blue) !important;
        }

        .dataTables_wrapper .dataTables_paginate .pagination .page-item .page-link:hover {
            background-color: #005bb5 !important;
            color: white !important;
        }

        .input-group-text {
            background: #0066cc;
            border: 1px solid #0066cc;
            color: white;
        }

        .form-select {
            border-left: 0;
            border-color: #d1d3e2;
        }

        .form-select-sm {
            padding-right: 2rem !important;
        }

        .form-select:focus {
            box-shadow: none;
            border-color: #d1d3e2;
        }

        .btn-light {
            transition: all 0.3s ease;
        }

        .btn-light:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }

        .dt-buttons {
            margin-bottom: 0;
            margin-left: 15px;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.375rem;
            margin-right: 0.25rem;
            transition: all 0.3s ease;
        }

        .btn-sm:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
        }

        .btn-primary {
            background-color: #0066cc;
            border-color: #0066cc;
        }

        .form-select-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.375rem;
            border: 1px solid #ced4da;
            background-color: white;
            color: #495057;
        }

        .form-select-sm:focus {
            border-color: #0066cc;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.25);
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .dropdown-menu {
            border-radius: 0.375rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .dropdown-item {
            padding: 0.25rem 1rem;
            font-size: 0.875rem;
            color: #212529;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #0066cc;
        }

        .dropdown-item i {
            width: 18px;
            text-align: center;
            margin-right: 5px;
        }

        .dataTables_length select.form-select {
            padding-right: 2rem;
            background-position: right 0.5rem center;
            background-size: 12px;
            appearance: none;
        }

        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .card-header h5 {
                margin-bottom: 1rem;
                font-size: 1.25rem;
            }

            .dt-buttons {
                flex-wrap: wrap;
                margin-left: 0;
                margin-top: 10px;
            }

            .btn-sm {
                margin-bottom: 0.5rem;
            }

            .row.mb-3 {
                flex-direction: column;
            }

            .row.mb-3 .col-md-3 {
                width: 100%;
                margin-bottom: 1rem;
            }

            .col-md-6.d-flex {
                justify-content: flex-start !important;
                margin-top: 1rem;
                flex-direction: column;
            }
        }
    </style>
</@layout.page>
