<#import "/layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
        }

        thead {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: white;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        .btn-sm {
            font-size: 0.8rem;
            padding: 0.4rem 0.6rem;
        }

        .alert {
            max-width: 600px;
            margin: 2rem auto;
        }
    </style>

    <h1 class="page-title">Студенты без организации</h1>

    <#if unassigned?size == 0>
        <div class="alert alert-info text-center shadow-sm">Нет доступных студентов для добавления.</div>
    <#else>
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th>ФИО</th>
                    <th>Email</th>
                    <th>Телефон</th>
                    <th>Действия</th>
                </tr>
                </thead>
                <tbody>
                <#list unassigned as student>
                    <tr>
                        <td>${student.name} ${student.lastName}</td>
                        <td>${student.email}</td>
                        <td>${student.phone}</td>
                        <td>
                            <form action="/organization/students/unassigned/${student.id}/attach" method="post" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-sm btn-success rounded-pill">
                                    <i class="fas fa-user-plus me-1"></i> Добавить
                                </button>
                            </form>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>
    </#if>
</@layout.page>
