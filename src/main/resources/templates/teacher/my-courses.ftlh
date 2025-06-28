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
            <#if successMessage??>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                    ${successMessage}
                </div>
            </#if>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <#list courses as course>
                    <div class="col">
                        <div class="card course-card h-100 shadow-sm border-0 d-flex flex-column">
                            <a href="/teacher/course/${course.courseInstanceId}" class="text-decoration-none text-body flex-grow-1 d-flex flex-column p-3">
                                <h5 class="card-title mb-2">${course.courseTitle}</h5>
                                <h6 class="card-subtitle mb-3 text-muted">${course.instanceTitle}</h6>
                                <p class="card-text mt-auto">
                                    <span class="d-block text-muted small">Срок: ${course.startDate.toLocalDate()} – ${course.endDate.toLocalDate()}</span>
                                </p>
                            </a>
                            <div class="card-body pt-0 px-3 pb-3">
                                <a href="/teacher/course/${course.courseInstanceId}" class="btn btn-outline-primary w-100">
                                    Перейти к курсу
                                </a>
                                <#if course.courseTest??>
                                    <a href="/test/${course.courseTest.id}/edit" class="btn btn-outline-primary w-100">
                                        Редактировать итоговый тест
                                    </a>
                                    <a href="/test/${course.courseTest.id}/delete" class="btn btn-outline-danger w-100">
                                        Удалить итоговый тест
                                    </a>
                                    <#else>
                                        <a href="/test/create/${course.courseInstanceId}" class="btn btn-outline-primary w-100">
                                            Создать итоговый тест
                                        </a>
                                </#if>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </#if>
    </div>
</@layout.page>
