<#import "../layout.ftlh" as layout>
<@layout.page>
    <style>
        :root {
            --primary-blue: #0066cc;
            --light-blue: #87ceeb;
            --white: #ffffff;
            --dark-blue: #003d7a;
            --text-dark: #2c3e50;
            --gray-light: #f8f9fa;
            --gray-medium: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--text-dark);
            background-color: var(--gray-light);
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,102,204,0.3);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            color: var(--white);
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-links a {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            transition: transform 0.3s ease;
        }

        .nav-links a:hover {
            transform: translateY(-1px);
        }

        .breadcrumb {
            background: var(--white);
            padding: 1rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .breadcrumb .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .breadcrumb-nav {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        .breadcrumb-nav a {
            color: var(--primary-blue);
            text-decoration: none;
        }

        .breadcrumb-nav span {
            color: var(--gray-medium);
        }

        .lesson-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
        }

        .sidebar {
            background: var(--white);
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .course-info {
            text-align: center;
            margin-bottom: 2rem;
        }

        .course-title {
            font-size: 1.2rem;
            color: var(--primary-blue);
            margin-bottom: 0.5rem;
        }

        .course-code {
            background: var(--light-blue);
            color: var(--white);
            padding: 0.2rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .progress-section {
            margin-bottom: 2rem;
        }

        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            width: 42%;
            transition: width 0.3s ease;
        }

        .progress-text {
            font-size: 0.9rem;
            color: var(--gray-medium);
            text-align: center;
        }

        .module-nav {
            list-style: none;
        }

        .module-item {
            margin-bottom: 1rem;
        }

        .module-title {
            background: var(--primary-blue);
            color: var(--white);
            padding: 0.8rem;
            border-radius: 10px;
            font-weight: 500;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .module-title:hover {
            background: var(--dark-blue);
        }

        .lessons-list {
            list-style: none;
            padding-left: 1rem;
        }

        .lesson-link {
            display: block;
            padding: 0.5rem 1rem;
            color: var(--text-dark);
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .lesson-link:hover {
            background: var(--gray-light);
            border-left-color: var(--primary-blue);
        }

        .lesson-link.active {
            background: var(--light-blue);
            color: var(--white);
            border-left-color: var(--primary-blue);
        }

        .lesson-status {
            float: right;
            margin-left: 0.5rem;
        }

        .lesson-content {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
            overflow: hidden;
        }

        .lesson-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            padding: 2rem;
        }

        .lesson-meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .lesson-meta span {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .lesson-title-main {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-description {
            font-size: 1.1rem;
            opacity: 0.9;
            line-height: 1.6;
        }

        .lesson-body {
            padding: 2rem;
        }

        .teacher-info {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary-blue);
        }

        .teacher-card {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .teacher-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.5rem;
        }

        .teacher-details h4 {
            color: var(--primary-blue);
            margin-bottom: 0.2rem;
        }

        .teacher-details p {
            color: var(--gray-medium);
            font-size: 0.9rem;
        }

        .lesson-materials {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.3rem;
            color: var(--primary-blue);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .materials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .material-card {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 1rem;
            border-left: 4px solid var(--primary-blue);
            transition: all 0.3s ease;
        }

        .material-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.1);
        }

        .material-title {
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .download-btn {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .test-section {
            background: var(--gray-light);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 4px solid var(--success-color);
        }

        .test-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .test-info {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .test-info span {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .start-test-btn {
            background: linear-gradient(135deg, var(--success-color), #218838);
            color: var(--white);
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .start-test-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40,167,69,0.3);
        }

        .lesson-navigation {
            background: var(--gray-light);
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #e9ecef;
        }

        .nav-btn {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .nav-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .nav-btn:disabled {
            background: var(--gray-medium);
            cursor: not-allowed;
            transform: none;
        }

        @media (max-width: 768px) {
            .lesson-container {
                grid-template-columns: 1fr;
                margin: 1rem auto;
                padding: 0 1rem;
            }

            .sidebar {
                position: static;
                margin-bottom: 1rem;
            }

            .lesson-title-main {
                font-size: 1.5rem;
            }

            .lesson-header {
                padding: 1.5rem;
            }

            .lesson-body {
                padding: 1.5rem;
            }

            .lesson-meta {
                flex-direction: column;
                gap: 0.5rem;
            }

            .materials-grid {
                grid-template-columns: 1fr;
            }

            .lesson-navigation {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-links {
                display: none;
            }
        }

        .completed {
            color: var(--success-color);
        }

        .in-progress {
            color: var(--warning-color);
        }

        .locked {
            color: var(--gray-medium);
            opacity: 0.6;
        }

        .notification {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
    </style>
    <div class="lesson-container">
        <aside class="sidebar">
            <div class="course-info">
                <h3 class="course-title">Полный курс веб-разработки</h3>
                <span class="course-code">С-001</span>
                <p><i class="fas fa-clock"></i> 120 часов</p>
            </div>

            <div class="progress-section">
                <h4><i class="fas fa-chart-line"></i> Прогресс курса</h4>
                <div class="progress-bar">
                    <div class="progress-fill"></div>
                </div>
                <p class="progress-text">42% завершено (3 из 7 уроков)</p>
            </div>

            <nav class="module-nav">
                <ul>
                    <li class="module-item">
                        <div class="module-title">
                            <i class="fas fa-code"></i> Модуль 1: Основы HTML
                        </div>
                        <ul class="lessons-list">
                            <li>
                                <a href="#" class="lesson-link">
                                    Урок 1: Введение в HTML
                                    <span class="lesson-status completed"><i class="fas fa-check-circle"></i></span>
                                </a>
                            </li>
                            <li>
                                <a href="#" class="lesson-link">
                                    Урок 2: Базовые теги
                                    <span class="lesson-status completed"><i class="fas fa-check-circle"></i></span>
                                </a>
                            </li>
                            <li>
                                <a href="#" class="lesson-link active">
                                    Урок 3: HTML структура
                                    <span class="lesson-status in-progress"><i class="fas fa-play-circle"></i></span>
                                </a>
                            </li>
                            <li>
                                <a href="#" class="lesson-link">
                                    Урок 4: Формы и таблицы
                                    <span class="lesson-status"><i class="fas fa-lock"></i></span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="module-item">
                        <div class="module-title">
                            <i class="fas fa-paint-brush"></i> Модуль 2: CSS стилизация
                        </div>
                        <ul class="lessons-list">
                            <li>
                                <a href="#" class="lesson-link locked">
                                    Урок 5: Введение в CSS
                                    <span class="lesson-status"><i class="fas fa-lock"></i></span>
                                </a>
                            </li>
                            <li>
                                <a href="#" class="lesson-link locked">
                                    Урок 6: Селекторы и свойства
                                    <span class="lesson-status"><i class="fas fa-lock"></i></span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="module-item">
                        <div class="module-title">
                            <i class="fas fa-cogs"></i> Модуль 3: JavaScript основы
                        </div>
                        <ul class="lessons-list">
                            <li>
                                <a href="#" class="lesson-link locked">
                                    Урок 7: Переменные и типы данных
                                    <span class="lesson-status"><i class="fas fa-lock"></i></span>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </aside>

        <main class="lesson-content">
            <header class="lesson-header">
                <div class="lesson-meta">
                    <span><i class="fas fa-clock"></i> 45 минут</span>
                    <span><i class="fas fa-layer-group"></i> Модуль 1</span>
                    <span><i class="fas fa-calendar"></i> Урок 3 из 20</span>
                </div>
                <h1 class="lesson-title-main">HTML структура: создание правильной разметки</h1>
                <p class="lesson-description">
                    В этом уроке мы изучим семантическую структуру HTML документа, научимся использовать элементы header, nav, main, section, article и footer. Также рассмотрим принципы создания доступной и SEO-оптимизированной разметки.
                </p>
            </header>

            <div class="lesson-body">
                <div class="teacher-info">
                    <div class="teacher-card">
                        <div class="teacher-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="teacher-details">
                            <h4>Алексей Петров</h4>
                            <p>Senior Frontend Developer, 8 лет опыта</p>
                            <p><i class="fas fa-envelope"></i> alexey.petrov@manas.edu.kg</p>
                        </div>
                    </div>
                </div>

                <div class="notification">
                    <i class="fas fa-info-circle"></i>
                    <strong>Важно:</strong> Для выполнения практических заданий убедитесь, что у вас установлен текстовый редактор (VS Code рекомендуется).
                </div>

                <section class="lesson-materials">
                    <h2 class="section-title">
                        <i class="fas fa-download"></i>
                        Материалы урока
                    </h2>
                    <div class="materials-grid">
                        <div class="material-card">
                            <div class="material-title">
                                <i class="fas fa-file-pdf"></i>
                                Презентация урока
                            </div>
                            <p>Теоретический материал по HTML структуре</p>
                            <a href="#" class="download-btn">
                                <i class="fas fa-download"></i>
                                Скачать PDF
                            </a>
                        </div>
                        <div class="material-card">
                            <div class="material-title">
                                <i class="fas fa-code"></i>
                                Примеры кода
                            </div>
                            <p>HTML шаблоны и примеры разметки</p>
                            <a href="#" class="download-btn">
                                <i class="fas fa-download"></i>
                                Скачать ZIP
                            </a>
                        </div>
                        <div class="material-card">
                            <div class="material-title">
                                <i class="fas fa-tasks"></i>
                                Практические задания
                            </div>
                            <p>Упражнения для закрепления материала</p>
                            <a href="#" class="download-btn">
                                <i class="fas fa-download"></i>
                                Скачать DOC
                            </a>
                        </div>
                        <div class="material-card">
                            <div class="material-title">
                                <i class="fas fa-external-link-alt"></i>
                                Дополнительные ресурсы
                            </div>
                            <p>Полезные ссылки и онлайн-инструменты</p>
                            <a href="#" class="download-btn">
                                <i class="fas fa-eye"></i>
                                Посмотреть
                            </a>
                        </div>
                    </div>
                </section>
                <section class="test-section">
                    <div class="test-header">
                        <h2 class="section-title" style="margin: 0;">
                            <i class="fas fa-clipboard-check"></i>
                            Тест по уроку
                        </h2>
                        <button class="start-test-btn">
                            <i class="fas fa-play"></i>
                            Пройти тест
                        </button>
                    </div>
                    <div class="test-info">
                        <span><i class="fas fa-question-circle"></i> 15 вопросов</span>
                        <span><i class="fas fa-clock"></i> 15 минут</span>
                        <span><i class="fas fa-chart-line"></i> Проходной балл: 70%</span>
                    </div>
                    <p><strong>Описание:</strong> Тест проверяет понимание основ HTML структуры, семантических элементов и принципов создания доступной разметки.</p>
                </section>
            </div>

            <footer class="lesson-navigation">
                <a href="#" class="nav-btn">
                    <i class="fas fa-chevron-left"></i>
                    Предыдущий урок
                </a>
                <div style="display: flex; gap: 1rem;">
                    <a href="#" class="nav-btn">
                        Следующий урок
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </div>
            </footer>
        </main>
    </div>

    <script>
        document.querySelectorAll('.module-title').forEach(title => {
            title.addEventListener('click', () => {
                const lessonsList = title.nextElementSibling;
                if (lessonsList.style.display === 'none') {
                    lessonsList.style.display = 'block';
                } else {
                    lessonsList.style.display = 'none';
                }
            });
        });
    </script>
</@layout.page>