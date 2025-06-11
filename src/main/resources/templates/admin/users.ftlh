<#import "../layout.ftlh" as layout>
<@layout.page>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h5 class="m-0 font-weight-bold text-primary">Управление пользователями</h5>
            <div>
                <a href="/admin/teachers/add" class="btn btn-primary btn-sm">
                    <i class="fas fa-plus me-1"></i> Добавить преподавателя
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="mb-4">
                <form method="get" class="row g-3" id="filterForm">
                    <div class="col-md-3">
                        <label for="roleSelect" class="form-label">Роль</label>
                        <select name="role" id="roleSelect" class="form-control">
                            <option value="">Все роли</option>
                            <#list roles as role>
                                <option value="${role}" <#if selectedRole?? && selectedRole == role>selected</#if>>
                                    ${role}
                                </option>
                            </#list>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="statusSelect" class="form-label">Статус</label>
                        <select name="status" id="statusSelect" class="form-control">
                            <option value="">Все статусы</option>
                            <option value="active" <#if selectedStatus?? && selectedStatus == "active">selected</#if>>
                                Активные
                            </option>
                            <option value="inactive" <#if selectedStatus?? && selectedStatus == "inactive">selected</#if>>
                                Неактивные
                            </option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="searchInput" class="form-label">Поиск</label>
                        <input type="text"
                               name="search"
                               id="searchInput"
                               class="form-control"
                               placeholder="Email, имя или фамилия"
                               value="${searchQuery!''}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary me-2" style="display: none;">
                            <i class="fas fa-search"></i> Найти
                        </button>
                        <a href="/admin/users" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Сброс
                        </a>
                    </div>
                </form>
            </div>

            <div class="mb-3">
                <div class="row">
                    <div class="col-md-6">
                        <p class="text-muted mb-0">
                            Найдено пользователей: <strong>${userPage.totalElements}</strong>
                            <#if selectedRole?has_content || selectedStatus?has_content || searchQuery?has_content>
                                <span class="badge bg-info ms-2">Фильтры применены</span>
                            </#if>
                        </p>
                    </div>
                    <div class="col-md-6 text-end">
                        <small class="text-muted">
                            Страница ${userPage.number + 1} из ${userPage.totalPages}
                        </small>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Имя</th>
                        <th>Фамилия</th>
                        <th>Email</th>
                        <th>Телефон</th>
                        <th>Роль</th>
                        <th>Статус</th>
                        <th>Действия</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if userPage.content?has_content>
                        <#list userPage.content as user>
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.lastName!"-"}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <span class="badge bg-primary">${user.role.name}</span>
                                </td>
                                <td>
                                    <#if user.isActive>
                                        <span class="badge bg-success">Активен</span>
                                    <#else>
                                        <span class="badge bg-warning">Неактивен</span>
                                    </#if>
                                </td>
                                <td>
                                    <a href="/admin/users/${user.id}" class="btn btn-sm btn-info" title="Просмотр">
                                        <i class="fas fa-eye"></i>
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
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <p>Пользователи не найдены</p>
                                <#if selectedRole?has_content || selectedStatus?has_content || searchQuery?has_content>
                                    <a href="/admin/users" class="btn btn-sm btn-outline-primary">
                                        Сбросить фильтры
                                    </a>
                                </#if>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <#if userPage.totalPages gt 1>
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <#assign baseUrl = "?size=${userPage.size}&role=${selectedRole!''}&status=${selectedStatus!''}&search=${searchQuery!''}" />

                        <#if userPage.number gt 0>
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}&page=${userPage.number}">
                                   &laquo;
                                </a>
                            </li>
                        </#if>

                        <#list 1..userPage.totalPages as p>
                            <#if (p <= 3) || (p >= userPage.totalPages - 2) || (p >= userPage.number - 1 && p <= userPage.number + 3)>
                                <li class="page-item <#if p == userPage.number + 1>active</#if>">
                                    <a class="page-link" href="${baseUrl}&page=${p}">${p}</a>
                                </li>
                            <#elseif p == 4 && userPage.number > 5>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            <#elseif p == userPage.totalPages - 3 && userPage.number < userPage.totalPages - 4>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </#if>
                        </#list>

                        <#if userPage.number < userPage.totalPages - 1>
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}&page=${userPage.number + 2}">
                                    &raquo;
                                </a>
                            </li>
                        </#if>
                    </ul>
                </nav>
            </#if>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const filterForm = document.getElementById('filterForm');
            const roleSelect = document.getElementById('roleSelect');
            const statusSelect = document.getElementById('statusSelect');
            const searchInput = document.getElementById('searchInput');

            let searchTimer;

            roleSelect.addEventListener('change', function() {
                filterForm.submit();
            });

            statusSelect.addEventListener('change', function() {
                filterForm.submit();
            });

            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimer);
                searchTimer = setTimeout(function() {
                    filterForm.submit();
                }, 500);
            });
        });
    </script>

    <style>
        .table-responsive {
            overflow-x: auto;
        }
        #dataTable {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
        }

        #dataTable th {
            background-color: var(--primary-blue);
            color: white;
            padding: 0.75rem;
            vertical-align: top;
            border-top: 1px solid #dee2e6;
            font-weight: 600;
        }

        #dataTable td {
            padding: 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
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
            background-color: #28a745!important;
            color: white;
        }

        .bg-warning {
            background-color: #ffc107!important;
            color: #212529;
        }

        .bg-primary {
            background-color: var(--primary-blue)!important;
            color: white;
        }

        .bg-info {
            background-color: #17a2b8!important;
            color: white;
        }

        .pagination {
            display: flex;
            padding-left: 0;
            list-style: none;
            border-radius: 0.375rem;
        }

        .page-item.active .page-link {
            background-color: var(--primary-blue);
            border-color: var(--primary-blue);
            color: white;
        }

        .page-link {
            color: var(--primary-blue);
            background-color: #fff;
            border: 1px solid #dee2e6;
            padding: 0.5rem 0.75rem;
            text-decoration: none;
        }

        .page-link:hover {
            color: var(--primary-blue);
            background-color: #e9ecef;
            border-color: #dee2e6;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.25rem;
        }

        .form-label {
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .g-3 > * {
            padding-right: calc(1rem * 0.5);
            padding-left: calc(1rem * 0.5);
            margin-top: 1rem;
        }

        .text-muted {
            color: #6c757d!important;
        }

        .py-4 {
            padding-top: 1.5rem!important;
            padding-bottom: 1.5rem!important;
        }

        .fa-2x {
            font-size: 2em;
        }

        .mb-2 {
            margin-bottom: 0.5rem!important;
        }

        .justify-content-center {
            justify-content: center!important;
        }

        .align-items-end {
            align-items: flex-end!important;
        }
    </style>
</@layout.page>