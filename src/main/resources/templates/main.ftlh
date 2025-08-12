<#import "layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<@layout.page>
    <div class="hero-section-enhanced parallax">
        <#if successMessage??>
            <div id="successMessage" data-message="${successMessage?js_string}"></div>
        </#if>
        <#if errorMessage??>
            <div id="errorMessage" data-message="${errorMessage?js_string}"></div>
        </#if>
        <div class="hero-content">
            <h1 class="hero-title-enhanced fade-in">
                ${springMacroRequestContext.getMessage('home.hero.title')} <br>
                <span style="color: var(--light-blue);">Манас Тренинг Центр</span>
            </h1>
            <p class="hero-subtitle-enhanced fade-in">
                ${springMacroRequestContext.getMessage('home.hero.subtitle')}
            </p>
            <div class="hero-buttons-group fade-in">
                <a href="https://manastraining.kg/courses" class="btn btn-hero primary">
                    <i class="fas fa-rocket me-2"></i>${springMacroRequestContext.getMessage('home.hero.button')}
                </a>
            </div>
        </div>
    </div>

    <div class="stats-section">
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number counter" data-count="500">0</span><span class="stat-number">+</span>
                    <span class="stat-label">${springMacroRequestContext.getMessage('home.stats.graduates')}</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number counter" data-count="25">0</span><span class="stat-number">+</span>
                    <span class="stat-label">${springMacroRequestContext.getMessage('home.stats.courses')}</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number counter" data-count="15">0</span><span class="stat-number">+</span>
                    <span class="stat-label">${springMacroRequestContext.getMessage('home.stats.teachers')}</span>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-item">
                    <span class="stat-number counter" data-count="98">0</span><span class="stat-number">%</span>
                    <span class="stat-label">${springMacroRequestContext.getMessage('home.stats.success')}</span>
                </div>
            </div>
        </div>
    </div>

    <div class="features-section">
        <h2 class="section-title">${springMacroRequestContext.getMessage('home.features.title')}</h2>
        <p class="section-subtitle">
            ${springMacroRequestContext.getMessage('home.features.subtitle')}
        </p>

        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-laptop-code feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.1.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.1.desc')}
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-video feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.2.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.2.desc')}
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-award feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.3.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.3.desc')}
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-user-graduate feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.4.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.4.desc')}
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-folder-open feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.5.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.5.desc')}
                    </p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6">
                <div class="feature-card-enhanced text-center fade-in interactive-bg">
                    <i class="fas fa-chart-line feature-icon-enhanced"></i>
                    <h4 class="feature-title">${springMacroRequestContext.getMessage('home.features.6.title')}</h4>
                    <p class="feature-description">
                        ${springMacroRequestContext.getMessage('home.features.6.desc')}
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="testimonials-section">
        <h2 class="section-title">${springMacroRequestContext.getMessage('home.testimonials.title')}</h2>
        <div class="testimonials-slider">
            <div class="testimonial-card active">
                <div class="testimonial-content">
                    <p>${springMacroRequestContext.getMessage('home.testimonial.1.text')}</p>
                    <div class="testimonial-author">
                        <strong>${springMacroRequestContext.getMessage('home.testimonial.1.name')}</strong>
                        <span>${springMacroRequestContext.getMessage('home.testimonial.1.role')}</span>
                    </div>
                </div>
            </div>
            <div class="testimonial-card">
                <div class="testimonial-content">
                    <p>${springMacroRequestContext.getMessage('home.testimonial.2.text')}</p>
                    <div class="testimonial-author">
                        <strong>${springMacroRequestContext.getMessage('home.testimonial.2.name')}</strong>
                        <span>${springMacroRequestContext.getMessage('home.testimonial.2.role')}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="courses-preview-section">
        <h2 class="section-title">${springMacroRequestContext.getMessage('home.courses.title')}</h2>
        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="course-card">
                    <div class="course-image">
                        <i class="fas fa-plane course-icon"></i>
                    </div>
                    <div class="course-content">
                        <h4>${springMacroRequestContext.getMessage('home.courses.1.title')}</h4>
                        <p>${springMacroRequestContext.getMessage('home.courses.1.desc')}</p>
                        <div class="course-meta">
                            <span class="duration"><i
                                        class="fas fa-clock"></i> ${springMacroRequestContext.getMessage('home.courses.1.duration')}</span>
                        </div>
                        <a href="https://manastraining.kg/courses/aircraft-maintenance"
                           class="btn btn-outline-primary btn-sm mt-2">
                            ${springMacroRequestContext.getMessage('home.courses.more')}
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="course-card">
                    <div class="course-image">
                        <i class="fas fa-broadcast-tower course-icon"></i>
                    </div>
                    <div class="course-content">
                        <h4>${springMacroRequestContext.getMessage('home.courses.2.title')}</h4>
                        <p>${springMacroRequestContext.getMessage('home.courses.2.desc')}</p>
                        <div class="course-meta">
                            <span class="duration"><i
                                        class="fas fa-clock"></i> ${springMacroRequestContext.getMessage('home.courses.2.duration')}</span>
                        </div>
                        <a href="https://manastraining.kg/courses/radio-communication"
                           class="btn btn-outline-primary btn-sm mt-2">
                            ${springMacroRequestContext.getMessage('home.courses.more')}
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="course-card">
                    <div class="course-image">
                        <i class="fas fa-shield-alt course-icon"></i>
                    </div>
                    <div class="course-content">
                        <h4>${springMacroRequestContext.getMessage('home.courses.3.title')}</h4>
                        <p>${springMacroRequestContext.getMessage('home.courses.3.desc')}</p>
                        <div class="course-meta">
                            <span class="duration"><i
                                        class="fas fa-clock"></i> ${springMacroRequestContext.getMessage('home.courses.3.duration')}</span>
                        </div>
                        <a href="https://manastraining.kg/courses/aviation-security"
                           class="btn btn-outline-primary btn-sm mt-2">
                            ${springMacroRequestContext.getMessage('home.courses.more')}
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="faq-section">
        <h2 class="section-title">${springMacroRequestContext.getMessage('home.faq.title')}</h2>
        <div class="faq-container">
            <div class="faq-item">
                <div class="faq-question">
                    <h4>${springMacroRequestContext.getMessage('home.faq.1.q')}</h4>
                    <i class="fas fa-plus"></i>
                </div>
                <div class="faq-answer">
                    <p>${springMacroRequestContext.getMessage('home.faq.1.a')}</p>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <h4>${springMacroRequestContext.getMessage('home.faq.2.q')}</h4>
                    <i class="fas fa-plus"></i>
                </div>
                <div class="faq-answer">
                    <p>${springMacroRequestContext.getMessage('home.faq.2.a')}</p>
                </div>
            </div>
        </div>
    </div>

    <div class="cta-section">
        <h3 class="cta-title">${springMacroRequestContext.getMessage('home.cta.title')}</h3>
        <p class="cta-description">
            ${springMacroRequestContext.getMessage('home.cta.desc')}
        </p>
        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="https://manastraining.kg/courses" class="btn btn-primary-custom btn-lg">
                <i class="fas fa-play me-2"></i>${springMacroRequestContext.getMessage('home.cta.button.courses')}
            </a>
        </div>
    </div>

    <div class="contact-info-bar">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                    <div class="contact-item">
                        <a href="tel:${springMacroRequestContext.getMessage('home.contact.phone')?replace(' ', '')?replace('-', '')}"
                           class="contact-link">
                            <i class="fas fa-phone contact-icon"></i>
                            <span class="contact-text">${springMacroRequestContext.getMessage('home.contact.phone')}</span>
                        </a>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                    <div class="contact-item">
                        <a href="mailto:${springMacroRequestContext.getMessage('home.contact.email')}"
                           class="contact-link">
                            <i class="fas fa-envelope contact-icon"></i>
                            <span class="contact-text">${springMacroRequestContext.getMessage('home.contact.email')}</span>
                        </a>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                    <div class="contact-item">
                        <div class="contact-link" onclick="showOnMap()" style="cursor: pointer;">
                            <i class="fas fa-map-marker-alt contact-icon"></i>
                            <span class="contact-text">${springMacroRequestContext.getMessage('home.contact.address')}</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="social-links d-flex justify-content-center justify-content-lg-end">
                        <a href="https://wa.me/996557878300" target="_blank" class="social-link whatsapp"
                           aria-label="WhatsApp">
                            <i class="fab fa-whatsapp"></i>
                        </a>
                        <a href="https://t.me/0557878300" target="_blank" class="social-link telegram"
                           aria-label="Telegram">
                            <i class="fab fa-telegram"></i>
                        </a>
                        <a href="https://instagram.com/manas.training" target="_blank" class="social-link instagram"
                           aria-label="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "EducationalOrganization",
            "name": "Манас Тренинг Центр",
            "description": "Профессиональная подготовка специалистов в сфере гражданской авиации",
            "url": "https://manastraining.kg",
            "telephone": "+996557878300",
            "email": "manas.training25@gmail.com",
            "address": {
                "@type": "PostalAddress",
                "streetAddress": "ул. Анарбека Бакаева 132Б",
                "addressLocality": "Бишкек",
                "addressCountry": "KG"
            },
            "sameAs": [
                "https://instagram.com/manas.training",
                "https://t.me/0557878300"
            ]
        }
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const observerOptions = {threshold: 0.1, rootMargin: '0px 0px -50px 0px'};
            const observer = new IntersectionObserver(function (entries) {
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

            const counters = document.querySelectorAll('.counter');
            const counterObserver = new IntersectionObserver(function (entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const counter = entry.target;
                        const target = parseInt(counter.getAttribute('data-count'));
                        let current = 0;
                        const increment = target / 50;
                        const timer = setInterval(() => {
                            current += increment;
                            if (current >= target) {
                                current = target;
                                clearInterval(timer);
                            }
                            counter.textContent = Math.floor(current);
                        }, 40);
                        counterObserver.unobserve(counter);
                    }
                });
            });
            counters.forEach(counter => {
                counterObserver.observe(counter);
            });

            document.querySelectorAll('.faq-question').forEach(q => {
                q.addEventListener('click', function () {
                    const faqItem = this.parentElement;
                    const answer = faqItem.querySelector('.faq-answer');
                    const icon = this.querySelector('i');
                    faqItem.classList.toggle('active');
                    if (faqItem.classList.contains('active')) {
                        answer.style.maxHeight = answer.scrollHeight + 'px';
                        icon.classList.remove('fa-plus');
                        icon.classList.add('fa-minus');
                    } else {
                        answer.style.maxHeight = '0';
                        icon.classList.remove('fa-minus');
                        icon.classList.add('fa-plus');
                    }
                });
            });

            let currentTestimonial = 0;
            const testimonials = document.querySelectorAll('.testimonial-card');

            function showTestimonial(i) {
                testimonials.forEach(t => t.classList.remove('active'));
                testimonials[i].classList.add('active');
            }

            setInterval(() => {
                currentTestimonial = (currentTestimonial + 1) % testimonials.length;
                showTestimonial(currentTestimonial);
            }, 5000);

            if (window.innerWidth <= 768) {
                const heroSection = document.querySelector('.hero-section-enhanced');
                if (heroSection) {
                    heroSection.classList.remove('parallax');
                    heroSection.classList.add('no-parallax');
                }
            }

            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) target.scrollIntoView({behavior: 'smooth', block: 'start'});
                });
            });
        });
    </script>

    <style>
        .hero-section-enhanced {
            background: linear-gradient(135deg,
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

        .contact-info-bar {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            color: white;
            padding: 1.5rem 0;
            margin-bottom: 2rem;
            font-size: 1rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .contact-link {
            display: flex;
            align-items: center;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            padding: 0.5rem;
            border-radius: 5px;
        }

        .contact-link:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }

        .contact-icon {
            color: var(--light-blue);
            width: 24px;
            text-align: center;
            margin-right: 0.75rem;
            font-size: 1.1rem;
        }

        .contact-text {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .contact-item i {
            color: var(--light-blue);
            width: 20px;
        }

        .social-links {
            display: flex;
            gap: 1rem;
        }

        .social-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 1.2rem;
        }

        .social-link.whatsapp {
            background: #25D366;
        }

        .social-link.telegram {
            background: #0088cc;
        }

        .social-link.instagram {
            background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%);
        }

        .social-link:hover {
            transform: translateY(-3px) scale(1.1);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        @media (max-width: 1199px) {
            .contact-text {
                font-size: 0.95rem;
            }

            .social-link {
                width: 36px;
                height: 36px;
                font-size: 1.1rem;
            }
        }

        @media (max-width: 991px) {
            .contact-info-bar {
                padding: 1.25rem 0;
            }

            .contact-item {
                justify-content: flex-start;
                margin-bottom: 0.5rem;
            }

            .social-links {
                justify-content: flex-start;
                margin-top: 0.5rem;
            }

            .contact-icon {
                margin-right: 0.5rem;
            }
        }

        @media (max-width: 767px) {
            .contact-info-bar {
                padding: 1rem 0;
            }

            .contact-item {
                justify-content: center;
            }

            .social-links {
                justify-content: center;
            }

            .contact-text {
                white-space: normal;
                text-align: center;
            }
        }

        @media (max-width: 575px) {
            .contact-icon {
                width: 20px;
                font-size: 1rem;
            }

            .contact-text {
                font-size: 0.9rem;
            }

            .social-link {
                width: 34px;
                height: 34px;
                font-size: 1rem;
            }
        }

        .hero-buttons-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-hero.secondary {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.5);
            color: white;
        }

        .btn-hero.secondary:hover {
            background: rgba(255, 255, 255, 0.9);
            color: var(--primary-blue);
        }

        .testimonials-section {
            background: linear-gradient(135deg, rgba(135, 206, 235, 0.05), rgba(0, 102, 204, 0.02));
            padding: 4rem 2rem;
            margin: 4rem 0;
            border-radius: 20px;
        }

        .testimonials-slider {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            height: 200px;
        }

        .testimonial-card {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            opacity: 0;
            transform: translateX(30px);
            transition: all 0.5s ease;
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 8px 30px rgba(0, 102, 204, 0.1);
        }

        .testimonial-card.active {
            opacity: 1;
            transform: translateX(0);
        }

        .testimonial-content p {
            font-style: italic;
            font-size: 1.1rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        .testimonial-author strong {
            color: var(--primary-blue);
            font-size: 1rem;
        }

        .testimonial-author span {
            display: block;
            color: var(--text-dark);
            opacity: 0.7;
            font-size: 0.9rem;
        }

        .courses-preview-section {
            margin: 4rem 0;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0, 102, 204, 0.08);
            transition: all 0.3s ease;
            margin-bottom: 2rem;
        }

        .course-card {
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .course-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }


        .row > [class*="col-"] {
            display: flex;
            flex-direction: column;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 102, 204, 0.15);
        }

        .course-image {
            background: linear-gradient(135deg, var(--primary-blue), var(--light-blue));
            padding: 2rem;
            text-align: center;
        }

        .course-icon {
            font-size: 3rem;
            color: white;
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-content h4 {
            color: var(--primary-blue);
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(0, 102, 204, 0.1);
        }

        .course-meta .duration {
            color: var(--text-dark);
            opacity: 0.7;
            font-size: 0.9rem;
        }

        .course-meta .price {
            color: var(--primary-blue);
            font-weight: 600;
        }

        .faq-section {
            margin: 4rem 0;
        }

        .faq-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .faq-item {
            background: white;
            border-radius: 10px;
            margin-bottom: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.05);
        }

        .faq-question {
            padding: 1.5rem;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .faq-question:hover {
            background: rgba(135, 206, 235, 0.05);
        }

        .faq-question h4 {
            margin: 0;
            color: var(--primary-blue);
            font-size: 1.1rem;
        }

        .faq-question i {
            color: var(--primary-blue);
            transition: transform 0.3s ease;
        }

        .faq-item.active .faq-question i {
            transform: rotate(45deg);
        }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }

        .faq-answer p {
            padding: 0 1.5rem 1.5rem;
            margin: 0;
            color: var(--text-dark);
            line-height: 1.6;
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
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(5deg);
            }
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
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            height: 350px;
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
            flex-shrink: 0;
        }

        .feature-card-enhanced:hover .feature-icon-enhanced {
            transform: scale(1.1);
        }

        .feature-title {
            color: var(--primary-blue);
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 1rem;
            flex-shrink: 0;
        }

        .feature-description {
            color: var(--text-dark);
            line-height: 1.6;
            opacity: 0.8;
            flex-grow: 1;
            overflow: visible;
            text-overflow: initial;
            display: block;
            -webkit-line-clamp: none;
            -webkit-box-orient: initial;
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
            display: inline;
            color: var(--light-blue);
        }

        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
            display: block;
            margin-top: 0.5rem;
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

        .feature-card-enhanced:nth-child(1) {
            animation-delay: 0.1s;
        }

        .feature-card-enhanced:nth-child(2) {
            animation-delay: 0.2s;
        }

        .feature-card-enhanced:nth-child(3) {
            animation-delay: 0.3s;
        }

        .feature-card-enhanced:nth-child(4) {
            animation-delay: 0.4s;
        }

        .feature-card-enhanced:nth-child(5) {
            animation-delay: 0.5s;
        }

        .feature-card-enhanced:nth-child(6) {
            animation-delay: 0.6s;
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

        .features-section .row {
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
        }

        .features-section .col-lg-4 {
            display: flex;
            flex-direction: column;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .contact-info-bar .col-md-6 {
                margin-bottom: 1rem;
            }

            .social-links {
                justify-content: center;
            }

            .hero-buttons-group {
                flex-direction: column;
                align-items: center;
            }

            .btn-hero {
                width: 100%;
                max-width: 300px;
            }

            .feature-card-enhanced {
                height: auto;
                min-height: 280px;
                padding: 2rem 1.5rem;
            }

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

            .section-title {
                font-size: 2rem;
            }

            .stat-number {
                font-size: 2.5rem;
            }

            .testimonials-slider {
                height: auto;
                min-height: 200px;
            }

            .course-card {
                margin-bottom: 1.5rem;
            }
        }

        @media (max-width: 991px) and (min-width: 769px) {
            .feature-card-enhanced {
                height: 380px;
            }
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
        }

        .btn-hero.loading {
            animation: pulse 1s infinite;
        }

        .scroll-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.2rem;
            opacity: 0;
            transform: translateY(100px);
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0, 102, 204, 0.3);
        }

        .scroll-to-top.visible {
            opacity: 1;
            transform: translateY(0);
        }

        .scroll-to-top:hover {
            background: var(--dark-blue);
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 102, 204, 0.4);
        }
    </style>

    <button class="scroll-to-top" id="scrollToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

    <button class="scroll-to-top" id="scrollToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

    <script>
        window.addEventListener('scroll', function () {
            const scrollToTop = document.getElementById('scrollToTop');
            if (window.pageYOffset > 300) {
                scrollToTop.classList.add('visible');
            } else {
                scrollToTop.classList.remove('visible');
            }
        });
        document.getElementById('scrollToTop').addEventListener('click', function () {
            window.scrollTo({top: 0, behavior: 'smooth'});
        });
        document.querySelectorAll('a[href^="tel:"], a[href^="mailto:"]').forEach(link => {
            link.addEventListener('click', function () {
                console.log('Contact clicked:', this.href);
            });
        });
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.classList.remove('lazy');
                        imageObserver.unobserve(img);
                    }
                });
            });
            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        }
    </script>

    <script src="/static/js/map.js"></script>
</@layout.page>