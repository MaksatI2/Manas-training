<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto"
             style="max-width: 720px; border-left: 4px solid var(--primary-blue); border-radius: 10px;">
            <div class="card-body">
                <div class="d-flex align-items-start mb-4">
                    <i class="fas fa-gear-fill text-danger fs-1 me-3"></i>
                    <div>
                        <h2 class="h5 fw-bold mb-1"
                            style="color: var(--text-dark);"><@spring.message code="error.500.title"/></h2>
                        <p style="color: var(--text-dark); font-size: 1rem;"><@spring.message code="error.500.message"/></p>
                    </div>
                </div>
                <div class="text-center">
                    <img src="/static/images/error-500.jpg" alt="<@spring.message code='error.500.image.alt'/>"
                         class="img-fluid mb-4" style="max-width: 300px;">
                </div>
                <div class="text-center">
                    <a href="/" class="btn btn-primary"
                       style="background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)); color: var(--white); border-radius: 25px; padding: 0.8rem 2rem;">
                        <i class="fas fa-arrow-left"></i> <@spring.message code="error.button.backToHome"/>
                    </a>
                </div>
            </div>
        </div>
    </div>
</@layout.page>
