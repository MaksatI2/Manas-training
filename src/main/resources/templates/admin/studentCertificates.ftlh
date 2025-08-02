<#import "../layout.ftlh" as layout>
<#import "../RoadMap.ftlh" as roadmap>

<@layout.page title="Сертификаты ${data.student.name} ${data.student.lastName}">
    <@roadmap.breadcrumbs items=[
    {"label":"Главная","url":"/"},
    {"label":"Сертификаты","url":"/admin/certificate"},
    {"label": data.student.name + " " + data.student.lastName,"url":""}
    ]/>
    <div class="student-header mb-4">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="student-info">
                    <div class="student-avatar">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="student-details">
                        <h2 class="student-name">${data.student.name} ${data.student.lastName}</h2>
                        <p class="student-email">${data.student.email!""}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <#if data.statusList?size == 0>
        <div class="empty-state-card">
            <div class="empty-content">
                <div class="empty-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h4 class="empty-title">Нет завершенных курсов</h4>
                <p class="empty-text">Этот студент ещё не завершил ни одного курса</p>
            </div>
        </div>
    <#else>
        <div class="certificates-grid">
            <#list data.statusList as stat>
                <div class="certificate-card">


                    <div class="card-body">
                        <h3 class="course-title">${stat.courseTitle}</h3>

                        <div class="course-meta">
                            <#if stat.courseInstanceTitle??>
                                <div class="meta-item">
                                    <i class="fas fa-users"></i>
                                    <span class="meta-label">Поток:</span>
                                    <span class="meta-value">${stat.courseInstanceTitle}</span>
                                </div>
                            </#if>
                        </div>

                        <#if stat.certificateCreated>
                            <div class="certificate-details">
                                <div class="details-header">
                                    <i class="fas fa-certificate"></i>
                                    <span>Детали сертификата</span>
                                </div>
                                <div class="details-grid">
                                    <#if stat.certificateNumber??>
                                        <div class="detail-item">
                                            <span class="detail-label">Номер:</span>
                                            <span class="detail-value cert-number">#${stat.certificateNumber}</span>
                                        </div>
                                    </#if>
                                    <#if stat.certificateIssueDate??>
                                        <div class="detail-item">
                                            <span class="detail-label">Выдан:</span>
                                            <span class="detail-value">${stat.certificateIssueDate}</span>
                                        </div>
                                    </#if>
                                    <#if stat.certificateExpiryDate??>
                                        <div class="detail-item">
                                            <span class="detail-label">Действителен до:</span>
                                            <span class="detail-value">${stat.certificateExpiryDate}</span>
                                        </div>
                                    </#if>
                                </div>
                            </div>
                        </#if>
                    </div>

                    <div class="card-actions">
                        <#if stat.certificateCreated>
                            <#list stat.certificateId as cid>
                                <button class="action-button btn-primary"
                                        onclick="window.location.href='/admin/certificate/view/${cid}'"
                                        title="Подробный просмотр">
                                    <i class="fas fa-eye"></i>
                                    <span>Просмотр</span>
                                </button>
                                <button class="action-button btn-secondary"
                                        onclick="window.location.href='/admin/certificate/edit/${cid}'"
                                        title="Редактировать">
                                    <i class="fas fa-edit"></i>
                                    <span>Изменить</span>
                                </button>
                            </#list>
                        <#else>
                            <button class="action-button btn-create"
                                    onclick="window.location.href='/admin/certificate/create?studentId=${data.student.id}&courseInstanceId=${stat.courseInstanceId}'"
                                    title="Создать сертификат">
                                <i class="fas fa-plus-circle"></i>
                                <span>Создать сертификат</span>
                            </button>
                        </#if>
                    </div>
                </div>
            </#list>
        </div>
    </#if>

    <style>
        :root {
            --admin-primary: #2c3e50;
            --admin-secondary: #34495e;
            --admin-accent: #3498db;
            --admin-success: #27ae60;
            --admin-warning: #f39c12;
            --admin-danger: #e74c3c;
            --admin-light: #ecf0f1;
            --admin-border: #d5dbdb;
            --admin-text: #2c3e50;
            --admin-text-light: #7f8c8d;
            --admin-bg: #ffffff;
            --admin-bg-light: #f8f9fa;
            --admin-shadow: 0 2px 8px rgba(44, 62, 80, 0.08);
            --admin-shadow-hover: 0 4px 16px rgba(44, 62, 80, 0.12);
            --admin-radius: 12px;
            --admin-transition: all 0.3s ease;
        }

        .student-header {
            background: var(--admin-bg);
            border: 1px solid var(--admin-border);
            border-radius: var(--admin-radius);
            padding: 2rem;
            box-shadow: var(--admin-shadow);
            margin-bottom: 2rem;
        }

        .student-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .student-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--admin-accent), var(--admin-primary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .student-name {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--admin-text);
            margin: 0 0 0.25rem 0;
        }

        .student-email {
            color: var(--admin-text-light);
            margin: 0;
            font-size: 0.95rem;
        }

        .empty-state-card {
            background: var(--admin-bg);
            border: 1px solid var(--admin-border);
            border-radius: var(--admin-radius);
            padding: 3rem;
            text-align: center;
            box-shadow: var(--admin-shadow);
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: var(--admin-bg-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            color: var(--admin-text-light);
        }

        .empty-title {
            color: var(--admin-text);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .empty-text {
            color: var(--admin-text-light);
        }

        .certificates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 1.5rem;
        }

        .certificate-card {
            background: var(--admin-bg);
            border: 1px solid var(--admin-border);
            border-radius: var(--admin-radius);
            box-shadow: var(--admin-shadow);
            transition: var(--admin-transition);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .certificate-card:hover {
            box-shadow: var(--admin-shadow-hover);
            transform: translateY(-2px);
        }

        .card-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--admin-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--admin-bg-light);
        }

        .course-badge {
            width: 40px;
            height: 40px;
            background: var(--admin-accent);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .status-dot.status-success {
            background: var(--admin-success);
        }

        .status-dot.status-warning {
            background: var(--admin-warning);
        }

        .status-text {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--admin-text-light);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-body {
            padding: 1.5rem;
            flex: 1;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--admin-text);
            margin-bottom: 1rem;
            line-height: 1.3;
        }

        .course-meta {
            margin-bottom: 1.5rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .meta-item i {
            color: var(--admin-accent);
            width: 16px;
        }

        .meta-label {
            color: var(--admin-text-light);
            font-size: 0.9rem;
        }

        .meta-value {
            color: var(--admin-text);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .certificate-details {
            background: var(--admin-bg-light);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .details-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--admin-text);
        }

        .details-header i {
            color: var(--admin-accent);
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.5rem;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.25rem 0;
        }

        .detail-label {
            font-size: 0.8rem;
            color: var(--admin-text-light);
            font-weight: 500;
        }

        .detail-value {
            font-size: 0.8rem;
            color: var(--admin-text);
            font-weight: 600;
        }

        .cert-number {
            font-family: 'Courier New', monospace;
            background: var(--admin-bg);
            padding: 0.2rem 0.4rem;
            border-radius: 4px;
            border: 1px solid var(--admin-border);
        }

        .card-actions {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--admin-border);
            background: var(--admin-bg);
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .action-button {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--admin-transition);
            text-decoration: none;
            background: transparent;
            min-width: 100px;
        }

        .action-button i {
            font-size: 0.9rem;
        }

        .btn-primary {
            color: var(--admin-accent);
            border-color: var(--admin-accent);
        }

        .btn-primary:hover {
            background: var(--admin-accent);
            color: white;
        }

        .btn-success {
            color: var(--admin-success);
            border-color: var(--admin-success);
        }

        .btn-success:hover {
            background: var(--admin-success);
            color: white;
        }

        .btn-secondary {
            color: var(--admin-secondary);
            border-color: var(--admin-secondary);
        }

        .btn-secondary:hover {
            background: var(--admin-secondary);
            color: white;
        }

        .btn-create {
            color: var(--admin-success);
            border-color: var(--admin-success);
            font-weight: 700;
        }

        .btn-create:hover {
            background: var(--admin-success);
            color: white;
        }

        @media (max-width: 1200px) {
            .certificates-grid {
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .student-header .row {
                flex-direction: column;
                gap: 1.5rem;
            }

            .certificates-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .card-actions {
                flex-direction: column;
            }

            .action-button {
                min-width: auto;
            }
        }

        @media (max-width: 480px) {
            .student-header {
                padding: 1.5rem;
            }

            .student-info {
                flex-direction: column;
                text-align: center;
                gap: 0.75rem;
            }

            .certificate-card {
                margin: 0 0.5rem;
            }
        }

        .action-button.loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .action-button.loading i {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        .certificate-card {
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .certificate-card:nth-child(1) { animation-delay: 0.1s; }
        .certificate-card:nth-child(2) { animation-delay: 0.2s; }
        .certificate-card:nth-child(3) { animation-delay: 0.3s; }
        .certificate-card:nth-child(4) { animation-delay: 0.4s; }
        .certificate-card:nth-child(5) { animation-delay: 0.5s; }
        .certificate-card:nth-child(6) { animation-delay: 0.6s; }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            document.querySelectorAll('.action-button').forEach(btn => {
                btn.addEventListener('click', function() {
                    if (!this.classList.contains('loading')) {
                        this.classList.add('loading');

                        setTimeout(() => {
                            this.classList.remove('loading');
                        }, 1500);
                    }
                });
            });

            document.querySelectorAll('.certificate-card').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.borderColor = 'var(--admin-accent)';
                });

                card.addEventListener('mouseleave', function() {
                    this.style.borderColor = 'var(--admin-border)';
                });
            });
        });
    </script>
</@layout.page>