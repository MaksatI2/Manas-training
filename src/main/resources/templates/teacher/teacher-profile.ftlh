<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring/>

<#assign bcHome><@spring.message code='teacher.profile.public.breadcrumb.home'/></#assign>
<#assign bcTeachers><@spring.message code='teacher.profile.public.breadcrumb.teachers'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcTeachers, "url": "/teacher"},
    {"label": "${teacher.teacher.name} ${teacher.teacher.lastName}", "url": ""}
    ] />
    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
        }

        .teacher-profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 1.5rem;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 102, 204, 0.1);
        }

        .profile-photo img {
            border: 5px solid var(--primary-blue);
            border-radius: 50%;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.15);
            object-fit: cover;
            width: 250px;
            height: 250px;
        }

        .info-section {
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
            transition: transform 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .info-section:hover {
            transform: translateY(-3px);
        }

        .section-title {
            font-weight: 600;
            font-size: 1rem;
            color: var(--text-dark);
            margin-bottom: .5rem;
        }

        .section-content {
            color: #444;
            font-size: 1.2rem;
            line-height: 1.8;
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
            flex-grow: 1;
            align-items: center;
        }

        .contact-line {
            align-items: center;
            color: #444;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .contact-line i {
            margin-right: 12px;
            color: var(--primary-blue);
            font-size: 1.2rem;
        }

        .contact-line a {
            color: inherit;
            text-decoration: none;
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }

        .contact-line:hover {
            color: var(--primary-blue);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-color: var(--primary-blue);
            font-weight: 500;
            transition: .2s;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--dark-blue), #002a5a);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, .3);
        }

        @media (max-width: 768px) {
            .profile-photo img {
                width: 200px;
                height: 200px;
            }

            .section-title {
                font-size: 1rem;
            }

            .section-content {
                font-size: 1.1rem;
            }

            .info-section {
                padding: 1rem;
            }
        }

        @media (max-width: 576px) {
            .profile-photo img {
                width: 150px;
                height: 150px;
            }

            .section-title {
                font-size: 0.9rem;
            }

            .section-content {
                font-size: 1rem;
            }
        }
    </style>

    <#if successMessage??>
        <div id="successMessage" data-message="${successMessage?js_string}"></div>
    </#if>
    <#if errorMessage??>
        <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
    </#if>

    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-user-graduate"></i> <@spring.message code='teacher.profile.public.pageTitle'/>
        </h1>
    </div>

    <div class="teacher-profile-container">

        <div class="profile-card">
            <div class="row">
                <div class="col-12 text-center mb-4">
                    <div class="profile-photo">
                        <img src="<#if teacher.teacher.avatarUrl??>/data/images/${teacher.teacher.avatarUrl}<#else>/static/images/default_avatar.jpg</#if>"
                             alt="${teacher.teacher.name} ${teacher.teacher.lastName}">
                    </div>
                    <#if Session.SPRING_SECURITY_CONTEXT?? && (Session.SPRING_SECURITY_CONTEXT.authentication.principal.getAuthorities()?join(",")?contains("ADMIN"))>
                        <div style="margin-top: 1rem; text-align: center;" class="w-100">
                            <a href="/admin/teachers/${teacher.teacher.id}/manage-courses"
                               class="btn btn-primary p-3 rounded-4">
                                <@spring.message code='teacher.profile.public.manageCourses'/>
                            </a>
                        </div>
                    </#if>
                </div>
            </div>
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <div class="col">
                    <div class="info-section">
                        <div class="section-title"><@spring.message code='teacher.profile.public.fullName'/></div>
                        <div class="section-content">${teacher.teacher.name} ${teacher.teacher.lastName}</div>
                    </div>
                </div>
                <div class="col">
                    <div class="info-section">
                        <div class="section-title"><@spring.message code='teacher.profile.public.subjects'/></div>
                        <div class="section-content">${teacher.department}</div>
                    </div>
                </div>
                <div class="col">
                    <div class="info-section">
                        <div class="section-title"><@spring.message code='teacher.profile.public.contactInfo'/></div>
                        <div class="section-content">
                            <div class="contact-line" onclick="copyToClipboard('${teacher.teacher.email}')">
                                <i class="fas fa-envelope"></i>
                                <a href="mailto:${teacher.teacher.email}"
                                   title="<@spring.message code='teacher.profile.public.emailTooltip'/>">
                                    ${teacher.teacher.email}
                                </a>
                            </div>
                            <#if teacher.teacher.phone??>
                                <div class="contact-line">
                                    <i class="fas fa-phone"></i> <@spring.message code='teacher.profile.public.phone'/>
                                    : ${teacher.teacher.phone}
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
                <#if teacher.qualifications?has_content>
                    <div class="col">
                        <div class="info-section">
                            <div class="section-title"><@spring.message code='teacher.profile.public.qualification'/></div>
                            <div class="section-content">${teacher.qualifications}</div>
                        </div>
                    </div>
                </#if>
            </div>
            <#if teacher.bio?has_content>
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="info-section">
                            <div class="section-title"><@spring.message code='teacher.profile.public.about'/></div>
                            <div class="section-content">${teacher.bio}</div>
                        </div>
                    </div>
                </div>
            </#if>
        </div>
    </div>
    <script>
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                alert("${springMacroRequestContext.getMessage('teacher.profile.public.emailCopied', [], 'Email скопирован в буфер обмена:')} " + text);
            });
        }
    </script>
</@layout.page>
