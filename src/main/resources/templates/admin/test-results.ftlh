<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <#assign bcHome><@spring.message code='admin.test.results.breadcrumb.home'/></#assign>
    <#assign bcAll><@spring.message code='admin.test.results.breadcrumb.all'/></#assign>

    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcAll, "url": ""}
    ] />
    <div class="card shadow mb-4">
        <div class="card-header py-3" style="background: linear-gradient(135deg, #0066cc, #003d7a);">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h5 class="m-0 font-weight-bold text-white">
                    <i class="fa-solid fa-list-check"></i>
                    <@spring.message code="admin.test.results.header.title"/>
                </h5>

                <div class="d-flex align-items-center flex-wrap gap-2">
                    <div id="customExportButtons"></div>

                    <div class="input-group input-group-sm" style="width: 180px;">
                      <span class="input-group-text"
                            style="background-color: #fff; border: 1px solid #0066cc; color: #0066cc;">
                         <i class="fas fa-filter"></i>
                      </span>
                        <select class="form-select form-select-sm" id="courseFilter"
                                style="border: 1px solid #0066cc; border-left: 0; color: #0066cc;">
                            <option hidden disabled selected
                                    value=""><@spring.message code="admin.test.results.filter.course"/></option>
                            <#list results as result>
                                <option value="${result.testInstance.test.course.title}">${result.testInstance.test.course.title}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="input-group input-group-sm" style="width: 180px;">
                      <span class="input-group-text"
                            style="background-color: #fff; border: 1px solid #0066cc; color: #0066cc;">
                         <i class="fas fa-filter"></i>
                      </span>
                        <select class="form-select form-select-sm" id="courseInstanceFilter"
                                style="border: 1px solid #0066cc; border-left: 0; color: #0066cc;">
                            <option hidden disabled selected
                                    value=""><@spring.message code="admin.test.results.filter.instance"/></option>
                            <#list results as result>
                                <option value="${result.courseInstance.title}">${result.courseInstance.title}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="input-group input-group-sm" style="width: 180px;">
                      <span class="input-group-text"
                            style="background-color: #fff; border: 1px solid #0066cc; color: #0066cc;">
                         <i class="fas fa-filter"></i>
                      </span>
                        <select class="form-select form-select-sm" id="studentFilter"
                                style="border: 1px solid #0066cc; border-left: 0; color: #0066cc;">
                            <option hidden disabled selected
                                    value=""><@spring.message code="admin.test.results.filter.student"/></option>
                            <#list results as result>
                                <option value="${result.student.name}">${result.student.name}</option>
                            </#list>
                        </select>
                    </div>
                    <button id="resetFilters" class="btn btn-link text-white btn-sm px-2"
                            title="<@spring.message code='admin.test.results.filter.reset.title'/>"
                            style="font-size: 1rem;">
                        <i class="fas fa-times-circle"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="testResultsTable" width="100%" cellspacing="0">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th><@spring.message code="admin.test.results.table.col.course"/></th>
                        <th><@spring.message code="admin.test.results.table.col.instance"/></th>
                        <th><@spring.message code="admin.test.results.table.col.student"/></th>
                        <th><@spring.message code="admin.test.results.table.col.status"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if results?has_content>
                        <#list results as result>
                            <tr onclick="window.location.href='/admin/test-results/${result.id}'"
                                style="cursor: pointer;">
                                <td>${result.testInstance.test.course.title}</td>
                                <td>${result.courseInstance.title}</td>
                                <td>${result.student.name} ${result.student.lastName}</td>
                                <td>
                                    <#if result.isPassed>
                                        <span class="badge bg-success">
                                            <i class="fas fa-check-circle me-1"></i><@spring.message code="admin.test.results.status.passed"/>
                                        </span>
                                    <#else>
                                        <span class="badge bg-warning">
                                            <i class="fas fa-times-circle me-1"></i><@spring.message code="admin.test.results.status.failed"/>
                                        </span>
                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-graduation-cap fa-2x mb-2" style="color: #0066cc;"></i>
                                <p style="color: #2c3e50;"><@spring.message code="admin.test.results.empty.text"/></p>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>

            </div>
            <div class="row mt-3">
                <div class="col-md-6">
                    <div id="testResultsTable_pagination" class="dataTables_paginate"></div>
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
        var dtLocale = '${springMacroRequestContext.locale?lower_case}';
        if (dtLocale.indexOf('ru') === 0) dtLocale = 'ru';
        else if (dtLocale.indexOf('ky') === 0) dtLocale = 'ky';
        else dtLocale = 'en';

        $(function () {
            const table = $('#testResultsTable').DataTable({
                paging: true,
                searching: true,
                ordering: true,
                language: {
                    url: '/js/datatables/' + dtLocale + '.json',
                    paginate: {previous: '‹', next: '›'}
                }
            });

            $('#courseFilter').on('change', function () {
                table.column(0).search(this.value ? '^' + this.value + '$' : '', true, false).draw();
            });
            $('#studentFilter').on('change', function () {
                table.column(2).search(this.value || '', true, false).draw();
            });
            $('#courseInstanceFilter').on('change', function () {
                table.column(1).search(this.value || '', true, false).draw();
            });
            $('#resetFilters').on('click', function () {
                $('#courseFilter, #studentFilter, #courseInstanceFilter').val('');
                table.search('').columns().search('').draw();
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

        #testResultsTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-collapse: separate;
            border-spacing: 0;
        }

        #testResultsTable th {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            color: white;
            padding: 0.75rem;
            vertical-align: middle;
            border: none;
            font-weight: 600;
        }

        #testResultsTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #testResultsTable tr:hover {
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

            .btn-sm {
                margin-bottom: 0.5rem;
            }
        }
    </style>

</@layout.page>
