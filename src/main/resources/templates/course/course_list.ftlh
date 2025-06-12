<#import "../layout.ftlh" as layout>
<@layout.page>
    <style>
        .courses-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .filter-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 102, 204, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary-blue);
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .course-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
            border-left: 4px solid var(--light-blue);
        }

        .course-card:hover {
            transform: translateY(-7px);
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.15);
        }

        .course-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0, 102, 204, 0.1);
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-title {
            color: var(--primary-blue);
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .course-meta {
            display: flex;
            gap: 1.5rem;
            margin: 1rem 0;
            font-size: 0.9rem;
        }

        .course-meta-item {
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .empty-courses {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2rem;
        }
    </style>

    <div class="courses-container">
        <h1 class="page-title">
            <i class="fas fa-graduation-cap me-2" style="color: var(--primary-blue);"></i>
            Каталог курсов
        </h1>

        <div class="filter-card">
            <form method="GET" action="/courses">
                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">
                            <i class="fas fa-filter me-1"></i>Категория
                        </label>
                        <select name="categoryId" class="form-select">
                            <option value="">Все категории</option>
                            <#list categories as category>
                                <option value="${category.id}"
                                        <#if categoryId?? && categoryId == category.id>selected</#if>>
                                    ${category.name}
                                </option>
                            </#list>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label">
                            <i class="fas fa-search me-1"></i>Поиск
                        </label>
                        <input type="text" name="search" class="form-control"
                               placeholder="По названию или коду" value="${search!''}">
                    </div>

                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary-custom w-100">
                            <i class="fas fa-check me-1"></i>Применить
                        </button>
                        <a href="/courses/reset" class="btn btn-outline-secondary w-100 mt-2">
                            <i class="fas fa-redo me-1"></i>Сбросить
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <#if courses?size == 0>
            <div class="alert alert-info text-center">
                <i class="fas fa-info-circle me-2"></i>
                Курсы по вашему запросу не найдены
            </div>
        <#else>
            <div class="course-grid">
                <#list courses as course>
                    <div class="course-card">
                        <div class="course-header">
                            <h5 class="course-title">${course.title}</h5>
                            <div class="course-meta">
                                <span class="course-meta-item">
                                    <i class="fas fa-hashtag"></i>
                                    ${course.code}
                                </span>
                                <span class="course-meta-item">
                                    <i class="fas fa-clock"></i>
                                    ${course.duration}
                                </span>
                            </div>
                        </div>
                        <div class="course-body">
                            <p class="mb-3">
                                <i class="fas fa-tag me-2 text-primary"></i>
                                Категория: ${course.category.name}
                            </p>
                            <a href="/courses/${course.id}" class="btn btn-outline-primary w-100">
                                <i class="fas fa-info-circle me-2"></i>Подробнее
                            </a>
                        </div>
                    </div>
                </#list>
            </div>

            <#if totalPages gt 1>
                <div class="pagination-container">
                    <ul class="pagination">
                        <#if currentPage gt 1>
                            <li class="page-item">
                                <a class="page-link" href="/courses?page=${currentPage - 1}&categoryId=${categoryId!''}&search=${search!''}" aria-label="Предыдущая страница">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </#if>

                        <#assign startPage = (currentPage - 2)>
                        <#if startPage lt 1>
                            <#assign startPage = 1>
                        </#if>
                        <#assign endPage = (currentPage + 2)>
                        <#if endPage gt totalPages>
                            <#assign endPage = totalPages>
                        </#if>
                        <#if startPage gt 1>
                            <li class="page-item">
                                <a class="page-link" href="/courses?page=1&categoryId=${categoryId!''}&search=${search!''}" aria-label="Первая страница">1</a>
                            </li>
                            <#if startPage gt 2>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </#if>
                        </#if>

                        <#list startPage..endPage as count>
                            <li class="page-item <#if currentPage == count>active</#if>">
                                <a class="page-link" href="/courses?page=${count}&categoryId=${categoryId!''}&search=${search!''}" aria-label="Страница ${count}">${count}</a>
                            </li>
                        </#list>

                        <#if endPage lt totalPages>
                            <#if endPage lt (totalPages - 1)>
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </#if>
                            <li class="page-item">
                                <a class="page-link" href="/courses?page=${totalPages}&categoryId=${categoryId!''}&search=${search!''}" aria-label="Последняя страница">${totalPages}</a>
                            </li>
                        </#if>

                        <#if currentPage < totalPages>
                            <li class="page-item">
                                <a class="page-link" href="/courses?page=${currentPage + 1}&categoryId=${categoryId!''}&search=${search!''}" aria-label="Следующая страница">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </#if>
                    </ul>
                </div>
            </#if>
        </#if>
    </div>
</@layout.page>