<div id="category-grid-fragment">
    <#if categoryPage?? && categoryPage.content?size gt 0>
        <div class="table-responsive rounded-4 shadow-sm">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Название</th>
                    <th>Описание</th>
                    <th class="text-end">Действия</th>
                </tr>
                </thead>
                <tbody>
                <#list categoryPage.content as cat>
                    <tr>
                        <td>${cat.id}</td>
                        <td>${cat.name}</td>
                        <td>${cat.description!}</td>
                        <td class="text-end">
                            <a href="/admin/categories/edit/${cat.id}" class="btn btn-sm btn-primary-custom me-2">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="/admin/categories/delete/${cat.id}" class="btn btn-sm btn-outline-secondary"
                               onclick="return confirm('Удалить категорию?');">
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>

        <#if pageNumbers?? && pageNumbers?size gt 1>
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <#list pageNumbers as p>
                        <li class="page-item <#if p == categoryPage.number + 1>active</#if>">
                            <a class="page-link category-page-link"
                               href="?page=${p}&search=${search!}">
                                ${p}
                            </a>
                        </li>
                    </#list>
                </ul>
            </nav>
        </#if>
    <#else>
        <div class="alert alert-info mt-4">
            <i class="fas fa-info-circle me-2"></i>
            Категории не найдены
        </div>
    </#if>
</div>
