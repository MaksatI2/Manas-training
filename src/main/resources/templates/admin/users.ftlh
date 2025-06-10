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
                <form method="get" class="form-inline">
                    <div class="form-group mr-2">
                        <select name="role" class="form-control">
                            <option value="">Все пользователи</option>
                            <#list roles as role>
                                <option value="${role}" <#if selectedRole?? && selectedRole == role>selected</#if>>
                                    ${role}
                                </option>
                            </#list>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Фильтровать</button>
                </form>
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
                    <#list userPage.content as user>
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.name}</td>
                            <td>${user.lastName!"-"}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>${user.role.name}</td>
                            <td>
                                <#if user.isActive>
                                    <span class="badge bg-success">Активен</span>
                                <#else>
                                    <span class="badge bg-warning">Неактивен</span>
                                </#if>
                            </td>
                            <td>
                                <a href="/admin/users/${user.id}" class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <#if !user.isActive>
                                    <a href="/admin/users/${user.id}/activate" class="btn btn-sm btn-success">
                                        <i class="fas fa-check"></i>
                                    </a>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>

            <#if userPage.totalPages gt 1>
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <#list 1..userPage.totalPages as p>
                            <li class="page-item <#if p == userPage.number + 1>active</#if>">
                                <a class="page-link" href="?page=${p}&size=${userPage.size}&role=${selectedRole!''}">${p}</a>
                            </li>
                        </#list>
                    </ul>
                </nav>
            </#if>
        </div>
    </div>
    <style>
        /* Добавить в существующий стиль */
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
        }

        #dataTable td {
            padding: 0.75rem;
            vertical-align: top;
            border-top: 1px solid #dee2e6;
        }

        .badge {
            display: inline-block;
            padding: 0.25em 0.4em;
            font-size: 75%;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.25rem;
        }

        .bg-success {
            background-color: #28a745!important;
        }

        .bg-warning {
            background-color: #ffc107!important;
            color: #212529;
        }

        .pagination {
            display: flex;
            padding-left: 0;
            list-style: none;
            border-radius: 0.25rem;
        }

        .page-item.active .page-link {
            background-color: var(--primary-blue);
            border-color: var(--primary-blue);
        }

        .page-link {
            color: var(--primary-blue);
            background-color: #fff;
            border: 1px solid #dee2e6;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.2rem;
        }
    </style>
</@layout.page>