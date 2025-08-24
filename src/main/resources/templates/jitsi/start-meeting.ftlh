<#import "../layout.ftlh" as layout>
<#import "/spring.ftl" as spring>

<#assign known = Session.SPRING_SECURITY_CONTEXT??>
<#if known>
    <#assign user = Session.SPRING_SECURITY_CONTEXT.authentication.principal>
    <#assign name = user.getFullName()>
    <#assign roles = user.getAuthorities()?join(",")>
    <#assign isAdmin = roles?contains("ADMIN")>
    <#assign isTeacher = roles?contains("TEACHER")>
    <#assign isStudent = roles?contains("STUDENT")>
    <#assign currentUserId = user.user.id>
</#if>

<@layout.page>
    <div class="main-content">
        <div class="container my-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="meeting-card shadow-lg border-0">
                        <div class="meeting-card-header">
                            <h1 class="mb-0 fw-bold text-white">
                                <i class="fas fa-video me-3"></i>
                                <@spring.message code="meeting.start.title"/>
                            </h1>
                        </div>
                        <div class="meeting-card-body">
                            <div class="text-center mb-4">
                                <div class="meeting-icon mb-3">
                                    <i class="fas fa-chalkboard-teacher display-1 text-primary"></i>
                                </div>
                                <h2 class="fw-semibold text-dark mb-3"><@spring.message code="meeting.start.ready"/></h2>
                                <p class="text-muted"><@spring.message code="meeting.start.checkDevices"/></p>
                            </div>

                            <div class="meeting-info mb-4">
                                <h6 class="fw-semibold mb-3"><@spring.message code="meeting.start.meetingInfo"/></h6>
                                <div class="info-box">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <small class="text-muted"><@spring.message code="meeting.start.teacher"/></small>
                                            <div class="fw-semibold">${name}</div>
                                        </div>
                                        <div class="col-sm-6">
                                            <small class="text-muted">Статус</small>
                                            <div><span class="status-badge">Готов к началу</span></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-3">
                                <button id="startMeetingBtn" class="btn btn-success btn-lg">
                                    <i class="fas fa-play me-2"></i>
                                    <@spring.message code="meeting.start.startButton"/>
                                </button>
                                <a href="<@spring.url '/schedules'/>" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    <@spring.message code="meeting.start.backToSchedule"/>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
            color: var(--text-dark);
            line-height: 1.6;
        }

        .main-content {
            background: linear-gradient(135deg, var(--light-blue) 0%, var(--white) 50%, var(--light-blue) 100%);
            min-height: calc(100vh - 120px);
        }

        h1 {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--dark-blue);
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark-blue);
            margin-bottom: 1.5rem;
        }

        h6 {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark-blue);
            margin-bottom: 1rem;
        }

        .meeting-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            overflow: hidden;
        }

        .meeting-card-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)) !important;
            padding: 2rem;
            text-align: center;
        }

        .meeting-card-body {
            padding: 3rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue));
            border: none;
            border-radius: 25px;
            padding: 0.8rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--dark-blue), var(--primary-blue));
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,102,204,0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            border: none;
            border-radius: 25px;
            padding: 1rem 2.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #1e7e34, #155724);
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(40, 167, 69, 0.3);
        }

        .btn-outline-secondary {
            border: 2px solid var(--light-blue);
            color: var(--primary-blue);
            border-radius: 25px;
            padding: 0.8rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            background: var(--light-blue);
            color: var(--white);
            transform: translateY(-2px);
        }

        .meeting-icon {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .info-box {
            background: rgba(135, 206, 235, 0.1);
            border-radius: 10px;
            border-left: 4px solid var(--primary-blue);
            padding: 1.5rem;
        }

        .status-badge {
            background: var(--primary-blue);
            color: var(--white);
            padding: 0.3rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 2rem;
            }

            .meeting-card-body {
                padding: 2rem;
            }
        }

        .navbar {
            background: linear-gradient(135deg, var(--primary-blue), var(--dark-blue)) !important;
            box-shadow: 0 2px 10px rgba(0,102,204,0.3);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
            color: var(--white) !important;
        }

        .navbar-nav .nav-link {
            color: var(--white) !important;
            font-weight: 600;
            font-size: 1rem;
            margin: 0 0.5rem;
            padding: 0.5rem 1rem !important;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .navbar-nav .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-1px);
        }

        .footer {
            background: linear-gradient(135deg, var(--dark-blue), var(--primary-blue));
            color: var(--white);
            padding: 3rem 0 1rem 0;
        }

        .footer h5 {
            color: var(--white);
            margin-bottom: 1rem;
        }

        .footer a {
            color: var(--light-blue);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer a:hover {
            color: var(--white);
        }

        .footer-social i {
            font-size: 1.5rem;
            margin: 0 0.5rem;
            color: var(--light-blue);
            transition: all 0.3s ease;
        }

        .footer-social i:hover {
            color: var(--white);
            transform: translateY(-2px);
        }
    </style>

    <script>
        document.getElementById('startMeetingBtn').addEventListener('click', function () {
            const btn = this;
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i><@spring.message code="meeting.start.creatingMeeting"/>';

            fetch('/api/jitsi/meetings/start', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
                },
                body: JSON.stringify({
                    teacherId: ${teacherId},
                    meetingName: 'Урок - ' + new Date().toLocaleString()
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.meetingId) {
                        window.location.href = `/jitsi/meeting/` + data.meetingId + `/join?userId=${teacherId}&userRole=TEACHER`;
                    } else {
                        throw new Error('<@spring.message code="meeting.start.error.create"/>');
                    }
                })
                .catch(error => {
                    console.error('Ошибка:', error);
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-play me-2"></i><@spring.message code="meeting.start.startButton"/>';
                    alert('<@spring.message code="meeting.start.error.general"/>');
                });
        });
    </script>
</@layout.page>