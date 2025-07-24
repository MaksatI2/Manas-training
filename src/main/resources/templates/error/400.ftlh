<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 720px; border-left: 4px solid var(--primary-blue); border-radius: 10px;">
            <div class="card-body">
                <div class="d-flex align-items-start mb-4">
                    <i class="fas fa-exclamation-triangle-fill text-danger fs-1 me-3"></i>
                    <div>
                        <h2 class="h5 fw-bold mb-1" style="color: var(--text-dark);">Ошибка в данных</h2>
                        <p style="color: var(--text-dark); font-size: 1rem;">Пожалуйста, проверьте введенные данные.</p>
                    </div>
                </div>
                <div class="text-center">
                    <img src="/static/images/error-400.png" alt="Bad Request illustration" class="img-fluid mb-4" style="max-width: 300px;">
                </div>
                <div class="text-center">
                    <a href="/" class="btn btn-primary" style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); color: var(--white); border-radius: 25px; padding: 0.8rem 2rem;">
                        Вернуться на главную
                    </a>
                </div>
            </div>
        </div>
    </div>
</@layout.page>