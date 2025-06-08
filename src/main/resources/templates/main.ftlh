<#import "layout.ftlh" as layout>

<@layout.page>

    <#assign known = SPRING_SECURITY_CONTEXT?? >
    <#if known>
        <#assign
        user = SPRING_SECURITY_CONTEXT.authentication.principal
        name = user.firstName
        >
        <div class="alert alert-info mb-4">
            <h4><i class="me-2"></i> Здравствуйте, ${name}!</h4>
            <p class="mb-0">Добро пожаловать в Манас Тренинг Центр.</p>
        </div>
    </#if>
    <div class="hero-section">
        <h1 class="hero-title">Добро пожаловать в Манас Тренинг Центр</h1>
        <p class="hero-subtitle">
            Профессиональная подготовка специалистов в сфере гражданской авиации
            и наземного обслуживания воздушных судов
        </p>
        <button class="btn btn-primary-custom btn-lg">
            <i class="fas fa-play me-2"></i>Начать обучение
        </button>
    </div>

    <div class="row">
        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-laptop-code feature-icon"></i>
                <h4>Онлайн обучение</h4>
                <p>Доступ к интерактивным материалам, видеоурокам и презентациям в любое время</p>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-tasks feature-icon"></i>
                <h4>Тестирование</h4>
                <p>Автоматизированная система проверки знаний с мгновенными результатами</p>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-certificate feature-icon"></i>
                <h4>Сертификация</h4>
                <p>Получение электронных сертификатов после успешного завершения курсов</p>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-users feature-icon"></i>
                <h4>Экспертные преподаватели</h4>
                <p>Обучение у профессионалов авиационной индустрии с многолетним опытом</p>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-mobile-alt feature-icon"></i>
                <h4>Мобильное обучение</h4>
                <p>Адаптивная платформа для обучения с любого устройства</p>
            </div>
        </div>

        <div class="col-lg-4 col-md-6">
            <div class="feature-card text-center">
                <i class="fas fa-chart-line feature-icon"></i>
                <h4>Отслеживание прогресса</h4>
                <p>Детальная аналитика успеваемости и персональные рекомендации</p>
            </div>
        </div>
    </div>
</@layout.page>