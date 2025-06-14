<div id="courses-grid-wrapper">
    <#if coursePage?? && coursePage.content?size gt 0>
        <div class="course-grid">
            <#list coursePage.content as course>
                <div class="course-card">
                    <div class="course-header">
                        <h5 class="course-title">${course.title}</h5>
                        <div class="course-meta">
                            <span class="course-meta-item">
                                <i class="fas fa-hashtag"></i> ${course.code}
                            </span>
                            <span class="course-meta-item">
                                <i class="fas fa-clock"></i> ${course.duration} ч.
                            </span>
                        </div>
                    </div>
                    <div class="course-body">
                        <p><i class="fas fa-tag me-2 text-primary"></i>Категория: ${course.category.name}</p>
                        <p><i class="fas fa-cube me-2 text-primary"></i>Тип: <#if course.individual>Индивид.<#else>Групп.</#if></p>
                        <p><i class="fas fa-toggle-on me-2 text-primary"></i>Статус:
                            <#if course.active>
                                <span class="text-success">✔ Активен</span>
                            <#else>
                                <span class="text-muted">✖ Неактивен</span>
                            </#if>
                        </p>
                        <a href="/admin/courses/edit/${course.id}" class="btn btn-primary-custom btn-sm w-100 mb-2">
                            <i class="fas fa-edit me-1"></i>Редактировать
                        </a>
                        <a href="/admin/courses/delete/${course.id}" class="btn btn-outline-secondary btn-sm w-100"
                           onclick="return confirm('Удалить курс?');">
                            <i class="fas fa-trash-alt me-1"></i>Удалить
                        </a>
                    </div>
                </div>
            </#list>
        </div>

        <#if pageNumbers??>
            <div class="pagination-container">
                <ul class="pagination">
                    <#list pageNumbers as num>
                        <li class="page-item <#if num == coursePage.number + 1>active</#if>">
                            <a class="page-link"
                               href="?page=${num}&categoryId=${selectedCategoryId!}&search=${searchQuery!}&isActive=${selectedIsActive!}&isIndividual=${selectedIsIndividual!}">
                                ${num}
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>
    <#else>
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle me-2"></i>Курсы не найдены
        </div>
    </#if>
</div>
