<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="container mb-4">
        <div class="d-flex flex-wrap gap-2">
            <a href="/admin/course-instances/${courseInstance.id}" class="btn btn-secondary">Назад</a>
        </div>
    </div>
    <div class="container py-4">
        <div class="hero-section mb-4 text-center">
            <h2 class="hero-title mb-2">Управление модулями курса: <strong>${courseInstance.title}</strong></h2>
            <p class="hero-subtitle fs-5 text-muted">
                Осталось часов: <span class="fw-semibold">${remainingHours}</span> из <span class="fw-semibold">${courseInstance.durationHours}</span>
            </p>
        </div>


        <div class="feature-card mb-5 p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3">Существующие модули</h3>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th scope="col">Действия</th>
                        <th scope="col" >Порядок</th>
                        <th scope="col" >Название</th>
                        <th scope="col" >Продолжительность (часы)</th>
                        <th scope="col">Описание</th>
                    </tr>
                    </thead>
                    <tbody id="existing-modules">
                    <#list modules as module>

                        <tr data-module-id="${module.id}" data-order-index="${module.orderIndex}">
                            <td>
                                <a href="/admin/course-instances/${courseInstance.id}/modules/${module.id}/edit" class="btn btn-sm btn-primary" title="Редактировать">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button"
                                        class="btn btn-sm btn-danger delete-module-btn"
                                        data-module-id="${module.id}"
                                        data-lessons-count="${module.lessons?size!0}"
                                        title="Удалить">
                                    <i class="fas fa-trash"></i>
                                </button>

                            </td>
                            <td>${module.orderIndex}</td>
                            <td>${module.title}</td>
                            <td>${module.durationHours}</td>
                            <td>
                                <div class="description-cell" id="desc-${module.id}">
                                    ${module.description!''}
                                </div>

                            </td>

                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="limit-reached-info" class="alert alert-warning mt-3 mx-auto" style="display: none; max-width: 600px;">
            Лимит часов исчерпан. Вы не можете добавить больше модулей.
        </div>

        <div class="feature-card p-4 bg-white shadow-sm rounded">
            <h3 class="mb-3">Добавить новые модули</h3>
            <form id="module-form" action="/admin/course-instances/${courseInstance.id}/modules" method="post" novalidate>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div id="new-modules-container" data-remaining-hours="${remainingHours}" class="mb-4">
                    <#if (moduleListDto.modules)?? && moduleListDto.modules?has_content>
                        <#list moduleListDto.modules as module>
                            <div class="new-module-section mb-3 p-3 border rounded" data-index="${module?index}">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="form-label">Название</label>
                                        <@spring.formInput "moduleListDto.modules[${module?index}].title" 'class="form-control"  maxlength="200"' />
                                        <@spring.showErrors "<br>" "error text-danger small" />
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">Часы</label>
                                        <@spring.formInput "moduleListDto.modules[${module?index}].durationHours" 'class="form-control" type="number"  min="1"' />
                                        <@spring.showErrors "<br>" "error text-danger small" />
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Описание</label>
                                        <@spring.formTextarea "moduleListDto.modules[${module?index}].description" 'class="form-control" rows="3"' />
                                        <@spring.showErrors "<br>" "error text-danger small" />
                                    </div>
                                </div>
                                <button type="button" class="btn btn-danger btn-sm mt-2 remove-module-btn">Удалить</button>
                            </div>
                        </#list>
                    </#if>
                </div>

                <div class="d-flex gap-2 flex-wrap">
                    <button type="button" class="btn btn-primary " id="add-module-btn">
                        Добавить модуль
                    </button>
                    <button type="submit" class="btn btn-primary ">
                        Сохранить модули
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal fade" id="deleteModuleModal" tabindex="-1" aria-labelledby="deleteModuleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="deleteModuleForm" method="POST">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModuleModalLabel">Удаление модуля</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                    </div>
                    <div class="modal-body" id="deleteModuleModalBody">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                        <button type="submit" class="btn btn-danger" id="confirmDeleteModuleBtn">Удалить модуль</button>
                    </div>
                </form>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const courseInstanceId = ${courseInstance.id?json_string};
    </script>
    <script src="/static/js/instance_modules.js" defer></script>

    <style>
        .hero-title {
            font-weight: 700;
            color: #343a40;
        }
        .hero-subtitle {
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0066cc, #003d7a);
            border-color: #0066cc;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #003d7a, #002a5a);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .feature-card {
            background-color: #fff;
            border-radius: 0.375rem;
            box-shadow: 0 0.125rem 0.25rem rgb(0 0 0 / 0.075);
        }

        table.table-hover tbody tr:hover {
            background-color: #f1f3f5;
            cursor: pointer;
        }

        #add-module-btn {
            min-width: 140px;
        }
        #add-module-btn.btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        #add-module-btn.btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        button.btn-success {
            min-width: 140px;
        }

        .new-module-section {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }
        .new-module-section:hover {
            box-shadow: 0 0.5rem 1rem rgb(0 0 0 / 0.1);
            transform: translateY(-2px);
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc3545, #a71d2a);
            border: none;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333, #921823);
            transform: translateY(-2px);
        }

    </style>
</@layout.page>