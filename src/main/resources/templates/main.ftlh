<#import "layout.ftlh" as layout>

<@layout.page>
    <style>

        .hero-section-enhanced {
            background:
                    linear-gradient(135deg,
                    rgba(0, 102, 204, 0.7) 0%,
                    rgba(135, 206, 235, 0.6) 50%,
                    rgba(0, 102, 204, 0.8) 100%),
                    url('static/images/main_fon.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            border-radius: 20px;
            padding: 4rem 2rem;
            margin-bottom: 3rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-section-enhanced::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.05) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        .hero-content {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .hero-title-enhanced {
            color: white;
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            line-height: 1.2;
        }

        .hero-subtitle-enhanced {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.3rem;
            margin-bottom: 2.5rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .btn-hero {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(255, 255, 255, 0.8) 100%);
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 1rem 3rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--primary-blue);
            transition: all 0.4s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn-hero:hover::before {
            left: 100%;
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            background: rgba(255, 255, 255, 1);
            color: var(--primary-blue);
        }

        .features-section {
            margin-top: 4rem;
        }

        .section-title {
            text-align: center;
            color: var(--primary-blue);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .section-subtitle {
            text-align: center;
            color: var(--text-dark);
            font-size: 1.1rem;
            margin-bottom: 3rem;
            opacity: 0.8;
        }

        .feature-card-enhanced {
            background: var(--white);
            border-radius: 20px;
            padding: 2.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 30px rgba(0, 102, 204, 0.08);
            transition: all 0.4s ease;
            border: 1px solid rgba(0, 102, 204, 0.1);
            position: relative;
            overflow: hidden;
        }

        .feature-card-enhanced::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-blue), var(--light-blue));
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .feature-card-enhanced:hover::before {
            transform: scaleX(1);
        }

        .feature-card-enhanced:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 102, 204, 0.15);
        }

        .feature-icon-enhanced {
            background: linear-gradient(135deg, var(--primary-blue), var(--light-blue));
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 3rem;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }

        .feature-card-enhanced:hover .feature-icon-enhanced {
            transform: scale(1.1);
        }

        .feature-title {
            color: var(--primary-blue);
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .feature-description {
            color: var(--text-dark);
            line-height: 1.6;
            opacity: 0.8;
        }

        .stats-section {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border-radius: 20px;
            padding: 3rem 2rem;
            margin: 4rem 0;
            color: white;
            text-align: center;
        }

        .stat-item {
            margin-bottom: 2rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            display: block;
            color: var(--light-blue);
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .cta-section {
            background: linear-gradient(135deg,
            rgba(135, 206, 235, 0.1) 0%,
            rgba(0, 102, 204, 0.05) 100%);
            border-radius: 20px;
            padding: 3rem 2rem;
            margin: 4rem 0;
            text-align: center;
        }

        .cta-title {
            color: var(--primary-blue);
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .cta-description {
            color: var(--text-dark);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.8;
        }

        .fade-in {
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.15s ease forwards;
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .feature-card-enhanced:nth-child(1) { animation-delay: 0.1s; }
        .feature-card-enhanced:nth-child(2) { animation-delay: 0.2s; }
        .feature-card-enhanced:nth-child(3) { animation-delay: 0.3s; }
        .feature-card-enhanced:nth-child(4) { animation-delay: 0.4s; }
        .feature-card-enhanced:nth-child(5) { animation-delay: 0.5s; }
        .feature-card-enhanced:nth-child(6) { animation-delay: 0.6s; }

        @media (max-width: 768px) {
            .hero-section-enhanced {
                background-attachment: scroll;
                min-height: 60vh;
                padding: 2rem 1rem;
            }

            .hero-content {
                padding: 2rem 1.5rem;
            }

            .hero-title-enhanced {
                font-size: 2.2rem;
            }

            .hero-subtitle-enhanced {
                font-size: 1.1rem;
            }

            .feature-card-enhanced {
                padding: 2rem 1.5rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .stat-number {
                font-size: 2.5rem;
            }
        }

        .interactive-bg {
            position: relative;
            overflow: hidden;
        }

        .interactive-bg::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(135, 206, 235, 0.1);
            transform: translate(-50%, -50%);
            transition: all 0.6s ease;
        }

        .interactive-bg:hover::after {
            width: 300px;
            height: 300px;
        }

        .hero-section-enhanced.parallax {
            background-attachment: fixed;
        }

        .hero-section-enhanced.no-parallax {
            background-attachment: scroll;
        }
    </style>

    <div class="hero-section-enhanced parallax">
        <div class="hero-content">
            <h1 class="hero-title-enhanced fade-in">
                Добро пожаловать в <br>
                <span style="color: var(--light-blue);">Манас Тренинг Центр</span>
            </h1>
            <p class="hero-subtitle-enhanced fade-in">
                Профессиональная подготовка специалистов в сфере гражданской авиации
                и наземного обслуживания воздушных судов с использованием современных технологий
            </p>
            <button class="btn btn-hero fade-in">
                <i class="fas fa-rocket me-2"></i>Начать обучение
            </button>
        </div>
    </div>

    <div class="stats-section">
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number">500+</span>
                    <span class="stat-label">Выпускников</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number">25+</span>
                    <span class="stat-label">Курсов</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number">15+</span>
                    <span class="stat-label">Преподавателей</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number">98%</span>
                    <span class="stat-label">Успешность</span>
                </div>
            </div>
        </div>
    </div>

    <div class="features-section">
        <h2 class="section-title">Наши возможности</h2>
        <p class="section-subtitle">
            Современная образовательная платформа с широким спектром инструментов для эффективного обучения
        </p>

        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-laptop-code feature-icon-enhanced"></i>
                    <h4 class="feature-title">Интерактивное обучение</h4>
                    <p class="feature-description">
                        Современные мультимедийные материалы, виртуальные симуляторы
                        и интерактивные презентации для глубокого понимания материала
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-brain feature-icon-enhanced"></i>
                    <h4 class="feature-title">Адаптивное тестирование</h4>
                    <p class="feature-description">
                        Система интеллектуального тестирования с адаптацией под уровень знаний
                        и мгновенной обратной связью
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-award feature-icon-enhanced"></i>
                    <h4 class="feature-title">Цифровые сертификаты</h4>
                    <p class="feature-description">
                        Получение верифицированных цифровых сертификатов с блокчейн-защитой
                        после успешного завершения курсов
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-user-graduate feature-icon-enhanced"></i>
                    <h4 class="feature-title">Экспертное наставничество</h4>
                    <p class="feature-description">
                        Персональное сопровождение от ведущих специалистов авиационной индустрии
                        с многолетним практическим опытом
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-mobile-alt feature-icon-enhanced"></i>
                    <h4 class="feature-title">Мобильная платформа</h4>
                    <p class="feature-description">
                        Полнофункциональное мобильное приложение для обучения в любом месте
                        и в любое время с синхронизацией прогресса
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-analytics feature-icon-enhanced"></i>
                    <h4 class="feature-title">Аналитика успеваемости</h4>
                    <p class="feature-description">
                        Детальная аналитика прогресса обучения с персональными рекомендациями
                        и планами развития компетенций
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="cta-section">
        <h3 class="cta-title">Готовы начать свой путь в авиации?</h3>
        <p class="cta-description">
            Присоединяйтесь к нашему сообществу профессионалов и получите качественное образование
            в сфере гражданской авиации
        </p>
        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <button class="btn btn-primary-custom btn-lg">
                <i class="fas fa-play me-2"></i>Просмотреть курсы
            </button>
            <button class="btn btn-outline-primary btn-lg">
                <i class="fas fa-info-circle me-2"></i>Узнать больше
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.fade-in').forEach(el => {
                el.style.animationPlayState = 'paused';
                observer.observe(el);
            });

            if (window.innerWidth <= 768) {
                const heroSection = document.querySelector('.hero-section-enhanced');
                if (heroSection) {
                    heroSection.classList.remove('parallax');
                    heroSection.classList.add('no-parallax');
                }
            }
        });
    </script>
</@layout.page>