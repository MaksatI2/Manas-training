<#import "/spring.ftl" as spring>
<#include "../layout.ftlh">
<@page>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0"><@spring.message code="verify.email.title"/></h4>
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
                        <p>${springMacroRequestContext.getMessage("verify.email.sent", [email])}</p>
                        <p><@spring.message code="verify.email.instructions"/></p>
                        <div class="mt-4">
                            <p class="text-muted"><@spring.message code="verify.email.not.received"/></p>
                            <form method="post" action="/auth/resend-verification" class="d-inline">
                                <#if _csrf??>
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                </#if>
                                <input type="hidden" name="email" value="${email}">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-envelope"></i> <@spring.message code="verify.email.resend.button"/>
                                </button>
                            </form>
                        </div>
                        <div class="mt-3">
                            <small class="text-muted">
                                <@spring.message code="verify.email.check.spam"/>
                            </small>
                        </div>
                        <div class="mt-4 text-center">
                            <a href="/auth/login"
                               class="btn btn-link"><@spring.message code="verify.email.back.login"/></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@page>
