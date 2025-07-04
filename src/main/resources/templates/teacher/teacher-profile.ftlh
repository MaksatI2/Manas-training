<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Преподаватели", "url": "/teacher"},
    {"label": "${teacher.teacher.name} ${teacher.teacher.lastName}", "url": ""}
    ] />
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .page-title-block {
            margin: 2rem auto 1.5rem;
            text-align: center;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .page-title i {
            color: var(--primary-blue);
            margin-right: 0.5rem;
        }

        .teacher-profile-container {
            max-width: 1140px;
            margin: 0 auto 2rem;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 2rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .teacher-photo img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.15);
            object-fit: cover;
        }

        .teacher-info-block {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .info-section {
            background-color: var(--white);
            border-left: 4px solid var(--primary-blue);
            padding: 1.2rem 1.5rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
        }

        .section-title {
            font-weight: 600;
            font-size: 1rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .section-content {
            color: #444;
            font-size: 1rem;
        }

        .contact-line {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
            color: #444;
            cursor: pointer;
        }

        .contact-line i {
            margin-right: 10px;
            color: var(--primary-blue);
        }

        .contact-line a {
            color: inherit;
            text-decoration: none;
        }

        .contact-line:hover {
            color: var(--primary-blue);
        }

        @media (max-width: 768px) {
            .teacher-profile-container {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .teacher-info-block {
                text-align: left;
            }

            .contact-line {
                justify-content: center;
            }

            .page-title {
                font-size: 2rem;
            }
        }
    </style>

    <#assign known = Session.SPRING_SECURITY_CONTEXT??>
    <#if known>
        <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
        <#assign name = user.getFullName()>
        <#assign roles = user.getAuthorities()?join(",")>
        <#assign isAdmin = roles?contains("ADMIN")>
    </#if>

    <#if successMessage??>
    <div id="successMessage" data-message="${successMessage?js_string}"></div>
</#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="page-title-block">
        <h1 class="page-title">
            <i class="fas fa-user-graduate"></i>Информация о преподавателе
        </h1>


    </div>

    <div class="teacher-profile-container">
        <div class="teacher-photo">
            <img src="<#if teacher.teacher.avatarUrl??>/data/images/${teacher.teacher.avatarUrl}<#else>/static/images/default_avatar.jpg</#if>"
                 alt="${teacher.teacher.name} ${teacher.teacher.lastName}">
            <#if isAdmin>
                <div style="margin-top: 1rem; text-align: center;" class="w-100">
                    <a href="/admin/teachers/${teacher.teacher.id}/manage-courses"
                       class="btn btn-primary w-100">
                        Управлять курсами
                    </a>
                </div>
            </#if>
        </div>

        <div class="teacher-info-block">
            <div class="info-section">
                <div class="section-title">ФИО преподавателя</div>
                <div class="section-content">${teacher.teacher.name} ${teacher.teacher.lastName}</div>
            </div>

            <div class="info-section">
                <div class="section-title">Перечень преподаваемых дисциплин</div>
                <div class="section-content">${teacher.department}</div>
            </div>

            <div class="info-section">
                <div class="section-title">Контактная информация</div>
                <div class="section-content">
                    <div class="contact-line" onclick="copyToClipboard('${teacher.teacher.email}')">
                        <i class="fas fa-envelope"></i>
                        <a href="mailto:${teacher.teacher.email}" title="Нажмите, чтобы скопировать">
                            ${teacher.teacher.email}
                        </a>
                    </div>
                    <#if teacher.teacher.phone??>
                        <div class="contact-line">
                            <i class="fas fa-phone"></i> ${teacher.teacher.phone}
                        </div>
                    </#if>
                </div>
            </div>

            <#if teacher.qualifications?has_content>
                <div class="info-section">
                    <div class="section-title">Квалификация</div>
                    <div class="section-content">${teacher.qualifications}</div>
                </div>
            </#if>

            <#if teacher.bio?has_content>
                <div class="info-section">
                    <div class="section-title">О преподавателе</div>
                    <div class="section-content">${teacher.bio}</div>
                </div>
            </#if>
        </div>
    </div>

    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                alert("Email скопирован в буфер обмена: " + text);
            });
        }
    </script>
</@layout.page>
