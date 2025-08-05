<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<@layout.page>
    <@roadmap.breadcrumbs items=[
    {"label": "Главная", "url": "/"},
    {"label": "Мои курсы", "url": ""}
    ] />
    <div class="hero-section py-4 text-center bg-light border-bottom">
        <h1 class="hero-title"><i class="fas fa-book me-2"></i>Мои курсы</h1>
    </div>

    <div class="container my-5">
        <#if courses?size == 0>
            <div class="alert alert-info text-center" role="alert">
                У вас пока нет курсов.
            </div>
        <#else>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <#list courses as course>
                    <div class="col">
                        <div class="card course-card h-100 shadow-sm border-0 d-flex flex-column">
                            <a href="/teacher/course/${course.courseInstanceId}" class="text-decoration-none text-body flex-grow-1 d-flex flex-column p-3">
                                <h5 class="card-title mb-2">${course.instanceTitle}</h5>
                                <h6 class="card-subtitle mb-3 text-muted">${course.courseTitle}</h6>
                                <p class="card-text mt-auto">
                                    <span class="d-block text-muted small">Срок: ${course.startDate} – ${course.endDate}</span>
                                </p>
                            </a>
                            <div class="card-body pt-0 px-3 pb-3">
                                <a href="/teacher/course/${course.courseInstanceId}" class="btn btn-outline-primary w-100 mb-2">
                                    Перейти к курсу
                                </a>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </#if>
    </div>
</@layout.page>
