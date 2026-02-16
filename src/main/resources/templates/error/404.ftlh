<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as layout>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto"
             style="max-width: 720px; border-left: 4px solid var(--primary-blue); border-radius: 10px;">
            <div class="card-body">
                <div class="d-flex align-items-start mb-4">
                    <i class="fas fa-exclamation-circle-fill text-danger fs-1 me-3"></i>
                    <div>
                        <h2 class="h3 fw-bold mb-1"
                            style="color: var(--text-dark);"><@spring.message code="error.404.title"/></h2>
                        <p style="color: var(--text-dark); font-size: 1rem;"><@spring.message code="error.404.message"/></p>
                    </div>
                </div>
                <div class="text-center">
                    <img src="/static/images/error-404.jpg" alt="<@spring.message code='error.404.image.alt'/>"
                         class="img-fluid mb-4" style="max-width: 300px;">
                </div>
                <div class="text-center">
                    <a href="/" class="btn btn-primary"
                       style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); color: var(--white); border-radius: 25px; padding: 0.8rem 2rem;">
                        <@spring.message code="error.button.backToHome"/>
                    </a>
                </div>
            </div>
        </div>
    </div>
</@layout.page>
