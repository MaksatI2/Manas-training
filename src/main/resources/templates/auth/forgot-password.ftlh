<#include "../layout.ftlh">
<@page>
    <div class="hero-section">
        <h1 class="hero-title">
            <i class="fas fa-key me-3"></i><@spring.message code="forgot.password.title" />
        </h1>
        <p class="hero-subtitle"><@spring.message code="forgot.password.subtitle" /></p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <#if message??>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </#if>
            <#if error??>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </#if>
            <div class="feature-card">
                <form method="post" action="/auth/forgot-password" id="forgotForm">
                    <#if _csrf??>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </#if>

                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i><@spring.message code="forgot.password.email" />
                        </label>
                        <input type="email" class="form-control" name="email" id="email"
                               placeholder="<@spring.message code='forgot.password.email.placeholder' />">
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="fas fa-paper-plane me-2"></i><@spring.message code="forgot.password.send.link" />
                        </button>
                    </div>
                </form>
            </div>

            <div class="text-center mt-4">
                <a href="/auth/login" style="color: var(--primary-blue);">
                    <i class="fas fa-arrow-left me-1"></i><@spring.message code="forgot.password.back.to.login" />
                </a>
            </div>
        </div>
    </div>
</@page>
