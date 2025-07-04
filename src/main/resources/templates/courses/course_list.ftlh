<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Курсы", "url": ""}
    ] />
    <div class="card shadow mb-4">
        <div class="card-header d-flex filter-panel">
            <h5 class="m-0 font-weight-bold text-white">
                <i class="fas fa-book me-2"></i>
                Каталог курсов
            </h5>
            <div class="filter-controls">
                <div class="input-group custom-filter">
                     <span class="input-group-text">
                       <i class="fas fa-filter"></i>
                     </span>
                    <select id="categoryFilter" class="form-select category-filter">
                        <option value="" selected disabled hidden>Все категории</option>
                        <#list categories as category>
                            <option value="${category.name}">${category.name}</option>
                        </#list>
                    </select>
                    <button id="resetCategoryFilter" class="btn btn-outline-light reset-btn" type="button"
                            title="Сбросить фильтр">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="coursesTable" width="100%">
                    <thead style="background: linear-gradient(135deg, #0066cc, #003d7a); color: white;">
                    <tr>
                        <th>ID</th>
                        <th>Название</th>
                        <th>Код курса</th>
                        <th>Категория</th>
                        <th class="duration-col">Длительность</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if courses?has_content>
                        <#list courses as course>
                            <tr style="cursor: pointer;" onclick="window.location.href='/courses/${course.id}'">
                                <td>${course.id}</td>
                                <td>${course.title}</td>
                                <td><span class="badge"
                                          style="background: #87ceeb; color: #2c3e50;">${course.code}</span></td>
                                <td><span class="badge"
                                          style="background: #003d7a; color: white;">${course.category.name}</span></td>
                                <td class="duration-col">
                                    <span class="duration-content">
                                        <i class="fas fa-clock me-1" style="color: #0066cc;">
                                        </i>${course.duration}
                                    </span>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">Курсы не найдены</td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row mt-3 align-items-center">
                <div class="col-md-6">
                    <div id="coursesTable_info" class="text-muted small" style="color: #2c3e50 !important;"></div>
                </div>
                <div class="col-md-6 d-flex justify-content-end">
                    <div id="coursesTable_paginate" class="dataTables_paginate"></div>
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
            var table = $('#coursesTable').DataTable({
                language: {
                    url: '/js/datatables/ru.json',
                    paginate: {previous: '‹', next: '›'}
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
                    {targets: 0, responsivePriority: 1},
                    {targets: 1, responsivePriority: 1},
                    {targets: 4, responsivePriority: 2},
                    {targets: 2, responsivePriority: 3},
                    {targets: 3, responsivePriority: 4}
                ]
            });

            $('#categoryFilter').on('change', function () {
                table.column(3).search(this.value).draw();
            });
            $('#resetCategoryFilter').on('click', function () {
                $('#categoryFilter').val('');
                table.column(3).search('').draw();
            });
        });
    </script>

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --light-blue: #87ceeb;
            --text-dark: #2c3e50;
            --white: #ffffff;
        }

        .card {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
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

        .reset-btn {
            border: none;
            border-left: 1px solid var(--light-blue);
            border-radius: 0 5px 5px 0;
            background: transparent;
            color: var(--primary-blue);
            padding: 0 12px;
            font-size: 0.9rem;
            transition: all 0.2s ease-in-out;
        }

        .reset-btn:hover {
            background-color: var(--primary-blue);
            color: white;
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
            gap: -10px;
            flex-wrap: wrap;
            justify-content: flex-start;
        }

        .custom-filter {
            background: var(--white);
            border-radius: 5px;
            padding: 0 0.5rem;
            display: flex;
            align-items: center;
            max-width: none;
        }

        .category-filter {
            background: transparent;
            border: none;
            color: var(--text-dark);
            font-weight: 500;
            border-radius: 5px;
            padding: 0.4rem 0.75rem;
            max-width: 180px;
            min-width: 140px;
            width: 100%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        select.category-filter option {
            white-space: normal;
        }

        .category-filter:focus {
            outline: none;
            box-shadow: none;
        }

        .category-filter option {
            color: var(--text-dark);
        }

        .input-group-text {
            background: transparent;
            border: none;
            color: var(--primary-blue);
            font-size: 1rem;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
        }

        #coursesTable th, #coursesTable td {
            vertical-align: middle;
            padding: 0.75rem;
        }

        #coursesTable td {
            border-top: 1px solid #e3e6f0;
            border-bottom: 1px solid #e3e6f0;
        }

        #coursesTable tr:hover {
            background-color: rgba(0, 102, 204, 0.05);
            transition: all 0.3s ease;
        }

        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            border-radius: 0.375rem;
        }

        div.dataTables_wrapper .dataTables_length,
        div.dataTables_wrapper .dataTables_filter {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }
        .duration-col {
            width: 1%;
            white-space: nowrap;
            text-align: center;
        }

        .duration-content {
            display: inline-block;
            padding-right: 6rem;
        }

        @media (max-width: 768px) {
            .duration-content {
                font-size: 0.8rem;
                padding-right: 0.5rem;
            }
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
    </style>
</@layout.page>