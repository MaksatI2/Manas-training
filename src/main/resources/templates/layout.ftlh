<#macro page>
    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Манас Тренинг Центр</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #0066cc;
                --light-blue: #87ceeb;
                --white: #ffffff;
                --dark-blue: #003d7a;
                --text-dark: #2c3e50;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
            }

            .navbar-custom {
                background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
                box-shadow: 0 2px 10px rgba(0,102,204,0.3);
                padding: 0.8rem 0;
            }

            .navbar-brand {
                color: var(--white) !important;
                font-weight: bold;
                font-size: 1.5rem;
            }

            .navbar-brand:hover {
                color: var(--light-blue) !important;
            }

            .navbar-nav .nav-link {
                color: var(--white) !important;
                font-weight: 500;
                margin: 0 0.5rem;
                transition: all 0.3s ease;
            }

            .navbar-nav .nav-link:hover {
                color: var(--light-blue) !important;
                transform: translateY(-1px);
            }

            .btn-outline-light {
                border-color: var(--light-blue);
                color: var(--light-blue);
            }

            .btn-outline-light:hover {
                background-color: var(--light-blue);
                border-color: var(--light-blue);
                color: var(--dark-blue);
            }

            .main-content {
                min-height: calc(100vh - 200px);
                padding: 2rem 0;
            }

            .hero-section {
                background: linear-gradient(135deg, rgba(0,102,204,0.1), rgba(135,206,235,0.1));
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

            .feature-card {
                background: var(--white);
                border-radius: 10px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 15px rgba(0,102,204,0.1);
                transition: transform 0.3s ease;
                border-left: 4px solid var(--primary-blue);
            }

            .feature-card:hover {
                transform: translateY(-5px);
            }

            .feature-icon {
                color: var(--primary-blue);
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
                border: none;
                padding: 0.8rem 2rem;
                border-radius: 25px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,102,204,0.3);
            }

            .footer-custom {
                background: linear-gradient(135deg, var(--dark-blue), var(--primary-blue));
                color: var(--white);
                padding: 3rem 0 1rem 0;
                margin-top: 4rem;
            }

            .footer-title {
                color: var(--light-blue);
                font-size: 1.3rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }

            .footer-link {
                color: var(--white);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-link:hover {
                color: var(--light-blue);
            }

            .footer-bottom {
                border-top: 1px solid rgba(135,206,235,0.3);
                margin-top: 2rem;
                padding-top: 1rem;
                text-align: center;
            }

            .language-selector {
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.3);
                color: var(--white);
                border-radius: 20px;
                padding: 0.3rem 1rem;
            }

            .language-selector:focus {
                background: rgba(255,255,255,0.2);
                color: var(--white);
                border-color: var(--light-blue);
            }

            @media (max-width: 768px) {
                .hero-title {
                    font-size: 2rem;
                }

                .hero-section {
                    padding: 2rem 1rem;
                }

                .feature-card {
                    padding: 1.5rem;
                }
            }
        </style>
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-graduation-cap me-2"></i>
                Манас Тренинг Центр
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-home me-1"></i>Главная</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-book me-1"></i>Курсы</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-calendar me-1"></i>Расписание</a>
                    </li>
                </ul>

                <div class="d-flex align-items-center">
                    <select class="form-select language-selector me-3" style="width: auto;">
                        <option value="ru">Русский</option>
                        <option value="ky">Кыргызча</option>
                        <option value="en">English</option>
                    </select>

                    <a href="#" class="btn btn-outline-light me-2">Войти</a>
                    <a href="#" class="btn btn-light">Регистрация</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <div class="container">
            <#nested>
        </div>
    </div>

    <footer class="footer-custom">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <h5 class="footer-title">
                        <i class="fas fa-graduation-cap me-2"></i>
                        Манас Тренинг Центр
                    </h5>
                    <p>Профессиональное учебное заведение для подготовки высококвалифицированных специалистов в сфере гражданской авиации.</p>
                    <div class="mt-3">
                        <a href="#" class="footer-link me-3"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="footer-link"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 mb-4">
                    <h6 class="footer-title">Обучение</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="footer-link">Курсы</a></li>
                        <li><a href="#" class="footer-link">Расписание</a></li>
                        <li><a href="#" class="footer-link">Тестирование</a></li>
                        <li><a href="#" class="footer-link">Сертификаты</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-6 mb-4">
                    <h6 class="footer-title">Информация</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="footer-link">О нас</a></li>
                        <li><a href="#" class="footer-link">Преподаватели</a></li>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <h6 class="footer-title">Контакты</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="fas fa-map-marker-alt me-2"></i>
                            г. Бишкек, Кыргызская Республика
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-phone me-2"></i>
                            +996 (XXX) XXX-XXX
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-envelope me-2"></i>
                            info@manastraining.kg
                        </li>
                        <li>
                            <i class="fas fa-clock me-2"></i>
                            Пн-Пт: 9:00 - 18:00
                        </li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 Манас Тренинг Центр. Все права защищены.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
</#macro>