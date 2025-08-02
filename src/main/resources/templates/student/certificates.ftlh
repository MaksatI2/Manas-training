<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>
<#setting date_format="dd.MM.yyyy">

<@layout.page title="Мои сертификаты">
    <@roadmap.breadcrumbs items=[
    {"label":"Главная","url":"/"},
    {"label":"Мои сертификаты","url":""}
    ]/>

    <#if certificates?size == 0>
        <div class="empty-state">
            <div class="empty-state-content">
                <div class="empty-state-icon">
                    <i class="fas fa-certificate"></i>
                </div>
                <h3 class="empty-state-title">Пока нет сертификатов</h3>
                <p class="empty-state-text">Завершите первый курс, чтобы получить свой первый сертификат</p>
                <div class="empty-state-decoration">
                    <div class="decoration-circle circle-1"></div>
                    <div class="decoration-circle circle-2"></div>
                    <div class="decoration-circle circle-3"></div>
                </div>
            </div>
        </div>
    <#else>
        <div class="certificates-grid">
            <#list certificates as cert>
                <div class="certificate-card" data-aos="fade-up" data-aos-delay="${cert?index * 100}">
                    <div class="card-background"></div>
                    <div class="card-content">
                        <div class="certificate-badge">
                            <div class="badge-inner">
                                <i class="fas fa-award"></i>
                            </div>
                            <div class="badge-glow"></div>
                        </div>

                        <div class="certificate-info">
                            <h3 class="certificate-title">${cert.courseTitle}</h3>

                            <div class="certificate-details">
                                <#if cert.courseInstanceTitle??>
                                    <div class="detail-item">
                                        <i class="fas fa-users"></i>
                                        <span>Поток: <strong>${cert.courseInstanceTitle}</strong></span>
                                    </div>
                                </#if>

                                <#if cert.issueDate??>
                                    <div class="detail-item">
                                        <i class="fas fa-calendar-check"></i>
                                        <span>Выдан: <strong>${cert.issueDate}</strong></span>
                                    </div>
                                </#if>

                                <#if cert.expiryDate??>
                                    <div class="detail-item">
                                        <i class="fas fa-clock"></i>
                                        <span>Действителен до: <strong>${cert.expiryDate}</strong></span>
                                    </div>
                                </#if>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="certificate-actions">
                            <a href="${cert.viewUrl}" class="action-btn primary" title="Посмотреть подробнее" data-bs-toggle="tooltip">
                                <i class="fa-solid fa-circle-info"></i>
                                <span>Просмотр</span>
                            </a>
                            <button type="button" class="action-btn tertiary" title="Скопировать ссылку" data-bs-toggle="tooltip" onclick="copyLink('${cert.viewUrl}')">
                                <i class="fas fa-link"></i>
                                <span>Поделиться</span>
                            </button>
                        </div>

                    </div>
                </div>
            </#list>
        </div>
    </#if>

    <#noparse>
        <script>
            function copyLink(path) {
                const url = window.location.origin + path;
                navigator.clipboard.writeText(url)
                    .then(() => showToast("Ссылка успешно скопирована в буфер обмена", "success"))
                    .catch(() => showToast("Не удалось скопировать ссылку", "error"));
            }

            function showToast(message, type) {
                const toast = document.createElement('div');
                toast.className = `toast-notification ${type}`;
                toast.innerHTML = `
                    <div class="toast-content">
                        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                        <span>${message}</span>
                    </div>
                    <button class="toast-close" onclick="this.parentElement.remove()">
                        <i class="fas fa-times"></i>
                    </button>
                `;

                document.body.appendChild(toast);

                setTimeout(() => toast.classList.add('show'), 100);
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => toast.remove(), 300);
                }, 4000);
            }

            document.addEventListener('DOMContentLoaded', function() {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });

                const observerOptions = {
                    threshold: 0.1,
                    rootMargin: '0px 0px -50px 0px'
                };

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('animate-in');
                        }
                    });
                }, observerOptions);

                document.querySelectorAll('.certificate-card').forEach(card => {
                    observer.observe(card);
                });
            });
        </script>
    </#noparse>

    <style>
        :root {
            --primary-color: #667eea;
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-color: #f093fb;
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-color: #4CAF50;
            --warning-color: #FF9800;
            --danger-color: #f44336;
            --text-primary: #2d3748;
            --text-secondary: #718096;
            --bg-primary: #ffffff;
            --bg-secondary: #f7fafc;
            --border-color: #e2e8f0;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 30px rgba(0,0,0,0.15);
            --border-radius: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes float {
            0%, 100% { transform: translateX(0%); }
            50% { transform: translateX(100%); }
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            position: relative;
        }

        .empty-state-content {
            max-width: 400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .empty-state-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: var(--primary-gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            box-shadow: var(--shadow-lg);
            animation: pulse 2s ease-in-out infinite;
        }

        .empty-state-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .empty-state-text {
            color: var(--text-secondary);
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .empty-state-decoration {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            pointer-events: none;
        }

        .decoration-circle {
            position: absolute;
            border-radius: 50%;
            background: var(--primary-gradient);
            opacity: 0.1;
            animation: float-random 15s ease-in-out infinite;
        }

        .circle-1 {
            width: 60px;
            height: 60px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .circle-2 {
            width: 40px;
            height: 40px;
            top: 60%;
            right: 15%;
            animation-delay: -5s;
        }

        .circle-3 {
            width: 80px;
            height: 80px;
            bottom: 20%;
            left: 20%;
            animation-delay: -10s;
        }

        @keyframes float-random {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }

        .certificates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .certificate-card {
            background: var(--bg-primary);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: var(--transition);
            position: relative;
            opacity: 0;
            transform: translateY(30px);
        }

        .certificate-card.animate-in {
            opacity: 1;
            transform: translateY(0);
        }

        .certificate-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .card-background {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
        }

        .card-content {
            padding: 2rem;
            position: relative;
        }

        .certificate-badge {
            position: absolute;
            top: -20px;
            right: 2rem;
            width: 60px;
            height: 60px;
        }

        .badge-inner {
            width: 60px;
            height: 60px;
            background: var(--success-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            box-shadow: var(--shadow-md);
            position: relative;
            z-index: 2;
        }

        .badge-glow {
            position: absolute;
            top: -5px;
            left: -5px;
            right: -5px;
            bottom: -5px;
            background: var(--success-color);
            border-radius: 50%;
            opacity: 0.3;
            animation: pulse 2s ease-in-out infinite;
        }

        .certificate-info {
            margin-right: 80px;
            margin-bottom: 2rem;
        }

        .certificate-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
            line-height: 1.3;
        }

        .certificate-details {
            space-y: 0.75rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
            position: relative;
        }

        .detail-item i {
            width: 16px;
            color: var(--primary-color);
            flex-shrink: 0;
        }

        .detail-item.warning {
            color: var(--warning-color);
        }

        .detail-item.expired {
            color: var(--danger-color);
        }

        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: auto;
        }

        .status-badge.warning {
            background: rgba(255, 152, 0, 0.1);
            color: var(--warning-color);
        }

        .status-badge.expired {
            background: rgba(244, 67, 54, 0.1);
            color: var(--danger-color);
        }

        /* Actions */
        .certificate-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .action-btn {
            flex: 1;
            min-width: 100px;
            padding: 0.75rem 1rem;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: var(--transition);
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .action-btn:hover::before {
            left: 100%;
        }

        .action-btn.primary {
            background: var(--primary-gradient);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .action-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .action-btn.secondary {
            background: var(--secondary-gradient);
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .action-btn.secondary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        .action-btn.tertiary {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .action-btn.tertiary:hover {
            background: var(--text-primary);
            color: white;
            transform: translateY(-2px);
        }

        .progress-ring {
            position: absolute;
            bottom: 2rem;
            right: 2rem;
            width: 60px;
            height: 60px;
        }

        .progress-ring svg {
            transform: rotate(-90deg);
        }

        .progress-circle {
            stroke-linecap: round;
            animation: draw-circle 2s ease-out forwards;
        }

        @keyframes draw-circle {
            from { stroke-dashoffset: 157; }
            to { stroke-dashoffset: 0; }
        }

        .progress-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .toast-notification {
            position: fixed;
            top: 2rem;
            right: 2rem;
            background: white;
            border-radius: var(--border-radius);
            padding: 1rem 1.5rem;
            box-shadow: var(--shadow-lg);
            border-left: 4px solid var(--success-color);
            display: flex;
            align-items: center;
            gap: 1rem;
            z-index: 9999;
            opacity: 0;
            transform: translateX(100%);
            transition: var(--transition);
            min-width: 300px;
        }

        .toast-notification.error {
            border-left-color: var(--danger-color);
        }

        .toast-notification.show {
            opacity: 1;
            transform: translateX(0);
        }

        .toast-content {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex: 1;
        }

        .toast-content i {
            font-size: 1.2rem;
            color: var(--success-color);
        }

        .toast-notification.error .toast-content i {
            color: var(--danger-color);
        }

        .toast-close {
            background: none;
            border: none;
            font-size: 1rem;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 0.25rem;
            border-radius: 4px;
            transition: var(--transition);
        }

        .toast-close:hover {
            background: var(--bg-secondary);
            color: var(--text-primary);
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.05); }
        }

        @media (max-width: 768px) {
            .certificates-header {
                padding: 1.5rem;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .stats-card {
                margin-top: 1rem;
            }

            .certificates-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .certificate-card {
                margin: 0 1rem;
            }

            .certificate-actions {
                flex-direction: column;
            }

            .action-btn {
                min-width: auto;
            }

            .toast-notification {
                right: 1rem;
                left: 1rem;
                min-width: auto;
            }
        }

        @media (max-width: 480px) {
            .certificate-info {
                margin-right: 20px;
            }

            .certificate-badge {
                right: 1rem;
                width: 50px;
                height: 50px;
            }

            .badge-inner {
                width: 50px;
                height: 50px;
                font-size: 1.2rem;
            }

            .progress-ring {
                display: none;
            }
        }
    </style>
</@layout.page>