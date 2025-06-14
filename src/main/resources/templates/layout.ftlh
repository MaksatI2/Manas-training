<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Манас Тренинг Центр</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.5.0/css/flag-icon.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #0066cc;
                --light-blue: #87ceeb;
                --white: #ffffff;
                --dark-blue: #003d7a;
                --text-dark: #2c3e50;
                --sidebar-width: 280px;
                --sidebar-collapsed-width: 70px;
                --shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
                overflow-x: hidden;
            }

            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                width: var(--sidebar-width);
                background: linear-gradient(180deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
                z-index: 1000;
                transition: all 0.3s ease;
                overflow-y: auto;
                box-shadow: var(--shadow);
            }

            .sidebar.collapsed {
                width: var(--sidebar-collapsed-width);
            }

            .sidebar-toggle {
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: var(--primary-blue);
                color: var(--white);
                border: none;
                width: 45px;
                height: 45px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: var(--shadow);
            }

            .sidebar-toggle:hover {
                background: var(--dark-blue);
                transform: scale(1.1);
            }

            .sidebar-toggle.collapsed {
                left: 85px;
            }

            .sidebar-header {
                padding: 1.5rem;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                background: rgba(0, 0, 0, 0.1);
            }

            .sidebar-brand {
                color: var(--white);
                font-size: 1.4rem;
                font-weight: bold;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 12px;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .sidebar-brand {
                justify-content: center;
            }

            .sidebar.collapsed .sidebar-brand span {
                display: none;
            }

            .sidebar-brand:hover {
                color: var(--light-blue);
                transform: translateX(5px);
            }

            .sidebar.collapsed .sidebar-brand:hover {
                transform: none;
            }

            .sidebar-brand i {
                font-size: 1.8rem;
            }

            .sidebar-nav {
                padding: 1rem 0;
            }

            .nav-section {
                margin-bottom: 2rem;
            }

            .nav-section-title {
                color: var(--light-blue);
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                padding: 0 1.5rem;
                margin-bottom: 1rem;
                opacity: 0.8;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .nav-section-title {
                opacity: 0;
                height: 0;
                margin: 0;
                padding: 0;
                overflow: hidden;
            }

            .nav-item {
                margin-bottom: 0.5rem;
            }

            .nav-link {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 0.8rem 1.5rem;
                color: rgba(255, 255, 255, 0.9);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                border-radius: 0;
                position: relative;
            }

            .sidebar.collapsed .nav-link {
                justify-content: center;
                padding: 0.8rem;
            }

            .sidebar.collapsed .nav-link span {
                display: none;
            }

            .nav-link::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                height: 100%;
                width: 4px;
                background: var(--light-blue);
                transform: scaleY(0);
                transition: transform 0.3s ease;
            }

            .nav-link:hover {
                background: rgba(255, 255, 255, 0.1);
                color: var(--white);
                transform: translateX(5px);
            }

            .sidebar.collapsed .nav-link:hover {
                transform: none;
            }

            .nav-link:hover::before {
                transform: scaleY(1);
            }

            .nav-link.active {
                background: rgba(135, 206, 235, 0.2);
                color: var(--white);
            }

            .nav-link.active::before {
                transform: scaleY(1);
            }

            .nav-link i {
                font-size: 1.1rem;
                width: 20px;
                text-align: center;
            }

            .sidebar.collapsed .nav-link {
                position: relative;
            }

            .sidebar.collapsed .nav-link::after {
                content: attr(data-tooltip);
                position: absolute;
                left: 100%;
                top: 50%;
                transform: translateY(-50%);
                background: var(--dark-blue);
                color: var(--white);
                padding: 0.5rem 0.8rem;
                border-radius: 4px;
                font-size: 0.85rem;
                white-space: nowrap;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
                margin-left: 10px;
                box-shadow: var(--shadow);
                z-index: 1002;
            }

            .sidebar.collapsed .nav-link:hover::after {
                opacity: 1;
                visibility: visible;
            }

            .sidebar-profile {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                padding: 1.5rem;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
                background: rgba(0, 0, 0, 0.1);
            }

            .sidebar.collapsed .sidebar-profile {
                padding: 1rem 0.5rem;
            }

            .profile-info {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .profile-info {
                justify-content: center;
                margin-bottom: 0.5rem;
            }

            .sidebar.collapsed .profile-info > div {
                display: none;
            }

            .profile-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: var(--light-blue);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--dark-blue);
                font-weight: bold;
                font-size: 1.2rem;
            }

            .profile-name {
                color: var(--white);
                font-weight: 600;
                font-size: 0.9rem;
            }

            .profile-role {
                color: var(--light-blue);
                font-size: 0.8rem;
            }

            .profile-actions {
                display: flex;
                gap: 10px;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .profile-actions {
                flex-direction: column;
                align-items: center;
                gap: 5px;
            }

            .profile-btn {
                flex: 1;
                padding: 0.5rem;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 8px;
                color: var(--white);
                text-decoration: none;
                text-align: center;
                font-size: 0.85rem;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .profile-btn {
                width: 40px;
                height: 40px;
                padding: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }

            .sidebar.collapsed .profile-btn span {
                display: none;
            }

            .profile-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                color: var(--white);
                transform: translateY(-2px);
            }

            .sidebar.collapsed .profile-btn:hover {
                transform: scale(1.1);
            }

            .language-selector {
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 8px;
                padding: 0.5rem 1rem;
                color: var(--white);
                width: 100%;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
            }

            .sidebar.collapsed .language-selector {
                width: 40px;
                height: 40px;
                padding: 0;
                text-align: center;
                font-size: 1.2rem;
                border-radius: 50%;
                appearance: none;
                background-position: center;
                background-repeat: no-repeat;
            }

            .language-selector:focus {
                background: rgba(255, 255, 255, 0.2);
                color: var(--white);
                border-color: var(--light-blue);
                outline: none;
            }

            .main-wrapper {
                margin-left: var(--sidebar-width);
                transition: margin-left 0.3s ease;
                min-height: 100vh;
            }

            .main-wrapper.collapsed {
                margin-left: var(--sidebar-collapsed-width);
            }

            .top-header {
                background: var(--white);
                padding: 1rem 2rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                display: none;
            }

            .main-content {
                padding: 2rem;
                padding-top: 4rem;
            }

            .hero-section {
                background: linear-gradient(135deg, rgba(0, 102, 204, 0.1), rgba(135, 206, 235, 0.1));
                border-radius: 15px;
                padding: 3rem;
                margin-bottom: 2rem;
                text-align: center;
            }

            .hero-title {
                color: var(--primary-blue);
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }

            .hero-subtitle {
                color: var(--text-dark);
                font-size: 1.2rem;
                margin-bottom: 2rem;
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
                border: none;
                padding: 0.8rem 2rem;
                border-radius: 25px;
                font-weight: 500;
                color: var(--white);
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
            }

            .feature-card {
                background: var(--white);
                border-radius: 10px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 15px rgba(0, 102, 204, 0.1);
                transition: transform 0.3s ease;
                border-left: 4px solid var(--primary-blue);
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
                color: var(--white);
            }

            @media (max-width: 768px) {
                .sidebar-toggle {
                    display: none;
                }

                .sidebar {
                    transform: translateX(-100%);
                    width: 100%;
                    max-width: var(--sidebar-width);
                }

                .sidebar.open {
                    transform: translateX(0);
                }

                .main-wrapper {
                    margin-left: 0;
                }

                .main-wrapper.collapsed {
                    margin-left: 0;
                }

                .main-content {
                    padding-top: 1rem;
                }

                .top-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .mobile-menu-btn {
                    background: none;
                    border: none;
                    color: var(--primary-blue);
                    font-size: 1.5rem;
                    cursor: pointer;
                    padding: 0.5rem;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                }

                .mobile-menu-btn:hover {
                    background: rgba(0, 102, 204, 0.1);
                }

                .hero-title {
                    font-size: 2rem;
                }

                .hero-section {
                    padding: 2rem 1rem;
                }

                .main-content {
                    padding: 1rem;
                }
            }

            .sidebar-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
            }

            .sidebar-overlay.active {
                opacity: 1;
                visibility: visible;
            }

            .sidebar::-webkit-scrollbar {
                width: 6px;
            }

            .sidebar::-webkit-scrollbar-track {
                background: rgba(255, 255, 255, 0.1);
            }

            .sidebar::-webkit-scrollbar-thumb {
                background: rgba(255, 255, 255, 0.3);
                border-radius: 3px;
            }

            .sidebar::-webkit-scrollbar-thumb:hover {
                background: rgba(255, 255, 255, 0.5);
            }
        </style>
    </head>
    <body>
    <#assign known = Session.SPRING_SECURITY_CONTEXT??>
    <#if known>
        <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
        <#assign name = user.getUsername()>
        <#assign roles = user.getAuthorities()?join(",")>
        <#assign isAdmin = roles?contains("ADMIN")>
        <#assign isTeacher = roles?contains("TEACHER")>
        <#assign isStudent = roles?contains("STUDENT")>
        <#assign isOrganization = roles?contains("ORGANIZATION")>
    </#if>

    <button class="sidebar-toggle" id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>

    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <a href="/" class="sidebar-brand">
                <i class="fas fa-graduation-cap"></i>
                <span>Манас Центр</span>
            </a>
        </div>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <#if !known || !isAdmin>
                        <li class="nav-item">
                            <a class="nav-link" href="/"><i class="fas fa-home me-1"></i>Главная</a>
                        </li>
                    </#if>
                    <li class="nav-item">
                        <a class="nav-link" href="/courses"><i class="fas fa-book me-1"></i>Курсы</a>
                    </li>

                    <#if known>
                        <#if isAdmin>
                            <li class="nav-item">
                                <a class="nav-link" href="/admin/users"><i
                                            class="fas fa-users me-1"></i>Пользователи</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/#"><i
                                            class="fas fa-chart-bar me-1"></i>Отчеты</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><i class="fas fa-calendar me-1"></i>Расписание</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/admin/courses">
                                    <i class="fas fa-book-open me-1"></i>Управление курсами
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/admin/categories">
                                    <i class="fas fa-tags me-1"></i>Категории курсов
                                </a>
                            </li>
                        </#if>

                        <#if isTeacher>
                            <li class="nav-item">
                                <a class="nav-link" href="/#"><i class="fas fa-question-circle me-1"></i>Тесты</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><i class="fas fa-calendar me-1"></i>Расписание</a>
                            </li>
                        </#if>

                        <#if isOrganization>
                            <li class="nav-item">
                                <a class="nav-link" href="/#"><i class="fas fa-user-tie me-1"></i>Сотрудники</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/#"><i
                                class="fas fa-graduation-cap me-1"></i>Курсы</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><i class="fas fa-calendar me-1"></i>Расписание</a>
                            </li>
                        </#if>

                        <#if isStudent>
                            <li class="nav-item">
                                <a class="nav-link" href="/#"><i class="fas fa-book-open me-1"></i>Мои
                                    курсы</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><i class="fas fa-calendar me-1"></i>Расписание</a>
                            </li>
                        </#if>
                    </#if>
                </ul>

                <div class="d-flex align-items-center">
                    <select class="form-select language-selector me-3" style="width: auto;">
                        <option value="ru">Русский</option>
                        <option value="ky">Кыргызча</option>
                        <option value="en">English</option>
                    </select>

                    <#if Session.SPRING_SECURITY_CONTEXT??>
                        <#assign profileUrl = "/profile">
                        <#if isAdmin>
                            <#assign profileUrl = "/admin/profile">
                        <#elseif isTeacher>
                            <#assign profileUrl = "/teacher/profile">
                        <#elseif isStudent>
                            <#assign profileUrl = "/student/profile">
                        <#elseif isOrganization>
                            <#assign profileUrl = "/organization/profile">
                        </#if>

                        <a href="${profileUrl}" class="btn btn-outline-light me-2 d-flex align-items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                                 class="me-1" viewBox="0 0 16 16">
                                <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H3zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                            </svg>
                            Профиль
                        </a>
                    </div>
                </#if>
                <div class="nav-item">
                    <a href="/courses" class="nav-link" data-tooltip="Курсы">
                        <i class="fas fa-book"></i>
                        <span>Курсы</span>
                    </a>
                </div>
            </div>

            <#if known>
                <#if isAdmin>
                    <div class="nav-section">
                        <div class="nav-section-title">Администрирование</div>
                        <div class="nav-item">
                            <a href="/admin/users" class="nav-link" data-tooltip="Пользователи">
                                <i class="fas fa-users"></i>
                                <span>Пользователи</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="/#" class="nav-link" data-tooltip="Отчеты">
                                <i class="fas fa-chart-bar"></i>
                                <span>Отчеты</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="#" class="nav-link" data-tooltip="Расписание">
                                <i class="fas fa-calendar"></i>
                                <span>Расписание</span>
                            </a>
                        </div>
                    </div>
                </#if>

                <#if isTeacher>
                    <div class="nav-section">
                        <div class="nav-section-title">Преподавание</div>
                        <div class="nav-item">
                            <a href="/#" class="nav-link" data-tooltip="Тесты">
                                <i class="fas fa-question-circle"></i>
                                <span>Тесты</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="#" class="nav-link" data-tooltip="Расписание">
                                <i class="fas fa-calendar"></i>
                                <span>Расписание</span>
                            </a>
                        </div>
                    </div>
                </#if>

                <#if isOrganization>
                    <div class="nav-section">
                        <div class="nav-section-title">Организация</div>
                        <div class="nav-item">
                            <a href="/#" class="nav-link" data-tooltip="Сотрудники">
                                <i class="fas fa-user-tie"></i>
                                <span>Сотрудники</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="/#" class="nav-link" data-tooltip="Курсы">
                                <i class="fas fa-graduation-cap"></i>
                                <span>Курсы</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="#" class="nav-link" data-tooltip="Расписание">
                                <i class="fas fa-calendar"></i>
                                <span>Расписание</span>
                            </a>
                        </div>
                    </div>
                </#if>

                <#if isStudent>
                    <div class="nav-section">
                        <div class="nav-section-title">Обучение</div>
                        <div class="nav-item">
                            <a href="/#" class="nav-link" data-tooltip="Мои курсы">
                                <i class="fas fa-book-open"></i>
                                <span>Мои курсы</span>
                            </a>
                        </div>
                        <div class="nav-item">
                            <a href="#" class="nav-link" data-tooltip="Расписание">
                                <i class="fas fa-calendar"></i>
                                <span>Расписание</span>
                            </a>
                        </div>
                    </div>
                </#if>
            </#if>
        </div>

        <div class="sidebar-profile">
            <select class="language-selector" id="languageSelector">
                <option value="ru">🇷🇺 Русский</option>
                <option value="ky">🇰🇬 Кыргызча</option>
                <option value="en">🇬🇧 English</option>
            </select>

            <#if known>
                <div class="profile-info">
                    <div class="profile-avatar">
                        ${name?substring(0, 1)?upper_case}
                    </div>
                    <div>
                        <div class="profile-name">${name}</div>
                        <div class="profile-role">
                            <#if isAdmin>Администратор</#if>
                            <#if isTeacher>Преподаватель</#if>
                            <#if isStudent>Студент</#if>
                            <#if isOrganization>Организация</#if>
                        </div>
                    </div>
                </div>

                <div class="profile-actions">
                    <#assign profileUrl = "/profile">
                    <#if isAdmin>
                        <#assign profileUrl = "/admin/profile">
                    <#elseif isTeacher>
                        <#assign profileUrl = "/teacher/profile">
                    <#elseif isStudent>
                        <#assign profileUrl = "/student/profile">
                    <#elseif isOrganization>
                        <#assign profileUrl = "/organization/profile">
                    </#if>

                    <a href="${profileUrl}" class="profile-btn">
                        <i class="fas fa-user"></i> <span>Профиль</span>
                    </a>
                    <form action="/logout" method="post" style="flex: 1;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="profile-btn" style="width: 100%; background: none; border: 1px solid rgba(255, 255, 255, 0.2);">
                            <i class="fas fa-sign-out-alt"></i> <span>Выйти</span>
                        </button>
                    </form>
                </div>
            <#else>
                <div class="profile-actions">
                    <a href="/auth/login" class="profile-btn">
                        <i class="fas fa-sign-in-alt"></i> <span>Войти</span>
                    </a>
                    <a href="/auth/register" class="profile-btn">
                        <i class="fas fa-user-plus"></i> <span>Регистрация</span>
                    </a>
                </div>
            </#if>
        </div>
    </nav>

    <div class="main-wrapper" id="mainWrapper">
        <header class="top-header">
            <button class="mobile-menu-btn" id="mobileMenuBtn">
                <i class="fas fa-bars"></i>
            </button>
            <h1 style="color: var(--primary-blue); font-size: 1.2rem; margin: 0;">
                <i class="fas fa-graduation-cap me-2"></i>
                Манас Тренинг Центр
            </h1>
        </header>

        <div class="main-content">
            <#nested>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const mainWrapper = document.getElementById('mainWrapper');

        function toggleMobileSidebar() {
            sidebar.classList.toggle('open');
            sidebarOverlay.classList.toggle('active');
        }

        function closeMobileSidebar() {
            sidebar.classList.remove('open');
            sidebarOverlay.classList.remove('active');
        }

        function toggleDesktopSidebar() {
            sidebar.classList.toggle('collapsed');
            sidebarToggle.classList.toggle('collapsed');
            mainWrapper.classList.toggle('collapsed');

            const icon = sidebarToggle.querySelector('i');
            if (sidebar.classList.contains('collapsed')) {
                icon.className = 'fas fa-chevron-right';
                localStorage.setItem('sidebarCollapsed', 'true');
            } else {
                icon.className = 'fas fa-bars';
                localStorage.setItem('sidebarCollapsed', 'false');
            }
        }

        if (mobileMenuBtn) {
            mobileMenuBtn.addEventListener('click', toggleMobileSidebar);
        }

        sidebarToggle.addEventListener('click', toggleDesktopSidebar);
        sidebarOverlay.addEventListener('click', closeMobileSidebar);

        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 768) {
                    closeMobileSidebar();
                }
            });
        });

        document.getElementById('languageSelector').addEventListener('change', function(e) {
            const selectedLang = e.target.value;
            console.log('Selected language:', selectedLang);
        });

        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-link').forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && sidebar.classList.contains('open')) {
                closeMobileSidebar();
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            if (isCollapsed && window.innerWidth > 768) {
                sidebar.classList.add('collapsed');
                sidebarToggle.classList.add('collapsed');
                mainWrapper.classList.add('collapsed');
                const icon = sidebarToggle.querySelector('i');
                icon.className = 'fas fa-chevron-right';
            }
        });

        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                sidebar.classList.remove('open');
                sidebarOverlay.classList.remove('active');
            } else {
                sidebar.classList.remove('collapsed');
                sidebarToggle.classList.remove('collapsed');
                mainWrapper.classList.remove('collapsed');
            }
        });
    </script>
    </body>
    </html>
</#macro>