<#include "../layout.ftlh">

<@page>
    <div class="hero-section">
        <h1 class="hero-title"><@spring.message code="register.choice.title" /></h1>
        <p class="hero-subtitle"><@spring.message code="register.choice.subtitle" /></p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="feature-card text-center h-100">
                        <div class="feature-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <h4 class="mb-3"
                            style="color: var(--primary-blue);"><@spring.message code="register.choice.student.title" /></h4>
                        <p class="mb-4"><@spring.message code="register.choice.student.description" /></p>
                        <ul class="list-unstyled text-start mb-2">
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.student.feature.courses" />
                            </li>
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.student.feature.certificates" />
                            </li>
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.student.feature.progress" />
                            </li>
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.student.feature.profile" />
                            </li>
                        </ul>
                        <a href="/auth/register/student" class="btn btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i><@spring.message code="register.choice.student.button" />
                        </a>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="feature-card text-center h-100">
                        <div class="feature-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <h4 class="mb-3"
                            style="color: var(--primary-blue);"><@spring.message code="register.choice.company.title" /></h4>
                        <p class="mb-4"><@spring.message code="register.choice.company.description" /></p>
                        <ul class="list-unstyled text-start mb-2">
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.company.feature.manage" />
                            </li>
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.company.feature.courses" />
                            </li>
                            <li class="mb-2"><i
                                        class="fas fa-check-circle text-success me-2"></i><@spring.message code="register.choice.company.feature.reports" />
                            </li>
                        </ul>
                        <a href="/auth/register/company" class="btn btn-primary-custom">
                            <i class="fas fa-building me-2"></i><@spring.message code="register.choice.company.button" />
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <p class="text-muted">
            <@spring.message code="register.choice.login.question" />
            <a href="/auth/login"
               style="color: var(--primary-blue);"><@spring.message code="register.choice.login.link" /></a>
        </p>
    </div>
    <style>
        .feature-card {
            display: flex;
            flex-direction: column;
            padding: 2rem 1.5rem;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .feature-card .btn {
            margin-top: auto;
        }
    </style>
</@page>
