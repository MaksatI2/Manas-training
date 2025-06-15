<#include "../layout.ftlh">
<@page>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Подтверждение Email</h4>
                    </div>
                    <div class="card-body">
                        <#if message??>
                            <div class="alert alert-success" role="alert">
                                ${message}
                            </div>
                        </#if>

                        <#if error??>
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </#if>

                        <p>На вашу почту <strong>${email}</strong> было отправлено письмо с кодом подтверждения.</p>
                        <p>Проверьте почту и нажмите на ссылку из письма для подтверждения вашего аккаунта.</p>

                        <div class="mt-4">
                            <p class="text-muted">Не получили письмо?</p>
                            <form method="post" action="/auth/resend-verification" class="d-inline">
                                <#if _csrf??>
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </#if>
                                <input type="hidden" name="email" value="${email}">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-envelope"></i> Отправить снова
                                </button>
                            </form>
                        </div>

                        <div class="mt-3">
                            <small class="text-muted">
                                Проверьте папку "Спам" или "Нежелательная почта", если письмо не появилось в основной папке.
                            </small>
                        </div>

                        <div class="mt-4 text-center">
                            <a href="/auth/login" class="btn btn-link">Вернуться к входу</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@page>