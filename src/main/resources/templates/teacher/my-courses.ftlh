<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#import "/spring.ftl" as spring/>

<#assign bcHome><@spring.message code='teacher.myCourses.breadcrumb.home'/></#assign>
<#assign bcMy><@spring.message code='teacher.myCourses.breadcrumb.myCourses'/></#assign>

<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": bcHome, "url": "/"},
    {"label": bcMy, "url": ""}
    ] />
    <div class="hero-section py-4 text-center bg-light border-bottom">
        <h1 class="hero-title"><i class="fas fa-book me-2"></i><@spring.message code='teacher.myCourses.title'/></h1>
    </div>

    <div class="container my-5">
        <#if courses?size == 0>
            <div class="alert alert-info text-center" role="alert">
                <@spring.message code='teacher.myCourses.alert.noCourses'/>
            </div>
        <#else>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <#list courses as course>
                    <div class="col">
                        <div class="card course-card h-100 shadow-sm border-0">
                            <div class="card-header bg-gradient-primary text-white d-flex align-items-center justify-content-between">
                                <h5 class="card-title mb-0">${course.instanceTitle}</h5>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-subtitle mb-2 text-muted">${course.courseTitle}</h6>
                                <p class="card-text text-muted small mb-3">
                                    <@spring.message code='teacher.myCourses.course.term'/> ${course.startDate}
                                    – ${course.endDate}
                                </p>
                                <span class="badge mb-3 <#if course.isActive>bg-success<#else>bg-secondary</#if>">
                                    <#if course.isActive>
                                        <@spring.message code='teacher.course.detail.status.active'/>
                                    <#else>
                                        <@spring.message code='teacher.course.detail.status.completed'/>
                                    </#if>
                                </span>
                                <a href="/teacher/course/${course.courseInstanceId}"
                                   class="btn btn-primary w-100 mt-auto">
                                    <@spring.message code='teacher.myCourses.course.goTo'/>
                                </a>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </#if>
    </div>

    <style>
        :root {
            --primary-blue: #0066cc;
            --dark-blue: #003d7a;
            --light-blue: #87ceeb;
            --text-dark: #2c3e50;
            --white: #ffffff;
        }

        .hero-section {
            background: linear-gradient(135deg, var(--light-blue), var(--white));
            border-bottom: 2px solid var(--primary-blue);
        }

        .hero-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        .course-card {
            border-radius: 12px;
            transition: all .3s ease-in-out;
            overflow: hidden;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, .2);
        }

        .card-header.bg-gradient-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-bottom: none;
            padding: 1rem;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            line-height: 1.4;
        }

        .card-subtitle {
            font-size: 1rem;
            font-weight: 400;
        }

        .card-text {
            font-size: .875rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-color: var(--primary-blue);
            font-weight: 500;
            transition: all .2s ease-in-out;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--dark-blue), #002a5a);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, .3);
        }

        .badge {
            font-size: .75rem;
            padding: .5em 1em;
            border-radius: .5rem;
        }

        .bg-success {
            background-color: #28a745 !important;
        }

        .bg-secondary {
            background-color: #6c757d !important;
        }

        @media (min-width: 770px) and (max-width: 933px) {
            .course-card {
                font-size: .95rem;
            }

            .card-title {
                font-size: 1.1rem;
            }

            .card-subtitle {
                font-size: .9rem;
            }

            .card-text {
                font-size: .8rem;
            }

            .btn-primary {
                padding: .5rem;
                font-size: .9rem;
            }

            .badge {
                font-size: .7rem;
            }
        }

        @media (max-width: 576px) {
            .course-card {
                font-size: .9rem;
            }

            .card-title {
                font-size: 1rem;
            }

            .card-subtitle {
                font-size: .85rem;
            }

            .card-text {
                font-size: .75rem;
            }

            .btn-primary {
                padding: .5rem;
                font-size: .85rem;
            }
        }
    </style>
</@layout.page>
