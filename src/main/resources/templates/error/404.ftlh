<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 720px; border-left: 4px solid var(--primary-blue); border-radius: 10px;">
            <div class="card-header" style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); color: var(--white);">
                <h1 class="h4 mb-0">${status} ${reason}</h1>
            </div>
            <div class="card-body">
                <div class="d-flex align-items-start mb-4">
                    <i class="bi bi-exclamation-circle-fill text-danger fs-1 me-3"></i>
                    <div>
                        <h2 class="h5 fw-bold mb-1" style="color: var(--text-dark);">
                            Занятие не найдено
                        </h2>
                        <p style="color: var(--text-dark); font-size: 1rem;">
                            ${message}
                        </p>
                        <p style="color: var(--text-dark); font-size: 1rem;">
                            Такой страницы нет. Возможно, вы ввели неправильный адрес.
                        </p>
                    </div>
                </div>
                <div class="text-center">
                    <img src="/static/images/empty-classroom.jpg" alt="Empty classroom illustration" class="img-fluid mb-4" style="max-width: 300px;">
                    <p style="color: var(--text-dark); font-size: 0.9rem;">
                        Вернитесь в личный кабинет или начните обучение заново.
                    </p>
                    <a href="/" class="btn btn-primary" style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); color: var(--white); border-radius: 25px; padding: 0.8rem 2rem;">
                        <i class="bi bi-arrow-left"></i> Вернуться на главную
                    </a>
                    <a href="/courses" class="btn btn-outline-primary ms-2" style="border-color: var(--primary-blue); color: var(--primary-blue); border-radius: 25px; padding: 0.8rem 2rem;">
                        <i class="bi bi-book"></i> Перейти к курсам
                    </a>
                </div>
            </div>
        </div>
    </div>
</@layout.page>