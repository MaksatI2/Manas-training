<#import "../layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .breadcrumb-wrapper {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: white;
            padding: 0.75rem 0;
        }

        .breadcrumb-wrapper .container {
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }

        .breadcrumb-wrapper a {
            color: white;
            text-decoration: none;
            margin-right: 0.5rem;
        }

        .breadcrumb-wrapper a:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            margin: 0 0.4rem;
            color: #ccc;
        }

        .breadcrumb-current {
            font-weight: 600;
            color: #fff;
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
            gap: 0.6rem;
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
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            padding: 0 1rem 3rem;
            max-width: 1280px;
            margin: 0 auto;
        }

        .teacher-card {
            background: var(--white);
            border-left: 4px solid var(--primary-blue);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }

        .teacher-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 18px rgba(0, 102, 204, 0.15);
        }

        .teacher-img {
            width: 100%;
            height: 220px;
            object-fit: contain;
            background-color: #f8f9fa;
            padding: 10px;
            border-bottom: 1px solid #eee;
            border-radius: 10px 10px 0 0;
        }

        .teacher-info {
            padding: 1rem;
            font-size: 0.9rem;
            color: var(--text-dark);
        }

        .teacher-name {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.4rem;
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
            font-size: 0.85rem;
            margin-bottom: 0.4rem;
        }

        .teacher-contact {
            font-size: 0.85rem;
            color: #333;
        }

        .teacher-contact i {
            color: var(--primary-blue);
            margin-right: 6px;
        }

        .pagination {
            margin-top: 2rem;
        }
    </style>

    <div class="breadcrumb-wrapper text-center">
        <nav class="breadcrumb-nav d-inline-block">
            <a href="/">Главная</a>
            <span class="breadcrumb-separator">›</span>
            <a href="/teachers">Наши преподаватели</a>
        </nav>
    </div>

    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-users"></i> Наши преподаватели
        </h1>

        <div class="search-box">
            <div class="input-group shadow-sm">
                <span class="input-group-text bg-white border-end-0">
                    <i class="fas fa-search text-muted"></i>
                </span>
                <input type="text" id="searchInput" class="form-control border-start-0"
                       placeholder="Поиск по имени или списку преподаваемых дисциплин...">
            </div>
        </div>

        <div class="teacher-grid" id="teacherCardsContainer">
            <#list teachers as teacher>
                <div class="teacher-card teacher-card-item"
                     data-name="${teacher.fullName?lower_case}" data-department="${teacher.department?lower_case}">
                    <#if teacher.avatarUrl?? && teacher.avatarUrl?length gt 0>
                        <img src="/data/images/${teacher.avatarUrl}" class="teacher-img" alt="${teacher.fullName}">
                    <#else>
                        <img src="/static/images/default_avatar.jpg" class="teacher-img" alt="${teacher.fullName}">
                    </#if>

                    <div class="teacher-info">
                        <div class="teacher-name">
                            <a href="/teachers/${teacher.id}">${teacher.fullName}</a>
                        </div>
                        <div class="teacher-department">
                            Перечень преподаваемых дисциплин: ${teacher.department}
                        </div>
                        <div class="teacher-contact">
                            <div><i class="fas fa-envelope"></i>${teacher.email}</div>
                            <#if teacher.phone??>
                                <div><i class="fas fa-phone"></i>${teacher.phone}</div>
                            </#if>
                        </div>
                    </div>
                </div>
            </#list>
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

            searchInput.addEventListener("input", function () {
                const query = this.value.toLowerCase();
                teacherCards.forEach(function (card) {
                    const name = card.dataset.name;
                    const department = card.dataset.department;
                    card.style.display = (name.includes(query) || department.includes(query)) ? "" : "none";
                });
            });
        });
    </script>
</@layout.page>
