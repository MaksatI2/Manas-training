<#macro page>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Манас Тренинг Центр</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.5.0/css/flag-icon.min.css" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
</head>
<div id="flash-message-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>
<script src="/static/js/notifications.js"></script>
<body>
<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getFullName()>
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
            <span>Манас Тренинг Центр</span>
        </a>
    </div>

        <div class="sidebar-content">
            <div class="sidebar-nav">
                <div class="nav-item">
                    <a href="/" class="nav-link" data-tooltip="Главная">
                        <i class="fas fa-home"></i>
                        <span>Главная</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="/courses" class="nav-link" data-tooltip="Курсы">
                        <i class="fas fa-book"></i>
                        <span>Курсы</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="/teacher" class="nav-link" data-tooltip="Преподаватели">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Преподаватели</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="/schedules" class="nav-link" data-tooltip="Расписание">
                        <i class="fas fa-calendar"></i>
                        <span>Расписание</span>
                    </a>
                </div>
                <#if isAdmin?? && isAdmin>
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
                        <a href="/admin/courses

" class="nav-link" data-tooltip="Управление курсами">
                            <i class="fas fa-book-open"></i>
                            <span>Управление курсами</span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/categories" class="nav-link" data-tooltip="Категории курсов">
                            <i class="fas fa-tags"></i>
                            <span>Категории курсов</span>
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="/admin/course-instances" class="nav-link" data-tooltip="Потоки курсов">
                            <i class="fas fa-chart-bar"></i>
                            <span>Потоки курсов</span>
                        </a>
                    </div>
                </#if>
                <#if isTeacher?? && isTeacher>
                    <div class="nav-item">
                        <a href="/#" class="nav-link" data-tooltip="Тесты">
                            <i class="fas fa-question-circle"></i>
                            <span>Тесты</span>
                        </a>
                    </div>
                </#if>
                <#if isOrganization?? && isOrganization>
                    <div class="nav-item">
                        <a href="/organization/students" class="nav-link" data-tooltip="Сотрудники">
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
                </#if>
                <#if isStudent?? && isStudent>
                    <div class="nav-item">
                        <a href="/student/my-courses" class="nav-link" data-tooltip="Мои курсы">
                            <i class="fas fa-book-open"></i>
                            <span>Мои курсы</span>
                        </a>
                    </div>
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
                        <form action="/logout" method="post" style="width: 100%;">
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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="../static/bootstrap/js/bootstrap.bundle.min.js"></script>
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
        box-shadow: var(--shadow);
        display: flex;
        flex-direction: column;
        overflow-x: hidden;
    }

    .sidebar.collapsed {
        width: var(--sidebar-collapsed-width);
        overflow-x: hidden;
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
        left: var(--sidebar-collapsed-width);
    }

    .sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.1);
        flex-shrink: 0;
    }

    .sidebar-brand {
        color: var(--white);
        font-size: 1.0rem;
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

    .sidebar-content {
        flex: 1;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        min-height: 0;
        overflow-x: hidden;
    }

    .sidebar-nav {
        flex: 1;
        padding: 1rem 0;
        overflow-y: auto;
        overflow-x: hidden;
        min-height: 0;
    }

    .sidebar-nav {
        flex: 1;
        padding: 1rem 0;
        overflow-y: auto;
        overflow-x: hidden;
        min-height: 0;
    }

    .nav-item {
        margin-bottom: 0.5rem;
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
        width: 100%;
        box-sizing: border-box;
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
        flex-shrink: 0;
        padding: 1.5rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.1);
        max-height: 250px;
        overflow-y: auto;
        overflow-x: hidden;
        transition: all 0.3s ease;
    }

    .sidebar.collapsed .sidebar-profile {
        padding: 1rem 0.5rem;
        text-align: center;
        max-height: 200px;
        width: var(--sidebar-collapsed-width);
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
        flex-shrink: 0;
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
        flex-direction: column;
        gap: 8px;
        transition: all 0.3s ease;
    }

    .sidebar.collapsed .profile-actions {
        align-items: center;
    }

    .profile-btn {
        padding: 0.5rem 1rem;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 8px;
        color: var(--white);
        text-decoration: none;
        text-align: center;
        font-size: 0.85rem;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        width: 100%;
        box-sizing: border-box;
    }

    .sidebar.collapsed .profile-btn {
        width: 40px;
        height: 40px;
        padding: 0;
        border-radius: 50%;
        margin-bottom: 8px;
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
        display: none;
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

    .sidebar-content::-webkit-scrollbar,
    .sidebar-nav::-webkit-scrollbar,
    .sidebar-profile::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar-content::-webkit-scrollbar-track,
    .sidebar-nav::-webkit-scrollbar-track,
    .sidebar-profile::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.1);
    }

    .sidebar-content::-webkit-scrollbar-thumb,
    .sidebar-nav::-webkit-scrollbar-thumb,
    .sidebar-profile::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.3);
        border-radius: 3px;
    }

    .sidebar-content::-webkit-scrollbar-thumb:hover,
    .sidebar-nav::-webkit-scrollbar-thumb:hover,
    .sidebar-profile::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.5);
    }

    @media (max-width: 768px) {
        .sidebar-toggle {
            display: none;
        }

        .sidebar {
            transform: translateX(-100%);
            width: 100%;
            max-width: var(--sidebar-width);
            overflow-x: hidden;
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

        .sidebar-profile {
            max-height: none;
            overflow-x: hidden;
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
</style>
</body>
</html>
</#macro>