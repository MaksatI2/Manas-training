<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring/>

<#assign bcHome><@spring.message code='list.teacher.breadcrumb.home'/></#assign>
<#assign bcTeachers><@spring.message code='list.teacher.breadcrumb.teachers'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcTeachers, "url": ""}
    ] />
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 2rem 0 1.5rem;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: .6rem;
        }

        .page-title i {
            color: var(--primary-blue);
            font-size: 1.6rem;
        }

        .search-box {
            max-width: 480px;
            margin: 0 auto 2rem;
        }

        .search-box .form-control {
            border-radius: 25px;
        }

        .teacher-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1.5rem;
            padding: 0 1rem 3rem;
            max-width: 1280px;
            margin: 0 auto;
        }

        .teacher-card-item {
            flex: 1 1 calc(33.333% - 1rem);
            max-width: 340px;
            min-width: 260px;
            display: flex;
        }

        .teacher-card {
            background: var(--white);
            border-left: 4px solid var(--primary-blue);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, .08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: all .3s ease;
            height: 100%;
            width: 100%;
        }

        .teacher-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 18px rgba(0, 102, 204, .15);
        }

        .teacher-img {
            width: 100%;
            height: 220px;
            object-fit: contain;
            background: #f8f9fa;
            padding: 10px;
            border-bottom: 1px solid #eee;
            border-radius: 10px 10px 0 0;
        }

        .teacher-info {
            padding: 1rem;
            font-size: .9rem;
            color: var(--text-dark);
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .teacher-name {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: .4rem;
        }

        .teacher-name a {
            color: var(--primary-blue);
            text-decoration: none;
        }

        .teacher-name a:hover {
            text-decoration: underline;
        }

        .teacher-department {
            color: #555;
            font-size: .85rem;
            margin-bottom: .4rem;
        }

        .teacher-contact {
            font-size: .85rem;
            color: #333;
        }

        .no-results-message {
            display: none;
            padding: 2rem 0;
            font-size: 1.2rem;
            font-weight: 500;
            color: #888;
        }


        .teacher-contact i {
            color: var(--primary-blue);
            margin-right: 6px;
        }

        .pagination {
            margin-top: 2rem;
        }
    </style>

    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-users"></i> <@spring.message code='list.teacher.page.title'/>
        </h1>

        <div class="search-box">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-white border-end-0">
                    <i class="fas fa-search text-muted"></i>
                </span>
                <input type="text" id="searchInput" class="form-control border-start-0"
                       placeholder="<@spring.message code='list.teacher.search.placeholder'/>">
            </div>
        </div>

        <div class="teacher-grid" id="teacherCardsContainer">
            <#list teachers as teacher>
                <div class="teacher-card-item"
                     data-name="${teacher.fullName?lower_case}" data-department="${teacher.department?lower_case}">
                    <div class="teacher-card">
                        <#if (teacher.avatarUrl?? && teacher.avatarUrl?length gt 0)>
                            <img src="/data/images/${teacher.avatarUrl}" class="teacher-img" alt="${teacher.fullName}">
                        <#else>
                            <img src="/static/images/default_avatar.jpg" class="teacher-img" alt="${teacher.fullName}">
                        </#if>

                        <div class="teacher-info">
                            <div class="teacher-name">
                                <a href="/teacher/${teacher.id}">${teacher.fullName}</a>
                            </div>
                            <div class="teacher-department">
                                ${springMacroRequestContext.getMessage("list.teacher.department.label", [teacher.department], "Перечень преподаваемых дисциплин: " + (teacher.department!""))}
                            </div>
                            <div class="teacher-contact mt-auto flex gap-4">
                                <div><i class="fas fa-envelope"></i>${teacher.email}</div>
                                <#if teacher.phone??>
                                    <div><i class="fas fa-phone"></i>${teacher.phone}</div>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
            <div id="noResultsMessage" class="w-100 text-center text-muted no-results-message">
                <@spring.message code="list.teacher.noResults" />
            </div>
        </div>

        <#if totalPages?has_content && (totalPages?int > 1)>
            <div class="pagination d-flex justify-content-center mt-4">
                <#list 0..(totalPages?int - 1) as i>
                    <a href="?page=${i}&size=${size!9}&search=${search!}&department=${department!}"
                       class="btn btn-sm mx-1 ${(i == currentPage)?then('btn-primary', 'btn-outline-secondary')}">
                        ${i + 1}
                    </a>
                </#list>
            </div>
        </#if>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const searchInput = document.getElementById("searchInput");
            const teacherCards = document.querySelectorAll(".teacher-card-item");
            const noResultsMessage = document.getElementById("noResultsMessage");

            searchInput.addEventListener("input", function () {
                const query = this.value.toLowerCase();
                let visibleCount = 0;

                teacherCards.forEach(function (card) {
                    const name = card.dataset.name;
                    const department = card.dataset.department;
                    const match = name.includes(query) || department.includes(query);
                    card.style.display = match ? "" : "none";
                    if (match) visibleCount++;
                });
                noResultsMessage.style.display = visibleCount === 0 ? "block" : "none";

            });
        });
    </script>
</@layout.page>
