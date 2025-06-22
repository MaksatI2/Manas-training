<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="hero-section">
        <h1 class="hero-title">Мои курсы</h1>
    </div>

    <div class="container mt-4">
        <#if courses?size == 0>
            <p>У вас пока нет курсов.</p>
        <#else>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <#list courses as course>
                    <div class="col">
                        <a href="/student/course/${course.courseInstanceId}" class="text-decoration-none text-dark">
                            <div class="card h-100 shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">${course.courseTitle}</h5>
                                    <h6 class="card-subtitle mb-2 text-muted">${course.instanceTitle}</h6>
                                    <p class="card-text">
                                        Статус: <strong>${course.status}</strong><br>
                                        Срок: ${course.startDate.toLocalDate()} – ${course.endDate.toLocalDate()}
                                    </p>
                                </div>
                            </div>
                        </a>
                    </div>
                </#list>
            </div>
        </#if>
    </div>
</@layout.page>
