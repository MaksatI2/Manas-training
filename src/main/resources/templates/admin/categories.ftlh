<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Управление категориями", "url": ""}
    ] />
    <div class="card shadow mb-4">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>

        <div class="card-header d-flex filter-panel">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-folder me-2"></i>
                Управление категориями
            </h5>
            <div class="filter-controls">
                <a href="/admin/categories/add" class="btn btn-light"
                   style="border-radius: 25px; background: white; color: #0066cc; border: 1px solid #0066cc;">
                <i class="fas fa-plus me-1" style="color:#0066cc;"></i>Добавить категорию
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="categoriesTable" width="100%">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white !important;">
                    <tr>
                        <th>Название</th>
                        <th>Описание</th>
                        <th class="actions-col">Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list categories as category>
                        <tr style="cursor: pointer;" onclick="window.location.href='/admin/categories/edit/${category.id}'">
                            <td>
                                <span class="badge" style="background: #003d7a; color: white; font-size: 1.15rem">${category.name}</span>
                            </td>
                            <td style="color: #2c3e50;">${category.description!''}</td>
                            <td onclick="event.stopPropagation();" class="actions-col">
                                <#if _csrf??>
                                    <form action="/admin/categories/delete/${category.id}" method="post" style="display:inline;">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit"
                                                class="btn btn-sm btn-danger"
                                                title="Удалить"
                                                onclick="return confirm('Вы уверены, что хотите удалить категорию?')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                <#else>
                                    <a href="/admin/categories/delete/${category.id}"
                                       class="btn btn-sm btn-danger"
                                       title="Удалить"
                                       onclick="return confirm('Вы уверены, что хотите удалить категорию?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3 align-items-center">
                <div class="col-md-6">
                    <div id="categoriesTable_info" class="text-muted small" style="color: #2c3e50 !important;"></div>
                </div>
                <div class="col-md-6 d-flex justify-content-end">
                    <div id="categoriesTable_paginate" class="dataTables_paginate"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css">
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function () {
            var table = $('#categoriesTable').DataTable({
                language: {
                    url: '/js/datatables/ru.json',
                    paginate: { previous: '‹', next: '›' }
                },
                responsive: true,
                pageLength: 10,
                lengthChange: true,
                lengthMenu: [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "Все"]],
                searching: true,
                info: false,
                paging: true,
                autoWidth: false,
                stateSave: true,
                columnDefs: [
                    { targets: 2, orderable: false }
                ]
            });
        });
    </script>

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
            --white: #ffffff;
        }

        .card {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .filter-panel {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-radius: 15px 15px 0 0;
            padding: 1rem;
            border-left: 4px solid var(--primary-blue);
            flex-direction: column;
            gap: 0.75rem;
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

        @media (min-width: 576px) {
            .filter-panel {
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }
        }

        .filter-controls {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-start;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
        }

        #categoriesTable th, #categoriesTable td {
            vertical-align: middle;
            padding: 0.75rem;
        }

        #categoriesTable td {
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #categoriesTable tr:hover {
            background-color: rgba(0,102,204,0.05);
            transition: all 0.3s ease;
        }

        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            border-radius: 0.375rem;
        }

         .actions-col {
            max-width: 130px;
            width: 1%;
            white-space: nowrap;
            text-align: center;
            padding-left: 0;
            padding-right: 0;
        }

        div.dataTables_wrapper .dataTables_length,
        div.dataTables_wrapper .dataTables_filter {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        @media (max-width: 569px) {
            div.dataTables_wrapper .dataTables_length,
            div.dataTables_wrapper .dataTables_filter {
                flex-direction: column;
                align-items: flex-start;
                width: 100%;
                gap: 0.5rem;
            }

            div.dataTables_wrapper .dataTables_filter input {
                width: 100%;
            }
        }

        @media (min-width: 570px) and (max-width: 770px) {
            div.dataTables_wrapper .dataTables_length,
            div.dataTables_wrapper .dataTables_filter {
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
                width: 100%;
                gap: 1rem;
            }

            div.dataTables_wrapper .dataTables_filter input,
            div.dataTables_wrapper .dataTables_length select {
                height: 38px;
                line-height: 1.5;
            }

            div.dataTables_wrapper label {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 0;
            }
        }

        @media (min-width: 771px) {
            div.dataTables_wrapper .dataTables_length {
                justify-content: flex-start;
            }

            div.dataTables_wrapper .dataTables_filter {
                justify-content: flex-end;
            }
        }
        #categoriesTable thead {
            background: linear-gradient(135deg, #0066cc, #003d7a) !important;
            color: white !important;
        }

        #categoriesTable thead th {
            background-image: linear-gradient(135deg, #0066cc, #003d7a) !important;
            background-color: unset !important;
            color: #ffffff !important;
        }


    </style>
</@layout.page>
