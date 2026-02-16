<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 720px;">
            <div class="card-header bg-danger text-white">
                <h1 class="h4 mb-0">${status}</h1>
            </div>

            <div class="card-body">
                <div class="d-flex align-items-start mb-4">
                    <i class="bi bi-exclamation-triangle-fill text-danger fs-1 me-3"></i>
                    <div>
                        <h2 class="h5 fw-bold mb-1">
                            <@spring.message code="error.general.oops"/> ${reason}
                        </h2>
                    </div>
                </div>

                <#if details??>
                    <div class="bg-light rounded p-3 mb-4">
                        <h3 class="h6 mb-3 text-secondary">
                            <@spring.message code="error.general.techDetails"/>
                        </h3>
                        <ul class="list-unstyled small">
                            <#if details.serverName??>
                                <li class="mb-1">
                                    <strong><@spring.message code="error.general.host"/>:</strong>
                                    <code>${details.serverName}</code>
                                </li>
                            </#if>
                            <#if details.requestURL??>
                                <li class="mb-1">
                                    <strong><@spring.message code="error.general.requestUrl"/>:</strong>
                                    <code>${details.requestURL}</code>
                                </li>
                            </#if>
                            <#if details.serverPort??>
                                <li class="mb-1">
                                    <strong><@spring.message code="error.general.port"/>:</strong>
                                    <code>${details.serverPort?c}</code>
                                </li>
                            </#if>
                            <#if details.requestId??>
                                <li class="mb-1">
                                    <strong><@spring.message code="error.general.requestId"/>:</strong>
                                    <code>${details.requestId}</code>
                                </li>
                            </#if>
                            <li class="mb-1">
                                <strong><@spring.message code="error.general.time"/>:</strong>
                                <code>${.now}</code>
                            </li>
                        </ul>
                    </div>
                </#if>

                <div class="text-center">
                    <a href="/" class="btn btn-primary">
                        <i class="bi bi-arrow-left"></i>
                        <@spring.message code="error.button.backToHome"/>
                    </a>
                </div>
            </div>
        </div>
    </div>
</@layout.page>
