<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="hero-section py-4 text-center bg-light border-bottom">
        <h1 class="hero-title">Мои курсы</h1>
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
                        <div class="card course-card h-100 shadow-sm border-0">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title mb-2">
                                    <a href="/student/course/${course.courseInstanceId}" class="text-decoration-none text-primary">
                                        ${course.courseTitle}
                                    </a>
                                </h5>
                                <h6 class="card-subtitle mb-3 text-muted">${course.instanceTitle}</h6>
                                <p class="card-text flex-grow-1">
                                    <span class="d-block text-muted small">Срок: ${course.startDate.toLocalDate()} – ${course.endDate.toLocalDate()}</span>
                                </p>
                                <a href="/teacher/course/${course.courseInstanceId}" class="btn btn-outline-primary mt-auto">
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
