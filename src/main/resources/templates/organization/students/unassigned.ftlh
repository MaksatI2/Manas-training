<#import "../../layout.ftlh" as layout>
<#import "../../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": springMacroRequestContext.getMessage("students.unassigned.breadcrumb.home"), "url": "/"},
    {"label": springMacroRequestContext.getMessage("students.unassigned.breadcrumb.students"), "url": "/organization/students"},
    {"label": springMacroRequestContext.getMessage("students.unassigned.breadcrumb.unassigned"), "url": ""}
    ] />
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

    <h1 class="page-title">${springMacroRequestContext.getMessage("students.unassigned.title")}</h1>

    <#if unassigned?size == 0>
        <div class="alert alert-info text-center shadow-sm">${springMacroRequestContext.getMessage("students.unassigned.empty")}</div>
    <#else>
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th>${springMacroRequestContext.getMessage("students.unassigned.table.name")}</th>
                    <th>${springMacroRequestContext.getMessage("students.unassigned.table.email")}</th>
                    <th>${springMacroRequestContext.getMessage("students.unassigned.table.phone")}</th>
                    <th>${springMacroRequestContext.getMessage("students.unassigned.table.actions")}</th>
                </tr>
                </thead>
                <tbody>
                <#list unassigned as student>
                    <tr>
                        <td>${student.name} ${student.lastName}</td>
                        <td>${student.email}</td>
                        <td>${student.phone}</td>
                        <td>
                            <form action="/organization/students/unassigned/${student.id}/attach" method="post"
                                  class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-sm btn-success rounded-pill">
                                    <i class="fas fa-user-plus me-1"></i> ${springMacroRequestContext.getMessage("students.unassigned.button.add")}
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
